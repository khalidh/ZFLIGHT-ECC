const TAX_RATE = 0.2;
const FUEL_RATE = 0.05;
const SEAT_CLASS_MULTIPLIERS = {
  ECO: 1,
  BUS: 1.8,
  FST: 3
};

function today() {
  return new Date().toISOString().slice(0, 10);
}

function roundAmount(value) {
  return Math.round((Number(value) + Number.EPSILON) * 100) / 100;
}

function calculatePrice(baseAmount, currencyCode, seatClass = 'ECO') {
  const multiplier = SEAT_CLASS_MULTIPLIERS[seatClass] || SEAT_CLASS_MULTIPLIERS.ECO;
  const base = roundAmount(Number(baseAmount) * multiplier);
  const fuel = roundAmount(base * FUEL_RATE);
  const tax = roundAmount((base + fuel) * TAX_RATE);

  return {
    baseAmount: base,
    taxAmount: tax,
    totalAmount: roundAmount(base + fuel + tax),
    currencyCode
  };
}

function nextBusinessID(prefix, currentCount) {
  return `${prefix}${String(currentCount + 1).padStart(9, '0')}`.slice(-10);
}

async function nextID(tx, entity, prefix) {
  const rows = await tx.run(SELECT.one.from(entity).columns('count(1) as count'));
  return nextBusinessID(prefix, rows?.count || 0);
}

function requireFound(req, value, message) {
  if (!value) {
    return req.reject(404, message);
  }
  return value;
}

async function addStatusHistory(tx, objectType, objectID, oldStatus, newStatus, reason, user) {
  await tx.run(INSERT.into('zflight.StatusHistory').entries({
    objectType,
    objectID,
    oldStatus,
    newStatus,
    changedBy: user?.id || 'anonymous',
    changedAt: new Date().toISOString(),
    changeReason: reason
  }));
}

