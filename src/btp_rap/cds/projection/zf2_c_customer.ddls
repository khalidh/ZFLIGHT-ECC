@EndUserText.label: 'Manage Customers'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZF2_C_Customer
  provider contract transactional_query
  as projection on ZF2_I_Customer
{
  key CustomerID,
      FirstName,
      LastName,
      EmailAddress,
      PhoneNumber,
      Country,
      Language,
      Vip,
      _Bookings : redirected to composition child ZF2_C_Booking
}

