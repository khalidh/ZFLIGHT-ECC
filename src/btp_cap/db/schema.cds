namespace zflight;

using {
  cuid,
  managed
} from '@sap/cds/common';

type CarrierID     : String(3);
type ConnectionID  : String(4);
type BusinessID    : String(10);
type CurrencyCode  : String(3);
type Amount        : Decimal(15, 2);
type Quantity      : Decimal(13, 3);
type StatusCode    : String(10);

entity Carriers : managed {
  key carrierID    : CarrierID;
      carrierName  : String(40);
      currencyCode : CurrencyCode;
      url          : String(255);
      connections  : Composition of many Connections on connections.carrier = $self;
}

entity Connections {
  key carrier      : Association to Carriers;
  key connectionID : ConnectionID;
      countryFrom  : String(3);
      cityFrom     : String(40);
      airportFrom  : String(3);
      countryTo    : String(3);
      cityTo       : String(40);
      airportTo    : String(3);
      flightTime   : Integer;
      departureTime: Time;
      arrivalTime  : Time;
      distance     : Decimal(9, 2);
      distanceUnit : String(3);
      flights      : Composition of many Flights on flights.connection = $self;
}

entity Flights {
  key carrier      : Association to Carriers;
  key connection   : Association to Connections;
  key flightDate   : Date;
      price        : Amount;
      currencyCode : CurrencyCode;
      planeType    : String(10);
      seatsMax     : Integer;
      seatsOccupied: Integer default 0;
      flightStatus : StatusCode default 'OPEN';
      bookings     : Association to many Bookings on bookings.flight = $self;
}

entity Customers : managed {
  key customerID   : BusinessID;
      firstName    : String(40);
      lastName     : String(40);
      emailAddress : String(241);
      phoneNumber  : String(30);
      country      : String(3);
      language     : String(2);
      vip          : Boolean default false;
      bookings     : Association to many Bookings on bookings.customer = $self;
}

entity Bookings {
  key bookingID    : BusinessID;
      customer     : Association to Customers;
      flight       : Association to Flights;
      bookingDate  : Date;
      bookingStatus: StatusCode default 'NEW';
      seatClass    : String(3) default 'ECO';
      baseAmount   : Amount;
      taxAmount    : Amount;
      totalAmount  : Amount;
      currencyCode : CurrencyCode;
      cancelReason : String(80);
      orders       : Association to many Orders on orders.booking = $self;
}

entity Orders {
  key orderID     : BusinessID;
      booking     : Association to Bookings;
      customer    : Association to Customers;
      orderDate   : Date;
      orderStatus : StatusCode default 'OPEN';
      netAmount   : Amount;
      taxAmount   : Amount;
      grossAmount : Amount;
      currencyCode: CurrencyCode;
      items       : Composition of many OrderItems on items.order = $self;
      invoices    : Association to many Invoices on invoices.order = $self;
}

entity OrderItems {
  key order         : Association to Orders;
  key itemNo        : String(6);
      conditionType : String(4);
      description   : String(80);
      quantity      : Quantity;
      quantityUnit  : String(3);
      amount        : Amount;
      currencyCode  : CurrencyCode;
}

entity Invoices {
  key invoiceID    : BusinessID;
      order        : Association to Orders;
      invoiceDate  : Date;
      invoiceStatus: StatusCode default 'OPEN';
      totalAmount  : Amount;
      paidAmount   : Amount default 0;
      currencyCode : CurrencyCode;
      payments     : Association to many Payments on payments.invoice = $self;
}

entity Payments {
  key paymentID    : BusinessID;
      invoice      : Association to Invoices;
      paymentDate  : Date;
      amount       : Amount;
      currencyCode : CurrencyCode;
      paymentMethod: String(10);
      reference    : String(40);
}

entity StatusHistory : cuid {
  objectType   : String(20);
  objectID     : String(30);
  oldStatus    : StatusCode;
  newStatus    : StatusCode;
  changedBy    : String(80);
  changedAt    : Timestamp;
  changeReason : String(80);
}
