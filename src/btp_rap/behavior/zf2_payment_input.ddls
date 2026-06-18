@EndUserText.label: 'Payment input parameter'
define abstract entity ZF2_PAYMENT_INPUT {
  PaymentDate   : abap.dats;
  @Semantics.amount.currencyCode: 'CurrencyCode'
  Amount        : abap.curr(15,2);
  CurrencyCode  : abap.cuky;
  PaymentMethod : abap.char(10);
  Reference     : abap.char(40);
}
