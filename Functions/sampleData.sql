-- FUNCTION: eventManagement.sampleData()

-- DROP FUNCTION IF EXISTS "eventManagement"."sampleData"();

CREATE OR REPLACE FUNCTION "eventManagement"."sampleData"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
---Venue Organizer----

CALL "eventManagement".insert_venue_organizer('Organizer 1', 'organizer1@example.com');
CALL "eventManagement".insert_venue_organizer('Organizer 2', 'organizer2@example.com');
CALL "eventManagement".insert_venue_organizer('Organizer 3', 'organizer2@example.com');

---Reseller----
CALL "eventManagement"."insert_reSeller"('reseller 1', 'contact 1', 12.5);
CALL "eventManagement"."insert_reSeller"('reseller 2', 'contact 2', 9.8);
CALL "eventManagement"."insert_reSeller"('reseller 3', 'contact 3', 14.2);
CALL "eventManagement"."insert_reSeller"('reseller 4', 'contact 4', 11.3);
CALL "eventManagement"."insert_reSeller"('reseller 5', 'contact 5', 13.7);
CALL "eventManagement"."insert_reSeller"('reseller 6', 'contact 6', 8.6);
CALL "eventManagement"."insert_reSeller"('reseller 7', 'contact 7', 10.1);
CALL "eventManagement"."insert_reSeller"('reseller 8', 'contact 8', 13.5);

----Event and Ticket-------------

CALL "eventManagement"."insert_event_with_tickets"(
    'Organizer 1',                                  -- venue_organizer_id
    'Event 1',           -- event_name
    True,                               -- is_recurring
    'First Monday of JUN/JUL/AUG',             -- recurrence_pattern
    ARRAY[
        '2024-06-03 18:00:00',
        '2024-07-08 18:00:00',
        '2024-08-05 18:00:00'
    ]::Timestamp[],                     -- sub_event_timestamps
    ARRAY[
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 300}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 30},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 100},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]'
    ]::json[]                           -- ticket_categories_json
);

CALL "eventManagement"."insert_event_with_tickets"(
    'Organizer 2',                                  -- venue_organizer_id
    'Event 2',           -- event_name
    True,                               -- is_recurring
    'First Sunday of JUN/JUL/AUG',             -- recurrence_pattern
    ARRAY[
        '2024-06-02 18:00:00',
        '2024-07-07 18:00:00',
        '2024-08-04 18:00:00'
    ]::Timestamp[],                     -- sub_event_timestamps
    ARRAY[
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 10},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 100},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 100},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 150}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 25},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 100},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]'
    ]::json[]                           -- ticket_categories_json
);

CALL "eventManagement"."insert_event_with_tickets"(
    'Organizer 2',                                  -- venue_organizer_id
    'Event 3',           -- event_name
    false,                               -- is_recurring
    null,             -- recurrence_pattern
    ARRAY[
        '2024-08-15 18:00:00'
    ]::Timestamp[],                     -- sub_event_timestamps
    ARRAY[
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 240}]'
    ]::json[]                           -- ticket_categories_json
);

CALL "eventManagement"."insert_event_with_tickets"(
    'Organizer 3',                                  -- venue_organizer_id
    'Event 4',           -- event_name
    True,                               -- is_recurring
    'Every Monday in June',             -- recurrence_pattern
    ARRAY[
       '2024-06-03 09:00:00', 
        '2024-06-10 09:00:00', 
        '2024-06-17 09:00:00', 
        '2024-06-24 09:00:00'
    ]::Timestamp[],                     -- sub_event_timestamps
    ARRAY[
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 300}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 30},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]',
        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 40},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 100},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]',
	        '[{"category_name": "VIP", "price": 120.00, "max_ticket": 20},
        {"category_name": "Gold", "price": 70.00, "max_ticket": 120},
        {"category_name": "Silver", "price": 40.00, "max_ticket": 200}]'
    ]::json[]                           -- ticket_categories_json
);

------------Ticket Allocation---------------

-- Reseller 1 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 1', 
    '[
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "VIP", "allocate_no": 10},
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "Gold", "allocate_no": 20},
        {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Silver", "allocate_no": 50}
    ]'
);

-- Reseller 2 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 2', 
    '[
        {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "VIP", "allocate_no": 5},
        {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "Gold", "allocate_no": 10},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 30}
    ]'
);

-- Reseller 3 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 3', 
    '[
        {"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "category_name": "VIP", "allocate_no": 15},
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "Gold", "allocate_no": 25},
        {"event_name": "Event 4", "event_date": "2024-06-17 09:00:00", "category_name": "Silver", "allocate_no": 40}
    ]'
);

