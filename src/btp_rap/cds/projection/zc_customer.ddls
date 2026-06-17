@EndUserText.label: 'Manage Customers'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_Customer
  provider contract transactional_query
  as projection on ZI_Customer
{
  key CustomerID,
      FirstName,
      LastName,
      EmailAddress,
      PhoneNumber,
      Country,
      Language,
      Vip,
      _Bookings : redirected to composition child ZC_Booking
}

