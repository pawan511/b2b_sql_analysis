-- FUNCTION: eventManagement.get_ticket_category_id(character varying, timestamp without time zone, character varying)

-- DROP FUNCTION IF EXISTS "eventManagement".get_ticket_category_id(character varying, timestamp without time zone, character varying);

CREATE OR REPLACE FUNCTION "eventManagement".get_ticket_category_id(
	event_name character varying,
	event_date timestamp without time zone,
	ticket_type character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  ticket_cat_id integer;
BEGIN
  -- Execute the query to find the TicketCategoryID
  SELECT tc."TicketCategoryID"
  INTO ticket_cat_id
  FROM "eventManagement"."Event" e
  INNER JOIN "eventManagement"."SubEvent" se ON e."EventId" = se."EventId"
  INNER JOIN "eventManagement"."TicketCategory" tc ON se."SubEventId" = tc."SubEventId"
  WHERE e."EventName" = event_name
    AND se."EventDate" = event_date
    AND tc."CategoryName" = ticket_type;

		if not found then
		raise exception 'Event :% for date :% for ticket type :% not found',event_name,event_date,ticket_type;
	end if;

  -- Return the retrieved ID or NULL if no rows found
  RETURN ticket_cat_id;
END;
$BODY$;

ALTER FUNCTION "eventManagement".get_ticket_category_id(character varying, timestamp without time zone, character varying)
    OWNER TO postgres;
