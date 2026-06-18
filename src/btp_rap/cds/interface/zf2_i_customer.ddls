@EndUserText.label: 'Flight Customer'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZF2_I_Customer
  as select from zf2_customer
  association [0..*] to ZF2_I_Booking as _Bookings
    on $projection.CustomerID = _Bookings.CustomerID
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
