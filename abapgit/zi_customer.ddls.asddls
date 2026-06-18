@EndUserText.label: 'Flight Customer'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_Customer
  as select from zfl_customer
  composition [0..*] of ZI_Booking as _Bookings
{
  key customer_id as CustomerID,
      first_name as FirstName,
      last_name as LastName,
      email_address as EmailAddress,
      phone_number as PhoneNumber,
      country as Country,
      language as Language,
      vip as Vip,
      created_by as CreatedBy,
      created_at as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      _Bookings
}

