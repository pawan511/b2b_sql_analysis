-- PROCEDURE: eventManagement.insert_event_with_tickets(character varying, character varying, boolean, character varying, timestamp without time zone[], json[])

-- DROP PROCEDURE IF EXISTS "eventManagement".insert_event_with_tickets(character varying, character varying, boolean, character varying, timestamp without time zone[], json[]);

CREATE OR REPLACE PROCEDURE "eventManagement".insert_event_with_tickets(
	IN organizer_name character varying,
	IN event_name character varying,
	IN is_recurring boolean,
	IN recurrence_pattern character varying,
	IN sub_event_timestamps timestamp without time zone[],
	IN ticket_categories_array json[])
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    new_event_id INTEGER;
    new_organizer_id INTEGER;
    new_sub_event_id INTEGER;
    sub_event_timestamp TIMESTAMP;
    total_tickets INTEGER;
    idx INTEGER := 1;
    ticket_category JSON;
    category_name VARCHAR;
    price NUMERIC(10, 2);
    max_ticket INTEGER;
BEGIN
    -- Get the VenueOrganizerID based on the organizer_name
    SELECT "VenueOrganizerID" INTO new_organizer_id
    FROM "eventManagement"."VenueOrganizer"
    WHERE "Name" = organizer_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'VenueOrganizer with name % not found', organizer_name;
    END IF;
	
    -- Insert the main event
    INSERT INTO "eventManagement"."Event" ("VenueOrganizerID", "EventName", "IsRecurring", "RecurrencePattern")
    VALUES (new_organizer_id, event_name, is_recurring, recurrence_pattern)
    RETURNING "EventId" INTO new_event_id;

    -- Loop through the sub_event_timestamps array to insert sub-events
    FOREACH sub_event_timestamp IN ARRAY sub_event_timestamps
    LOOP   
		IF EXISTS (
            SELECT 1
            FROM "eventManagement"."Event" e
            inner JOIN "eventManagement"."SubEvent" se ON e."EventId" = se."EventId"
            WHERE e."EventName" = event_name AND se."EventDate" = sub_event_timestamp
        ) THEN
            RAISE EXCEPTION 'Event with name % and date % already exists', event_name, sub_event_timestamp;
        END IF;

		total_tickets := 0;
        INSERT INTO "eventManagement"."SubEvent" ("EventId", "EventDate", "TotalTicket")
        VALUES (new_event_id, sub_event_timestamp, total_tickets)
        RETURNING "SubEventId" INTO new_sub_event_id;

		ticket_category = ticket_categories_array[idx];
        -- Loop through the JSON array of ticket categories
        FOR ticket_category IN SELECT * FROM json_array_elements(ticket_category)
        LOOP
            category_name := ticket_category->>'category_name';
            price := (ticket_category->>'price')::NUMERIC(10, 2);
            max_ticket := (ticket_category->>'max_ticket')::INTEGER;
			total_tickets := total_tickets+max_ticket;

            INSERT INTO "eventManagement"."TicketCategory" ("SubEventId", "CategoryName", "Price", "MaxTicket")
            VALUES (new_sub_event_id, category_name, price, max_ticket);
        END LOOP;
        idx := idx + 1;
		update "eventManagement"."SubEvent"
			set "TotalTicket"=total_tickets
			where "SubEventId"=new_sub_event_id;

		--update total tickets
    END LOOP;
END;
$BODY$;
ALTER PROCEDURE "eventManagement".insert_event_with_tickets(character varying, character varying, boolean, character varying, timestamp without time zone[], json[])
    OWNER TO postgres;
