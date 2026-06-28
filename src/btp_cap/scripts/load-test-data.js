const cds = require('@sap/cds');

const DAY_MS = 24 * 60 * 60 * 1000;

function dateOffset(days) {
  return new Date(Date.now() + days * DAY_MS).toISOString().slice(0, 10);
}

function timestamp() {
  return new Date().toISOString();
}

async function reset(db) {
  const tables = [
    'zflight.StatusHistory',
    'zflight.Payments',
    'zflight.Invoices',
    'zflight.OrderItems',
    'zflight.Orders',
    'zflight.Bookings',
    'zflight.Flights',
    'zflight.Connections',
    'zflight.Customers',
    'zflight.Carriers'
  ];

  for (const table of tables) {
    await db.run(DELETE.from(table));
  }
}

function managed(now, user = 'cap-test-loader') {
  return {
    createdAt: now,
    createdBy: user,
    modifiedAt: now,
    modifiedBy: user
  };
}

async function insertTestData(db) {
  const now = timestamp();
  const user = 'cap-test-loader';

  await db.run(INSERT.into('zflight.Carriers').entries([
    { carrierID: 'LH', carrierName: 'Lufthansa', currencyCode: 'EUR', url: 'https://www.lufthansa.com', ...managed(now, user) },
    { carrierID: 'AF', carrierName: 'Air France', currencyCode: 'EUR', url: 'https://www.airfrance.com', ...managed(now, user) },
    { carrierID: 'BA', carrierName: 'British Airways', currencyCode: 'GBP', url: 'https://www.britishairways.com', ...managed(now, user) },
    { carrierID: 'UA', carrierName: 'United Airlines', currencyCode: 'USD', url: 'https://www.united.com', ...managed(now, user) },
    { carrierID: 'SQ', carrierName: 'Singapore Airlines', currencyCode: 'SGD', url: 'https://www.singaporeair.com', ...managed(now, user) }
  ]));

  await db.run(INSERT.into('zflight.Connections').entries([
    { carrier_carrierID: 'LH', connectionID: '0400', countryFrom: 'DE', cityFrom: 'Frankfurt', airportFrom: 'FRA', countryTo: 'US', cityTo: 'New York', airportTo: 'JFK', flightTime: 510, departureTime: '10:15:00', arrivalTime: '12:45:00', distance: 6200, distanceUnit: 'KM' },
    { carrier_carrierID: 'LH', connectionID: '0401', countryFrom: 'DE', cityFrom: 'Munich', airportFrom: 'MUC', countryTo: 'FR', cityTo: 'Paris', airportTo: 'CDG', flightTime: 95, departureTime: '08:10:00', arrivalTime: '09:45:00', distance: 680, distanceUnit: 'KM' },
    { carrier_carrierID: 'AF', connectionID: '0188', countryFrom: 'FR', cityFrom: 'Paris', airportFrom: 'CDG', countryTo: 'US', cityTo: 'Boston', airportTo: 'BOS', flightTime: 450, departureTime: '13:30:00', arrivalTime: '15:45:00', distance: 5530, distanceUnit: 'KM' },
    { carrier_carrierID: 'BA', connectionID: '0701', countryFrom: 'GB', cityFrom: 'London', airportFrom: 'LHR', countryTo: 'DE', cityTo: 'Berlin', airportTo: 'BER', flightTime: 115, departureTime: '09:15:00', arrivalTime: '12:10:00', distance: 930, distanceUnit: 'KM' },
    { carrier_carrierID: 'UA', connectionID: '0900', countryFrom: 'US', cityFrom: 'Chicago', airportFrom: 'ORD', countryTo: 'US', cityTo: 'San Francisco', airportTo: 'SFO', flightTime: 270, departureTime: '07:00:00', arrivalTime: '09:30:00', distance: 2980, distanceUnit: 'KM' },
    { carrier_carrierID: 'SQ', connectionID: '0326', countryFrom: 'SG', cityFrom: 'Singapore', airportFrom: 'SIN', countryTo: 'DE', cityTo: 'Frankfurt', airportTo: 'FRA', flightTime: 780, departureTime: '23:55:00', arrivalTime: '06:20:00', distance: 10300, distanceUnit: 'KM' }
  ]));

  await db.run(INSERT.into('zflight.Flights').entries([
    { carrier_carrierID: 'LH', connection_carrier_carrierID: 'LH', connection_connectionID: '0400', flightDate: dateOffset(7), price: 780, currencyCode: 'EUR', planeType: 'A350', seatsMax: 280, seatsOccupied: 142, flightStatus: 'OPEN' },
    { carrier_carrierID: 'LH', connection_carrier_carrierID: 'LH', connection_connectionID: '0401', flightDate: dateOffset(14), price: 180, currencyCode: 'EUR', planeType: 'A320', seatsMax: 180, seatsOccupied: 96, flightStatus: 'OPEN' },
    { carrier_carrierID: 'AF', connection_carrier_carrierID: 'AF', connection_connectionID: '0188', flightDate: dateOffset(21), price: 720, currencyCode: 'EUR', planeType: 'B789', seatsMax: 250, seatsOccupied: 201, flightStatus: 'OPEN' },
    { carrier_carrierID: 'BA', connection_carrier_carrierID: 'BA', connection_connectionID: '0701', flightDate: dateOffset(10), price: 160, currencyCode: 'GBP', planeType: 'A320', seatsMax: 170, seatsOccupied: 118, flightStatus: 'OPEN' },
    { carrier_carrierID: 'UA', connection_carrier_carrierID: 'UA', connection_connectionID: '0900', flightDate: dateOffset(5), price: 320, currencyCode: 'USD', planeType: 'B738', seatsMax: 166, seatsOccupied: 151, flightStatus: 'BOARDING' },
    { carrier_carrierID: 'SQ', connection_carrier_carrierID: 'SQ', connection_connectionID: '0326', flightDate: dateOffset(30), price: 1250, currencyCode: 'SGD', planeType: 'A380', seatsMax: 470, seatsOccupied: 318, flightStatus: 'OPEN' }
  ]));

  await db.run(INSERT.into('zflight.Customers').entries([
    { customerID: '0000001001', firstName: 'Sofia', lastName: 'Martin', emailAddress: 'sofia.martin@example.com', phoneNumber: '+33155501001', country: 'FR', language: 'FR', vip: true, ...managed(now, user) },
    { customerID: '0000001002', firstName: 'Jonas', lastName: 'Becker', emailAddress: 'jonas.becker@example.com', phoneNumber: '+496955501002', country: 'DE', language: 'DE', vip: false, ...managed(now, user) },
    { customerID: '0000001003', firstName: 'Emma', lastName: 'Wilson', emailAddress: 'emma.wilson@example.com', phoneNumber: '+442055501003', country: 'GB', language: 'EN', vip: true, ...managed(now, user) },
    { customerID: '0000001004', firstName: 'Noah', lastName: 'Carter', emailAddress: 'noah.carter@example.com', phoneNumber: '+131255501004', country: 'US', language: 'EN', vip: false, ...managed(now, user) },
    { customerID: '0000001005', firstName: 'Aisha', lastName: 'Rahman', emailAddress: 'aisha.rahman@example.com', phoneNumber: '+65655501005', country: 'SG', language: 'EN', vip: true, ...managed(now, user) }
  ]));

  await db.run(INSERT.into('zflight.Bookings').entries([
    { bookingID: '0000005001', customer_customerID: '0000001001', flight_carrier_carrierID: 'LH', flight_connection_carrier_carrierID: 'LH', flight_connection_connectionID: '0400', flight_flightDate: dateOffset(7), bookingDate: dateOffset(-10), bookingStatus: 'CONFIRMED', seatClass: 'BUS', baseAmount: 780, taxAmount: 156, totalAmount: 936, currencyCode: 'EUR' },
    { bookingID: '0000005002', customer_customerID: '0000001002', flight_carrier_carrierID: 'LH', flight_connection_carrier_carrierID: 'LH', flight_connection_connectionID: '0401', flight_flightDate: dateOffset(14), bookingDate: dateOffset(-3), bookingStatus: 'NEW', seatClass: 'ECO', baseAmount: 180, taxAmount: 36, totalAmount: 216, currencyCode: 'EUR' },
    { bookingID: '0000005003', customer_customerID: '0000001003', flight_carrier_carrierID: 'BA', flight_connection_carrier_carrierID: 'BA', flight_connection_connectionID: '0701', flight_flightDate: dateOffset(10), bookingDate: dateOffset(-6), bookingStatus: 'CONFIRMED', seatClass: 'ECO', baseAmount: 160, taxAmount: 32, totalAmount: 192, currencyCode: 'GBP' },
    { bookingID: '0000005004', customer_customerID: '0000001004', flight_carrier_carrierID: 'UA', flight_connection_carrier_carrierID: 'UA', flight_connection_connectionID: '0900', flight_flightDate: dateOffset(5), bookingDate: dateOffset(-20), bookingStatus: 'CANCELLED', seatClass: 'ECO', baseAmount: 320, taxAmount: 64, totalAmount: 384, currencyCode: 'USD', cancelReason: 'Customer requested cancellation' },
    { bookingID: '0000005005', customer_customerID: '0000001005', flight_carrier_carrierID: 'SQ', flight_connection_carrier_carrierID: 'SQ', flight_connection_connectionID: '0326', flight_flightDate: dateOffset(30), bookingDate: dateOffset(-2), bookingStatus: 'CONFIRMED', seatClass: 'FST', baseAmount: 1250, taxAmount: 250, totalAmount: 1500, currencyCode: 'SGD' }
  ]));

  await db.run(INSERT.into('zflight.Orders').entries([
    { orderID: '0000007001', booking_bookingID: '0000005001', customer_customerID: '0000001001', orderDate: dateOffset(-9), orderStatus: 'RELEASED', netAmount: 780, taxAmount: 156, grossAmount: 936, currencyCode: 'EUR' },
    { orderID: '0000007002', booking_bookingID: '0000005003', customer_customerID: '0000001003', orderDate: dateOffset(-5), orderStatus: 'NEW', netAmount: 160, taxAmount: 32, grossAmount: 192, currencyCode: 'GBP' },
    { orderID: '0000007003', booking_bookingID: '0000005005', customer_customerID: '0000001005', orderDate: dateOffset(-1), orderStatus: 'RELEASED', netAmount: 1250, taxAmount: 250, grossAmount: 1500, currencyCode: 'SGD' }
  ]));

  await db.run(INSERT.into('zflight.OrderItems').entries([
    { order_orderID: '0000007001', itemNo: '000010', conditionType: 'FARE', description: 'Business fare FRA-JFK', quantity: 1, quantityUnit: 'EA', amount: 780, currencyCode: 'EUR' },
    { order_orderID: '0000007001', itemNo: '000020', conditionType: 'TAX', description: 'Taxes and fees', quantity: 1, quantityUnit: 'EA', amount: 156, currencyCode: 'EUR' },
    { order_orderID: '0000007002', itemNo: '000010', conditionType: 'FARE', description: 'Economy fare LHR-BER', quantity: 1, quantityUnit: 'EA', amount: 160, currencyCode: 'GBP' },
    { order_orderID: '0000007002', itemNo: '000020', conditionType: 'TAX', description: 'Taxes and fees', quantity: 1, quantityUnit: 'EA', amount: 32, currencyCode: 'GBP' },
    { order_orderID: '0000007003', itemNo: '000010', conditionType: 'FARE', description: 'First fare SIN-FRA', quantity: 1, quantityUnit: 'EA', amount: 1250, currencyCode: 'SGD' },
    { order_orderID: '0000007003', itemNo: '000020', conditionType: 'TAX', description: 'Taxes and fees', quantity: 1, quantityUnit: 'EA', amount: 250, currencyCode: 'SGD' }
  ]));

  await db.run(INSERT.into('zflight.Invoices').entries([
    { invoiceID: '0000009001', order_orderID: '0000007001', invoiceDate: dateOffset(-8), invoiceStatus: 'PAID', totalAmount: 936, paidAmount: 936, currencyCode: 'EUR' },
    { invoiceID: '0000009002', order_orderID: '0000007003', invoiceDate: dateOffset(0), invoiceStatus: 'OPEN', totalAmount: 1500, paidAmount: 0, currencyCode: 'SGD' }
  ]));

  await db.run(INSERT.into('zflight.Payments').entries([
    { paymentID: '0000011001', invoice_invoiceID: '0000009001', paymentDate: dateOffset(-7), amount: 936, currencyCode: 'EUR', paymentMethod: 'CARD', reference: 'VISA-936-5001' }
  ]));

  await db.run(INSERT.into('zflight.StatusHistory').entries([
    { ID: '00000000-0000-0000-0000-000000005001', objectType: 'BOOKING', objectID: '0000005001', oldStatus: 'NEW', newStatus: 'CONFIRMED', changedBy: user, changedAt: now, changeReason: 'Test confirmation' },
    { ID: '00000000-0000-0000-0000-000000005004', objectType: 'BOOKING', objectID: '0000005004', oldStatus: 'NEW', newStatus: 'CANCELLED', changedBy: user, changedAt: now, changeReason: 'Test cancellation' },
    { ID: '00000000-0000-0000-0000-000000007001', objectType: 'ORDER', objectID: '0000007001', oldStatus: 'NEW', newStatus: 'RELEASED', changedBy: user, changedAt: now, changeReason: 'Test release' },
    { ID: '00000000-0000-0000-0000-000000009001', objectType: 'INVOICE', objectID: '0000009001', oldStatus: 'OPEN', newStatus: 'PAID', changedBy: user, changedAt: now, changeReason: 'Test payment' }
  ]));
}

class Zf2CapTestDataGenerator {
  constructor(db) {
    this.db = db;
  }

  async generate() {
    await reset(this.db);
    await insertTestData(this.db);
  }
}

async function main() {
  cds.model = await cds.load('*');
  const db = await cds.connect.to('db');
  const generator = new Zf2CapTestDataGenerator(db);
  await generator.generate();
  console.log('Test data loaded for ZFLIGHT CAP tables.');
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

module.exports = {
  Zf2CapTestDataGenerator
};
