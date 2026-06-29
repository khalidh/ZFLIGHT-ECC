using FlightService as service from './flight-service';

annotate service.Customers with @(
  odata.draft.enabled,
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Customer',
    TypeNamePlural: 'Customers',
    Title         : { Value: lastName },
    Description   : { Value: emailAddress }
  },
  UI.SelectionFields: [
    customerID,
    lastName,
    country,
    vip
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Customer Details',
      Target: '@UI.FieldGroup#General'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: customerID, Label: 'Customer' },
      { $Type: 'UI.DataField', Value: firstName, Label: 'First Name' },
      { $Type: 'UI.DataField', Value: lastName, Label: 'Last Name' },
      { $Type: 'UI.DataField', Value: emailAddress, Label: 'Email' },
      { $Type: 'UI.DataField', Value: phoneNumber, Label: 'Phone' },
      { $Type: 'UI.DataField', Value: country, Label: 'Country' },
      { $Type: 'UI.DataField', Value: language, Label: 'Language' },
      { $Type: 'UI.DataField', Value: vip, Label: 'VIP' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: customerID, Label: 'Customer' },
    { $Type: 'UI.DataField', Value: firstName, Label: 'First Name' },
    { $Type: 'UI.DataField', Value: lastName, Label: 'Last Name' },
    { $Type: 'UI.DataField', Value: emailAddress, Label: 'Email' },
    { $Type: 'UI.DataField', Value: country, Label: 'Country' },
    { $Type: 'UI.DataField', Value: vip, Label: 'VIP' }
  ]
);

annotate service.Carriers with @(
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Carrier',
    TypeNamePlural: 'Carriers',
    Title         : { Value: carrierName },
    Description   : { Value: carrierID }
  },
  UI.SelectionFields: [
    carrierID,
    carrierName,
    currencyCode
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Carrier Details',
      Target: '@UI.FieldGroup#General'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: carrierID, Label: 'Carrier' },
      { $Type: 'UI.DataField', Value: carrierName, Label: 'Name' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' },
      { $Type: 'UI.DataField', Value: url, Label: 'URL' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: carrierID, Label: 'Carrier' },
    { $Type: 'UI.DataField', Value: carrierName, Label: 'Name' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' },
    { $Type: 'UI.DataField', Value: url, Label: 'URL' }
  ]
);

annotate service.Flights with @(
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Flight',
    TypeNamePlural: 'Flights',
    Title         : { Value: flightDate },
    Description   : { Value: planeType }
  },
  UI.SelectionFields: [
    flightDate,
    flightStatus,
    currencyCode
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Flight Details',
      Target: '@UI.FieldGroup#General'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: flightDate, Label: 'Flight Date' },
      { $Type: 'UI.DataField', Value: planeType, Label: 'Plane' },
      { $Type: 'UI.DataField', Value: price, Label: 'Price' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' },
      { $Type: 'UI.DataField', Value: seatsMax, Label: 'Seats Max' },
      { $Type: 'UI.DataField', Value: seatsOccupied, Label: 'Seats Occupied' },
      { $Type: 'UI.DataField', Value: flightStatus, Label: 'Status' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: flightDate, Label: 'Flight Date' },
    { $Type: 'UI.DataField', Value: planeType, Label: 'Plane' },
    { $Type: 'UI.DataField', Value: price, Label: 'Price' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' },
    { $Type: 'UI.DataField', Value: seatsMax, Label: 'Seats Max' },
    { $Type: 'UI.DataField', Value: seatsOccupied, Label: 'Seats Occupied' },
    { $Type: 'UI.DataField', Value: flightStatus, Label: 'Status' }
  ]
);

annotate service.Bookings with @(
  odata.draft.enabled,
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Booking',
    TypeNamePlural: 'Bookings',
    Title         : { Value: bookingID },
    Description   : { Value: bookingStatus }
  },
  UI.SelectionFields: [
    bookingID,
    bookingStatus,
    seatClass,
    bookingDate
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Booking Details',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Amounts',
      Target: '@UI.FieldGroup#Amounts'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: bookingID, Label: 'Booking' },
      { $Type: 'UI.DataField', Value: customer.firstName, Label: 'First Name' },
      { $Type: 'UI.DataField', Value: customer.lastName, Label: 'Last Name' },
      { $Type: 'UI.DataField', Value: bookingDate, Label: 'Booking Date' },
      { $Type: 'UI.DataField', Value: bookingStatus, Label: 'Status' },
      { $Type: 'UI.DataField', Value: seatClass, Label: 'Class' },
      { $Type: 'UI.DataField', Value: cancelReason, Label: 'Cancel Reason' }
    ]
  },
  UI.FieldGroup #Amounts: {
    Data: [
      { $Type: 'UI.DataField', Value: baseAmount, Label: 'Base Amount' },
      { $Type: 'UI.DataField', Value: taxAmount, Label: 'Tax' },
      { $Type: 'UI.DataField', Value: totalAmount, Label: 'Total' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: bookingID, Label: 'Booking' },
    { $Type: 'UI.DataField', Value: customer.firstName, Label: 'First Name' },
    { $Type: 'UI.DataField', Value: customer.lastName, Label: 'Last Name' },
    { $Type: 'UI.DataField', Value: bookingDate, Label: 'Booking Date' },
    { $Type: 'UI.DataField', Value: bookingStatus, Label: 'Status' },
    { $Type: 'UI.DataField', Value: seatClass, Label: 'Class' },
    { $Type: 'UI.DataField', Value: baseAmount, Label: 'Base Amount' },
    { $Type: 'UI.DataField', Value: taxAmount, Label: 'Tax' },
    { $Type: 'UI.DataField', Value: totalAmount, Label: 'Total' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
  ]
);

