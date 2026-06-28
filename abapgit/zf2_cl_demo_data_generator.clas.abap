CLASS zf2_cl_demo_data_generator DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS generate.
ENDCLASS.

CLASS zf2_cl_demo_data_generator IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    generate( ).
    out->write( 'Demo data loaded for ZF2 flight RAP tables.' ).
  ENDMETHOD.

  METHOD generate.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    DELETE FROM zf2_status_hist.
    DELETE FROM zf2_payment.
    DELETE FROM zf2_invoice.
    DELETE FROM zf2_order_item.
    DELETE FROM zf2_order.
    DELETE FROM zf2_booking.
    DELETE FROM zf2_flight.
    DELETE FROM zf2_connection.
    DELETE FROM zf2_customer.
    DELETE FROM zf2_carrier.

    DATA lt_carriers TYPE STANDARD TABLE OF zf2_carrier.
    lt_carriers = VALUE #(
      ( client = sy-mandt carrier_id = 'LH'  carrier_name = 'Lufthansa'           currency_code = 'EUR' url = 'https://www.lufthansa.com'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'AF'  carrier_name = 'Air France'          currency_code = 'EUR' url = 'https://www.airfrance.com'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'BA'  carrier_name = 'British Airways'     currency_code = 'GBP' url = 'https://www.britishairways.com'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'UA'  carrier_name = 'United Airlines'     currency_code = 'USD' url = 'https://www.united.com'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'SQ'  carrier_name = 'Singapore Airlines'  currency_code = 'SGD' url = 'https://www.singaporeair.com'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp ) ).
    INSERT zf2_carrier FROM TABLE @lt_carriers.

    DATA lt_connections TYPE STANDARD TABLE OF zf2_connection.
    lt_connections = VALUE #(
      ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' country_from = 'DE' city_from = 'Frankfurt' airport_from = 'FRA'
        country_to = 'US' city_to = 'New York'  airport_to = 'JFK' flight_time = 510 departure_time = '101500' arrival_time = '124500' distance = '6200.00' distance_unit = 'KM' )
      ( client = sy-mandt carrier_id = 'LH' connection_id = '0401' country_from = 'DE' city_from = 'Munich'    airport_from = 'MUC'
        country_to = 'FR' city_to = 'Paris'     airport_to = 'CDG' flight_time = 95  departure_time = '081000' arrival_time = '094500' distance = '680.00'  distance_unit = 'KM' )
      ( client = sy-mandt carrier_id = 'AF' connection_id = '0188' country_from = 'FR' city_from = 'Paris'     airport_from = 'CDG'
        country_to = 'US' city_to = 'Boston'    airport_to = 'BOS' flight_time = 450 departure_time = '133000' arrival_time = '154500' distance = '5530.00' distance_unit = 'KM' )
      ( client = sy-mandt carrier_id = 'BA' connection_id = '0701' country_from = 'GB' city_from = 'London'    airport_from = 'LHR'
        country_to = 'DE' city_to = 'Berlin'    airport_to = 'BER' flight_time = 115 departure_time = '091500' arrival_time = '121000' distance = '930.00'  distance_unit = 'KM' )
      ( client = sy-mandt carrier_id = 'UA' connection_id = '0900' country_from = 'US' city_from = 'Chicago'   airport_from = 'ORD'
        country_to = 'US' city_to = 'San Francisco' airport_to = 'SFO' flight_time = 270 departure_time = '070000' arrival_time = '093000' distance = '2980.00' distance_unit = 'KM' )
      ( client = sy-mandt carrier_id = 'SQ' connection_id = '0326' country_from = 'SG' city_from = 'Singapore' airport_from = 'SIN'
        country_to = 'DE' city_to = 'Frankfurt' airport_to = 'FRA' flight_time = 780 departure_time = '235500' arrival_time = '062000' distance = '10300.00' distance_unit = 'KM' ) ).
    INSERT zf2_connection FROM TABLE @lt_connections.

    DATA lt_flights TYPE STANDARD TABLE OF zf2_flight.
    lt_flights = VALUE #(
      ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = lv_today + 7  price = '780.00'  currency_code = 'EUR'
        plane_type = 'A350' seats_max = 280 seats_occupied = 142 flight_status = 'OPEN' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'LH' connection_id = '0401' flight_date = lv_today + 14 price = '180.00'  currency_code = 'EUR'
        plane_type = 'A320' seats_max = 180 seats_occupied = 96  flight_status = 'OPEN' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'AF' connection_id = '0188' flight_date = lv_today + 21 price = '720.00'  currency_code = 'EUR'
        plane_type = 'B789' seats_max = 250 seats_occupied = 201 flight_status = 'OPEN' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'BA' connection_id = '0701' flight_date = lv_today + 10 price = '160.00'  currency_code = 'GBP'
        plane_type = 'A320' seats_max = 170 seats_occupied = 118 flight_status = 'OPEN' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'UA' connection_id = '0900' flight_date = lv_today + 5  price = '320.00'  currency_code = 'USD'
        plane_type = 'B738' seats_max = 166 seats_occupied = 151 flight_status = 'BOARDING'  local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt carrier_id = 'SQ' connection_id = '0326' flight_date = lv_today + 30 price = '1250.00' currency_code = 'SGD'
        plane_type = 'A380' seats_max = 470 seats_occupied = 318 flight_status = 'OPEN' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp ) ).
    INSERT zf2_flight FROM TABLE @lt_flights.

    DATA lt_customers TYPE STANDARD TABLE OF zf2_customer.
    lt_customers = VALUE #(
      ( client = sy-mandt customer_id = '0000001001' first_name = 'Sofia'  last_name = 'Martin'
        email_address = 'sofia.martin@example.com'  phone_number = '+33155501001' country = 'FR' language = 'F' vip = abap_true
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt customer_id = '0000001002' first_name = 'Jonas'  last_name = 'Becker'
        email_address = 'jonas.becker@example.com'  phone_number = '+496955501002' country = 'DE' language = 'D' vip = abap_false
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt customer_id = '0000001003' first_name = 'Emma'   last_name = 'Wilson'
        email_address = 'emma.wilson@example.com'   phone_number = '+442055501003' country = 'GB' language = 'E' vip = abap_true
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt customer_id = '0000001004' first_name = 'Noah'   last_name = 'Carter'
        email_address = 'noah.carter@example.com'   phone_number = '+131255501004' country = 'US' language = 'E' vip = abap_false
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp )
      ( client = sy-mandt customer_id = '0000001005' first_name = 'Aisha'  last_name = 'Rahman'
        email_address = 'aisha.rahman@example.com'  phone_number = '+65655501005'  country = 'SG' language = 'E' vip = abap_true
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp ) ).
    INSERT zf2_customer FROM TABLE @lt_customers.

    DATA lt_bookings TYPE STANDARD TABLE OF zf2_booking.
    lt_bookings = VALUE #(
      ( client = sy-mandt booking_id = '0000005001' customer_id = '0000001001' carrier_id = 'LH' connection_id = '0400' flight_date = lv_today + 7
        booking_date = lv_today - 10 booking_status = 'CONFIRMED' seat_class = 'BUS'
        base_amount = '780.00'  tax_amount = '156.00' total_amount = '936.00'  currency_code = 'EUR' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt booking_id = '0000005002' customer_id = '0000001002' carrier_id = 'LH' connection_id = '0401' flight_date = lv_today + 14
        booking_date = lv_today - 3  booking_status = 'NEW'       seat_class = 'ECO'
        base_amount = '180.00'  tax_amount = '36.00'  total_amount = '216.00'  currency_code = 'EUR' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt booking_id = '0000005003' customer_id = '0000001003' carrier_id = 'BA' connection_id = '0701' flight_date = lv_today + 10
        booking_date = lv_today - 6  booking_status = 'CONFIRMED' seat_class = 'ECO'
        base_amount = '160.00'  tax_amount = '32.00'  total_amount = '192.00'  currency_code = 'GBP' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt booking_id = '0000005004' customer_id = '0000001004' carrier_id = 'UA' connection_id = '0900' flight_date = lv_today + 5
        booking_date = lv_today - 20 booking_status = 'CANCELLED' seat_class = 'ECO'
        base_amount = '320.00'  tax_amount = '64.00'  total_amount = '384.00'  currency_code = 'USD'
        cancel_reason = 'Customer requested cancellation' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp )
      ( client = sy-mandt booking_id = '0000005005' customer_id = '0000001005' carrier_id = 'SQ' connection_id = '0326' flight_date = lv_today + 30
        booking_date = lv_today - 2  booking_status = 'CONFIRMED' seat_class = 'FST'
        base_amount = '1250.00' tax_amount = '250.00' total_amount = '1500.00' currency_code = 'SGD' local_last_changed_at = lv_timestamp last_changed_at = lv_timestamp ) ).
    INSERT zf2_booking FROM TABLE @lt_bookings.

    DATA lt_orders TYPE STANDARD TABLE OF zf2_order.
    lt_orders = VALUE #(
      ( client = sy-mandt order_id = '0000007001' booking_id = '0000005001' customer_id = '0000001001'
        order_date = lv_today - 9 order_status = 'RELEASED' net_amount = '780.00'  tax_amount = '156.00'
        gross_amount = '936.00'  currency_code = 'EUR' last_changed_at = lv_timestamp )
      ( client = sy-mandt order_id = '0000007002' booking_id = '0000005003' customer_id = '0000001003'
        order_date = lv_today - 5 order_status = 'NEW'      net_amount = '160.00'  tax_amount = '32.00'
        gross_amount = '192.00'  currency_code = 'GBP' last_changed_at = lv_timestamp )
      ( client = sy-mandt order_id = '0000007003' booking_id = '0000005005' customer_id = '0000001005'
        order_date = lv_today - 1 order_status = 'RELEASED' net_amount = '1250.00' tax_amount = '250.00'
        gross_amount = '1500.00' currency_code = 'SGD' last_changed_at = lv_timestamp ) ).
    INSERT zf2_order FROM TABLE @lt_orders.

    DATA lt_order_items TYPE STANDARD TABLE OF zf2_order_item.
    lt_order_items = VALUE #(
      ( client = sy-mandt order_id = '0000007001' item_no = '000010' condition_type = 'FARE' description = 'Business fare FRA-JFK' quantity = '1.000' quantity_unit = 'EA' amount = '780.00'  currency_code = 'EUR' )
      ( client = sy-mandt order_id = '0000007001' item_no = '000020' condition_type = 'TAX'  description = 'Taxes and fees'         quantity = '1.000' quantity_unit = 'EA' amount = '156.00'  currency_code = 'EUR' )
      ( client = sy-mandt order_id = '0000007002' item_no = '000010' condition_type = 'FARE' description = 'Economy fare LHR-BER'  quantity = '1.000' quantity_unit = 'EA' amount = '160.00'  currency_code = 'GBP' )
      ( client = sy-mandt order_id = '0000007002' item_no = '000020' condition_type = 'TAX'  description = 'Taxes and fees'         quantity = '1.000' quantity_unit = 'EA' amount = '32.00'   currency_code = 'GBP' )
      ( client = sy-mandt order_id = '0000007003' item_no = '000010' condition_type = 'FARE' description = 'First fare SIN-FRA'    quantity = '1.000' quantity_unit = 'EA' amount = '1250.00' currency_code = 'SGD' )
      ( client = sy-mandt order_id = '0000007003' item_no = '000020' condition_type = 'TAX'  description = 'Taxes and fees'         quantity = '1.000' quantity_unit = 'EA' amount = '250.00'  currency_code = 'SGD' ) ).
    INSERT zf2_order_item FROM TABLE @lt_order_items.

    DATA lt_invoices TYPE STANDARD TABLE OF zf2_invoice.
    lt_invoices = VALUE #(
      ( client = sy-mandt invoice_id = '0000009001' order_id = '0000007001' invoice_date = lv_today - 8 invoice_status = 'PAID' total_amount = '936.00'  paid_amount = '936.00'  currency_code = 'EUR' last_changed_at = lv_timestamp )
      ( client = sy-mandt invoice_id = '0000009002' order_id = '0000007003' invoice_date = lv_today     invoice_status = 'OPEN' total_amount = '1500.00' paid_amount = '0.00'    currency_code = 'SGD' last_changed_at = lv_timestamp ) ).
    INSERT zf2_invoice FROM TABLE @lt_invoices.

    DATA lt_payments TYPE STANDARD TABLE OF zf2_payment.
    lt_payments = VALUE #(
      ( client = sy-mandt payment_id = '0000011001' invoice_id = '0000009001' payment_date = lv_today - 7 amount = '936.00' currency_code = 'EUR' payment_method = 'CARD' reference = 'VISA-936-5001' ) ).
    INSERT zf2_payment FROM TABLE @lt_payments.

    DATA lt_status_history TYPE STANDARD TABLE OF zf2_status_hist.
    lt_status_history = VALUE #(
      ( client = sy-mandt history_uuid = CONV sysuuid_x16( '00000000000000000000000000005001' )
        object_type = 'BOOKING' object_id = '0000005001' old_status = 'NEW' new_status = 'CONFIRMED' changed_by = lv_user changed_at = lv_timestamp change_reason = 'Demo confirmation' )
      ( client = sy-mandt history_uuid = CONV sysuuid_x16( '00000000000000000000000000005004' )
        object_type = 'BOOKING' object_id = '0000005004' old_status = 'NEW' new_status = 'CANCELLED' changed_by = lv_user changed_at = lv_timestamp change_reason = 'Demo cancellation' )
      ( client = sy-mandt history_uuid = CONV sysuuid_x16( '00000000000000000000000000007001' )
        object_type = 'ORDER'   object_id = '0000007001' old_status = 'NEW' new_status = 'RELEASED'  changed_by = lv_user changed_at = lv_timestamp change_reason = 'Demo release' )
      ( client = sy-mandt history_uuid = CONV sysuuid_x16( '00000000000000000000000000009001' )
        object_type = 'INVOICE' object_id = '0000009001' old_status = 'OPEN' new_status = 'PAID'      changed_by = lv_user changed_at = lv_timestamp change_reason = 'Demo payment' ) ).
    INSERT zf2_status_hist FROM TABLE @lt_status_history.

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
