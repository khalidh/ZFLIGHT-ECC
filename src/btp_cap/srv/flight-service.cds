using zflight as db from '../db/schema';

service FlightService {
  entity Carriers      as projection on db.Carriers;
  entity Connections   as projection on db.Connections;
  entity Flights       as projection on db.Flights;
  entity Customers     as projection on db.Customers;
  entity Bookings      as projection on db.Bookings;
  entity Orders        as projection on db.Orders;
  entity OrderItems    as projection on db.OrderItems;
  entity Invoices      as projection on db.Invoices;
  entity Payments      as projection on db.Payments;
  entity StatusHistory as projection on db.StatusHistory;

  action createBooking(
    customerID   : String(10),
    carrierID    : String(3),
    connectionID : String(4),
    flightDate   : Date,
    seatClass    : String(3)
  ) returns Bookings;

  action cancelBooking(
    bookingID : String(10),
    reason    : String(80)
  ) returns Bookings;

  action createOrderFromBooking(
    bookingID : String(10)
  ) returns Orders;

  action createInvoiceFromOrder(
    orderID : String(10)
  ) returns Invoices;

  action registerPayment(
    invoiceID     : String(10),
    amount        : Decimal(15, 2),
    paymentMethod : String(10),
    reference     : String(40)
  ) returns Payments;
}