annotate service.Orders with @(
  odata.draft.enabled,
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Order',
    TypeNamePlural: 'Orders',
    Title         : { Value: orderID },
    Description   : { Value: orderStatus }
  },
  UI.SelectionFields: [
    orderID,
    orderStatus,
    orderDate
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Order Details',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Amounts',
      Target: '@UI.FieldGroup#Amounts'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: orderID, Label: 'Order' },
      { $Type: 'UI.DataField', Value: orderDate, Label: 'Order Date' },
      { $Type: 'UI.DataField', Value: orderStatus, Label: 'Status' }
    ]
  },
  UI.FieldGroup #Amounts: {
    Data: [
      { $Type: 'UI.DataField', Value: netAmount, Label: 'Net' },
      { $Type: 'UI.DataField', Value: taxAmount, Label: 'Tax' },
      { $Type: 'UI.DataField', Value: grossAmount, Label: 'Gross' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: orderID, Label: 'Order' },
    { $Type: 'UI.DataField', Value: orderDate, Label: 'Order Date' },
    { $Type: 'UI.DataField', Value: orderStatus, Label: 'Status' },
    { $Type: 'UI.DataField', Value: netAmount, Label: 'Net' },
    { $Type: 'UI.DataField', Value: taxAmount, Label: 'Tax' },
    { $Type: 'UI.DataField', Value: grossAmount, Label: 'Gross' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
  ]
);

annotate service.Invoices with @(
  odata.draft.enabled,
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Invoice',
    TypeNamePlural: 'Invoices',
    Title         : { Value: invoiceID },
    Description   : { Value: invoiceStatus }
  },
  UI.SelectionFields: [
    invoiceID,
    invoiceStatus,
    invoiceDate
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Invoice Details',
      Target: '@UI.FieldGroup#General'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: invoiceID, Label: 'Invoice' },
      { $Type: 'UI.DataField', Value: invoiceDate, Label: 'Invoice Date' },
      { $Type: 'UI.DataField', Value: invoiceStatus, Label: 'Status' },
      { $Type: 'UI.DataField', Value: totalAmount, Label: 'Total' },
      { $Type: 'UI.DataField', Value: paidAmount, Label: 'Paid' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: invoiceID, Label: 'Invoice' },
    { $Type: 'UI.DataField', Value: invoiceDate, Label: 'Invoice Date' },
    { $Type: 'UI.DataField', Value: invoiceStatus, Label: 'Status' },
    { $Type: 'UI.DataField', Value: totalAmount, Label: 'Total' },
    { $Type: 'UI.DataField', Value: paidAmount, Label: 'Paid' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
  ]
);

annotate service.Payments with @(
  odata.draft.enabled,
  Capabilities.InsertRestrictions.Insertable: true,
  Capabilities.UpdateRestrictions.Updatable  : true,
  Capabilities.DeleteRestrictions.Deletable  : true,
  UI.HeaderInfo: {
    TypeName      : 'Payment',
    TypeNamePlural: 'Payments',
    Title         : { Value: paymentID },
    Description   : { Value: paymentMethod }
  },
  UI.SelectionFields: [
    paymentID,
    paymentMethod,
    paymentDate
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Payment Details',
      Target: '@UI.FieldGroup#General'
    }
  ],
  UI.FieldGroup #General: {
    Data: [
      { $Type: 'UI.DataField', Value: paymentID, Label: 'Payment' },
      { $Type: 'UI.DataField', Value: paymentDate, Label: 'Payment Date' },
      { $Type: 'UI.DataField', Value: paymentMethod, Label: 'Method' },
      { $Type: 'UI.DataField', Value: reference, Label: 'Reference' },
      { $Type: 'UI.DataField', Value: amount, Label: 'Amount' },
      { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
    ]
  },
  UI.LineItem: [
    { $Type: 'UI.DataField', Value: paymentID, Label: 'Payment' },
    { $Type: 'UI.DataField', Value: paymentDate, Label: 'Payment Date' },
    { $Type: 'UI.DataField', Value: paymentMethod, Label: 'Method' },
    { $Type: 'UI.DataField', Value: reference, Label: 'Reference' },
    { $Type: 'UI.DataField', Value: amount, Label: 'Amount' },
    { $Type: 'UI.DataField', Value: currencyCode, Label: 'Currency' }
  ]
);