function createFlightHandlers(service, cds) {
  const {
    Flights,
    Customers,
    Bookings,
    Orders,
    OrderItems,
    Invoices,
    Payments
  } = service.entities;

  service.on('createBooking', async (req) => {
    const { customerID, carrierID, connectionID, flightDate, seatClass = 'ECO' } = req.data;
    const tx = cds.tx(req);

    const customer = await tx.run(SELECT.one.from(Customers).where({ customerID }));
    requireFound(req, customer, `Customer ${customerID} not found`);

    const flightKey = {
      carrier_carrierID: carrierID,
      connection_carrier_carrierID: carrierID,
      connection_connectionID: connectionID,
      flightDate
    };
    const flight = await tx.run(SELECT.one.from(Flights).where(flightKey));
    requireFound(req, flight, `Flight ${carrierID}/${connectionID}/${flightDate} not found`);

    if (flight.flightStatus !== 'OPEN' || Number(flight.seatsOccupied) >= Number(flight.seatsMax)) {
      return req.reject(409, 'Flight capacity is exceeded or the flight is not open');
    }

    const price = calculatePrice(flight.price, flight.currencyCode, seatClass);
    const bookingID = await nextID(tx, Bookings, 'B');
    const booking = {
      bookingID,
      customer_customerID: customerID,
      flight_carrier_carrierID: carrierID,
      flight_connection_carrier_carrierID: carrierID,
      flight_connection_connectionID: connectionID,
      flight_flightDate: flightDate,
      bookingDate: today(),
      bookingStatus: 'NEW',
      seatClass,
      ...price
    };

    await tx.run(INSERT.into(Bookings).entries(booking));
    await tx.run(UPDATE(Flights).set({ seatsOccupied: Number(flight.seatsOccupied || 0) + 1 }).where(flightKey));
    await addStatusHistory(tx, 'BOOKING', bookingID, null, 'NEW', 'Booking created', req.user);

    return tx.run(SELECT.one.from(Bookings).where({ bookingID }));
  });

  service.on('cancelBooking', async (req) => {
    const { bookingID, reason } = req.data;
    const tx = cds.tx(req);
    const booking = await tx.run(SELECT.one.from(Bookings).where({ bookingID }));
    requireFound(req, booking, `Booking ${bookingID} not found`);

    if (['CANCELLED', 'FLOWN'].includes(booking.bookingStatus)) {
      return req.reject(409, `Booking ${bookingID} cannot be cancelled from status ${booking.bookingStatus}`);
    }

    const flightKey = {
      carrier_carrierID: booking.flight_carrier_carrierID,
      connection_carrier_carrierID: booking.flight_connection_carrier_carrierID,
      connection_connectionID: booking.flight_connection_connectionID,
      flightDate: booking.flight_flightDate
    };
    const oldStatus = booking.bookingStatus;

    await tx.run(UPDATE(Bookings).set({
      bookingStatus: 'CANCELLED',
      cancelReason: reason
    }).where({ bookingID }));
    await tx.run(UPDATE(Flights).set('seatsOccupied -=', 1).where({
      ...flightKey,
      'seatsOccupied >': 0
    }));
    await addStatusHistory(tx, 'BOOKING', bookingID, oldStatus, 'CANCELLED', reason, req.user);

    return tx.run(SELECT.one.from(Bookings).where({ bookingID }));
  });

  service.on('createOrderFromBooking', async (req) => {
    const { bookingID } = req.data;
    const tx = cds.tx(req);
    const booking = await tx.run(SELECT.one.from(Bookings).where({ bookingID }));
    requireFound(req, booking, `Booking ${bookingID} not found`);

    if (!['NEW', 'CONFIRMED'].includes(booking.bookingStatus)) {
      return req.reject(409, `Booking ${bookingID} cannot create an order from status ${booking.bookingStatus}`);
    }

    const orderID = await nextID(tx, Orders, 'O');
    const order = {
      orderID,
      booking_bookingID: bookingID,
      customer_customerID: booking.customer_customerID,
      orderDate: today(),
      orderStatus: 'OPEN',
      netAmount: booking.baseAmount,
      taxAmount: booking.taxAmount,
      grossAmount: booking.totalAmount,
      currencyCode: booking.currencyCode
    };

    await tx.run(INSERT.into(Orders).entries(order));
    await tx.run(INSERT.into(OrderItems).entries({
      order_orderID: orderID,
      itemNo: '000010',
      conditionType: 'PR00',
      description: 'Flight reservation',
      quantity: 1,
      quantityUnit: 'EA',
      amount: booking.baseAmount,
      currencyCode: booking.currencyCode
    }));
    await addStatusHistory(tx, 'ORDER', orderID, null, 'OPEN', `Created from booking ${bookingID}`, req.user);

    return tx.run(SELECT.one.from(Orders).where({ orderID }));
  });

  service.on('createInvoiceFromOrder', async (req) => {
    const { orderID } = req.data;
    const tx = cds.tx(req);
    const order = await tx.run(SELECT.one.from(Orders).where({ orderID }));
    requireFound(req, order, `Order ${orderID} not found`);

    if (order.orderStatus === 'CLOSED') {
      return req.reject(409, `Order ${orderID} is already closed`);
    }

    const invoiceID = await nextID(tx, Invoices, 'I');
    const invoice = {
      invoiceID,
      order_orderID: orderID,
      invoiceDate: today(),
      invoiceStatus: 'OPEN',
      totalAmount: order.grossAmount,
      paidAmount: 0,
      currencyCode: order.currencyCode
    };

    await tx.run(INSERT.into(Invoices).entries(invoice));
    await tx.run(UPDATE(Orders).set({ orderStatus: 'INVOICED' }).where({ orderID }));
    await addStatusHistory(tx, 'INVOICE', invoiceID, null, 'OPEN', `Created from order ${orderID}`, req.user);
    await addStatusHistory(tx, 'ORDER', orderID, order.orderStatus, 'INVOICED', `Invoice ${invoiceID} created`, req.user);

    return tx.run(SELECT.one.from(Invoices).where({ invoiceID }));
  });

  service.on('registerPayment', async (req) => {
    const { invoiceID, amount, paymentMethod, reference } = req.data;
    const tx = cds.tx(req);
    const invoice = await tx.run(SELECT.one.from(Invoices).where({ invoiceID }));
    requireFound(req, invoice, `Invoice ${invoiceID} not found`);

    if (invoice.invoiceStatus !== 'OPEN') {
      return req.reject(409, `Invoice ${invoiceID} is not open`);
    }
    if (Number(amount) < Number(invoice.totalAmount)) {
      return req.reject(400, 'Payment amount must cover the invoice total amount');
    }

    const paymentID = await nextID(tx, Payments, 'P');
    const payment = {
      paymentID,
      invoice_invoiceID: invoiceID,
      paymentDate: today(),
      amount,
      currencyCode: invoice.currencyCode,
      paymentMethod,
      reference
    };

    await tx.run(INSERT.into(Payments).entries(payment));
    await tx.run(UPDATE(Invoices).set({
      invoiceStatus: 'PAID',
      paidAmount: amount
    }).where({ invoiceID }));
    await tx.run(UPDATE(Orders).set({ orderStatus: 'CLOSED' }).where({ orderID: invoice.order_orderID }));
    await addStatusHistory(tx, 'PAYMENT', paymentID, null, 'POSTED', `Payment for invoice ${invoiceID}`, req.user);
    await addStatusHistory(tx, 'INVOICE', invoiceID, invoice.invoiceStatus, 'PAID', `Payment ${paymentID} registered`, req.user);
    await addStatusHistory(tx, 'ORDER', invoice.order_orderID, 'INVOICED', 'CLOSED', `Invoice ${invoiceID} paid`, req.user);

    return tx.run(SELECT.one.from(Payments).where({ paymentID }));
  });
}

module.exports = {
  calculatePrice,
  createFlightHandlers,
  nextBusinessID
};