-- Reseller 4 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 4', 
    '[
        {"event_name": "Event 1", "event_date": "2024-08-05 18:00:00", "category_name": "VIP", "allocate_no": 10},
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "Gold", "allocate_no": 30},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 20}
    ]'
);
-- Reseller 5 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 5', 
    '[
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "VIP", "allocate_no": 5},
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "Gold", "allocate_no": 15},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 25}
    ]'
);

-- Reseller 6 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 6', 
    '[
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "VIP", "allocate_no": 10},
        {"event_name": "Event 4", "event_date": "2024-06-17 09:00:00", "category_name": "Gold", "allocate_no": 20},
        {"event_name": "Event 4", "event_date": "2024-06-24 09:00:00", "category_name": "Silver", "allocate_no": 35}
    ]'
);

-- Reseller 7 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 7', 
    '[
        {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "VIP", "allocate_no": 10},
        {"event_name": "Event 2", "event_date": "2024-08-04 18:00:00", "category_name": "Gold", "allocate_no": 20},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 40}
    ]'
);

-- Reseller 8 allocating tickets
CALL "eventManagement".insert_ticket_allocation(
    'reseller 8', 
    '[
        {"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "category_name": "VIP", "allocate_no": 20},
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "Gold", "allocate_no": 30},
        {"event_name": "Event 4", "event_date": "2024-06-17 09:00:00", "category_name": "Silver", "allocate_no": 50}
    ]'
);

-- Reseller 1 additional allocations
CALL "eventManagement".insert_ticket_allocation(
    'reseller 1', 
    '[
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "VIP", "allocate_no": 5},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Gold", "allocate_no": 10},
        {"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "category_name": "Silver", "allocate_no": 20}
    ]'
);

-- Reseller 2 additional allocations
CALL "eventManagement".insert_ticket_allocation(
    'reseller 2', 
    '[
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "VIP", "allocate_no": 8},
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "Gold", "allocate_no": 12},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 18}
    ]'
);

-- Reseller 3 additional allocations
CALL "eventManagement".insert_ticket_allocation(
    'reseller 3', 
    '[
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "VIP", "allocate_no": 12},
        {"event_name": "Event 4", "event_date": "2024-06-17 09:00:00", "category_name": "Gold", "allocate_no": 22},
        {"event_name": "Event 4", "event_date": "2024-06-24 09:00:00", "category_name": "Silver", "allocate_no": 32}
    ]'
);

-- Reseller 4 additional allocations

CALL "eventManagement".insert_ticket_allocation(
    'reseller 4', 
    '[
        {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Gold", "allocate_no": 15},
        {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "Silver", "allocate_no": 20},
        {"event_name": "Event 4", "event_date": "2024-06-24 09:00:00", "category_name": "VIP", "allocate_no": 8}
    ]'
);

-- Reseller 5 additional allocations
CALL "eventManagement".insert_ticket_allocation(
    'reseller 5', 
    '[
        {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Silver", "allocate_no": 25},
        {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "Gold", "allocate_no": 18},
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "VIP", "allocate_no": 1}
    ]'
);

-- Reseller 6 additional allocations
CALL "eventManagement".insert_ticket_allocation(
    'reseller 6', 
    '[
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Gold", "allocate_no": 15},
        {"event_name": "Event 4", "event_date": "2024-06-24 09:00:00", "category_name": "Silver", "allocate_no": 10},
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "VIP", "allocate_no": 2}
    ]'
);
CALL "eventManagement".insert_ticket_allocation(
    'reseller 3', 
    '[
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Gold", "allocate_no": 15},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "Silver", "allocate_no": 10},
        {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "category_name": "VIP", "allocate_no": 2}
    ]'
);

CALL "eventManagement".insert_ticket_allocation(
    'reseller 1', 
    '[
        {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Gold", "allocate_no": 10}
    ]'
);
CALL "eventManagement".insert_ticket_allocation(
    'reseller 1', 
    '[
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "VIP", "allocate_no": 2},
	{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "Gold", "allocate_no": 5}
    ]'
);
CALL "eventManagement".insert_ticket_allocation(
    'reseller 2', 
    '[
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "VIP", "allocate_no": 2},
	{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "category_name": "Gold", "allocate_no": 5}
    ]'
);

CALL "eventManagement".insert_ticket_allocation(
    'reseller 5', 
    '[
        {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "Gold", "allocate_no": 2},
	{"event_name": "Event 2", "event_date": "2024-08-04 18:00:00", "category_name": "Silver", "allocate_no": 5},
	{"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "category_name": "VIP", "allocate_no": 2}
    ]'
);

