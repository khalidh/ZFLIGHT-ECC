@EndUserText.label: 'Booking cancellation parameter'
define abstract entity ZF2_BookingCancelParameter {
  CancelReason : abap.char(80);
}

@EndUserText.label: 'Payment input parameter'
define abstract entity ZF2_PaymentInput {
  PaymentDate   : abap.dats;
  Amount        : abap.curr(15,2);
  CurrencyCode  : abap.cuky;
  PaymentMethod : abap.char(10);
  Reference     : abap.char(40);
}