CALL "eventManagement".insert_ticket_allocation(
    'reseller 8', 
    '[
        {"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "category_name": "VIP", "allocate_no": 2},
	{"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Silver", "allocate_no": 15},
	{"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "category_name": "Gold", "allocate_no": 10}
    ]'
);

CALL "eventManagement".insert_ticket_allocation(
    'reseller 7', 
    '[
        {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "Gold", "allocate_no": 2},
	{"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "category_name": "Silver", "allocate_no": 7},
	{"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "category_name": "Silver", "allocate_no": 20}
    ]'
);
---------customer----------

-- Customer 1
CALL "eventManagement".insert_customer('customer1', 'customer1@example.com', '123-456-7890');

-- Customer 2
CALL "eventManagement".insert_customer('customer2', 'customer2@example.com', '123-456-7891');

-- Customer 3
CALL "eventManagement".insert_customer('customer3', 'customer3@example.com', '123-456-7892');

-- Customer 4
CALL "eventManagement".insert_customer('customer4', 'customer4@example.com', '123-456-7893');

-- Customer 5
CALL "eventManagement".insert_customer('customer5', 'customer5@example.com', '123-456-7894');

-- Customer 6
CALL "eventManagement".insert_customer('customer6', 'customer6@example.com', '123-456-7895');

-- Customer 7
CALL "eventManagement".insert_customer('customer7', 'customer7@example.com', '123-456-7896');

-- Customer 8
CALL "eventManagement".insert_customer('customer8', 'customer8@example.com', '123-456-7897');

-- Customer 9
CALL "eventManagement".insert_customer('customer9', 'customer9@example.com', '123-456-7898');

-- Customer 10
CALL "eventManagement".insert_customer('customer10', 'customer10@example.com', '123-456-7899');

-- Customer 11
CALL "eventManagement".insert_customer('customer11', 'customer11@example.com', '123-456-7900');

-- Customer 12
CALL "eventManagement".insert_customer('customer12', 'customer12@example.com', '123-456-7901');

-- Customer 13
CALL "eventManagement".insert_customer('customer13', 'customer13@example.com', '123-456-7902');

-- Customer 14
CALL "eventManagement".insert_customer('customer14', 'customer14@example.com', '123-456-7903');

-- Customer 15
CALL "eventManagement".insert_customer('customer15', 'customer15@example.com', '123-456-7904');

-- Customer 16
CALL "eventManagement".insert_customer('customer16', 'customer16@example.com', '123-456-7905');

-- Customer 17
CALL "eventManagement".insert_customer('customer17', 'customer17@example.com', '123-456-7906');

-- Customer 18
CALL "eventManagement".insert_customer('customer18', 'customer18@example.com', '123-456-7907');

-- Customer 19
CALL "eventManagement".insert_customer('customer19', 'customer19@example.com', '123-456-7908');

-- Customer 20
CALL "eventManagement".insert_customer('customer20', 'customer20@example.com', '123-456-7909');

-- Customer 21
CALL "eventManagement".insert_customer('customer21', 'customer21@example.com', '123-456-7910');

-- Customer 22
CALL "eventManagement".insert_customer('customer22', 'customer22@example.com', '123-456-7911');

-- Customer 23
CALL "eventManagement".insert_customer('customer23', 'customer23@example.com', '123-456-7912');

-- Customer 24
CALL "eventManagement".insert_customer('customer24', 'customer24@example.com', '123-456-7913');

-- Customer 25
CALL "eventManagement".insert_customer('customer25', 'customer25@example.com', '123-456-7914');

------------purchase transaction ------

-- Purchase by reseller 1
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer1',
  'reseller 1',
  'Reseller',
  '2024-03-15 10:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "VIP", "quantity": 2}]'
);

-- Purchase by reseller 2
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer2',
  'reseller 2',
  'Reseller',
  '2024-03-20 11:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Gold", "quantity": 3}]'
);

-- Purchase by reseller 3
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer3',
  'reseller 4',
  'Reseller',
  '2024-04-10 12:00:00',
  '[{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Silver", "quantity": 5}]'
);

-- Purchase by reseller 4
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer4',
  'reseller 3',
  'Reseller',
  '2024-04-25 13:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "ticket_type": "VIP", "quantity": 1}]'
);

-- Purchase by venue organizer 1
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer5',
  'Organizer 1',
  'VenueOrganizer',
  '2024-05-02 14:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "Gold", "quantity": 5}]'
);

-- Purchase by venue organizer 2
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer6',
  'Organizer 2',
  'VenueOrganizer',
  '2024-05-05 15:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Silver", "quantity": 10}]'
);

-- Purchase by venue organizer 3
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer7',
  'Organizer 2',
  'VenueOrganizer',
  '2024-05-10 16:00:00',
  '[{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "VIP", "quantity": 3}]'
);

-- Purchase by venue organizer 4
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer8',
  'Organizer 3',
  'VenueOrganizer',
  '2024-05-15 17:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "ticket_type": "Gold", "quantity": 2}]'
);

-- Additional purchases
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer9',
  'reseller 1',
  'Reseller',
  '2024-03-25 10:30:00',
  '[{"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "ticket_type": "Silver", "quantity": 10}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer10',
  'reseller 2',
  'Reseller',
  '2024-04-01 11:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "Gold", "quantity": 5}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer11',
  'reseller 3',
  'Reseller',
  '2024-04-15 12:00:00',
  '[{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Gold", "quantity": 13},
	{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Silver", "quantity": 10},
	{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "VIP", "quantity": 2}
	]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer12',
  'reseller 7',
  'Reseller',
  '2024-04-20 13:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "ticket_type": "Silver", "quantity": 8}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer13',
  'Organizer 1',
  'VenueOrganizer',
  '2024-04-25 14:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "Gold", "quantity": 4}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer14',
  'Organizer 2',
  'VenueOrganizer',
  '2024-04-30 15:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Silver", "quantity": 6}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer15',
  'Organizer 2',
  'VenueOrganizer',
  '2024-05-02 16:00:00',
  '[{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Gold", "quantity": 10}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer16',
  'Organizer 3',
  'VenueOrganizer',
  '2024-05-05 17:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "ticket_type": "VIP", "quantity": 2}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer17',
  'reseller 1',
  'Reseller',
  '2024-05-10 10:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "VIP", "quantity": 1},
    {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "ticket_type": "Gold", "quantity": 2}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer18',
  'reseller 2',
  'Reseller',
  '2024-05-15 11:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "VIP", "quantity": 1},
    {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Gold", "quantity": 3}]'
);
CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer18',
  'reseller 1',
  'Reseller',
  '2024-05-16 11:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "VIP", "quantity": 1},
    {"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Gold", "quantity": 3}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer19',
  'reseller 5',
  'Reseller',
  '2024-05-20 12:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "Gold", "quantity": 2},
    {"event_name": "Event 2", "event_date": "2024-08-04 18:00:00", "ticket_type": "Silver", "quantity": 4},
	 {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "VIP", "quantity": 2}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer20',
  'reseller 7',
  'Reseller',
  '2024-05-25 13:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "ticket_type": "Gold", "quantity": 2},
    {"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "ticket_type": "Silver", "quantity": 3}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer21',
  'reseller 8',
  'Reseller',
  '2024-05-05 14:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "VIP", "quantity": 2},
    {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "ticket_type": "Silver", "quantity": 6}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer22',
  'Organizer 2',
  'VenueOrganizer',
  '2024-05-10 15:00:00',
  '[{"event_name": "Event 2", "event_date": "2024-06-02 18:00:00", "ticket_type": "Gold", "quantity": 4},
    {"event_name": "Event 2", "event_date": "2024-07-07 18:00:00", "ticket_type": "Silver", "quantity": 8}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer23',
  'organizer 3',
  'VenueOrganizer',
  '2024-05-15 16:00:00',
  '[{"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Gold", "quantity": 5},
    {"event_name": "Event 3", "event_date": "2024-08-15 18:00:00", "ticket_type": "Silver", "quantity": 2}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer24',
  'reseller 3',
  'Reseller',
  '2024-05-18 17:00:00',
  '[{"event_name": "Event 4", "event_date": "2024-06-03 09:00:00", "ticket_type": "VIP", "quantity": 1},
    {"event_name": "Event 4", "event_date": "2024-06-10 09:00:00", "ticket_type": "Gold", "quantity": 3}]'
);

CALL "eventManagement"."Insert_Purchase_Transaction"(
  'customer25',
  'reseller 1',
  'Reseller',
  '2024-05-19 18:00:00',
  '[{"event_name": "Event 1", "event_date": "2024-06-03 18:00:00", "ticket_type": "Gold", "quantity": 5},
    {"event_name": "Event 1", "event_date": "2024-07-08 18:00:00", "ticket_type": "Silver", "quantity": 8}]'
);

end;
$BODY$;

ALTER FUNCTION "eventManagement"."sampleData"()
    OWNER TO postgres;
