-- PROCEDURE: eventManagement.insert_ticket_allocation(character varying, json)

-- DROP PROCEDURE IF EXISTS "eventManagement".insert_ticket_allocation(character varying, json);

CREATE OR REPLACE PROCEDURE "eventManagement".insert_ticket_allocation(
	IN reseller_name character varying,
	IN event_ticket_allocat json)
LANGUAGE 'plpgsql'
AS $BODY$
Declare 
reseller_id int;
available_tickets int;	
max_ticket int;
evnt_name varchar(255);
evnt_date timestamp;
ticket_dtsl RECORD;
ticket_category varchar(20);
event_detail json;
ticket_allocte int;
allocated_tckts int;
Begin
	    -- Get the resellerId 
    SELECT "ResellerID" INTO reseller_id
    FROM "eventManagement"."Reseller"
    WHERE "Name" = reseller_name ;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reseller with name % not found', reseller_name;
    END IF;
	
	for event_detail in select * from json_array_elements(event_ticket_allocat)
		loop
		evnt_name:= (event_detail->>'event_name')::varchar(255);
		evnt_date:= (event_detail->>'event_date')::timestamp;
		ticket_category:=(event_detail->>'category_name')::varchar(10);
		ticket_allocte:=(event_detail->>'allocate_no')::int;
		
		Select tc."TicketCategoryID",tc."CategoryName",tc."MaxTicket" into ticket_dtsl
		from "eventManagement"."Event" e  
		inner join "eventManagement"."SubEvent" se
		on e."EventId" = se."EventId"
		inner join "eventManagement"."TicketCategory" tc
		on se."SubEventId"=tc."SubEventId"
		where e."EventName"=evnt_name
		and se."EventDate"=evnt_date
		and tc."CategoryName"=ticket_category;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Event :% not found for date:% and ticket Category:%',evnt_name,evnt_date,ticket_category;
    END IF;

	Select (COALESCE(SUM(eta."AllocatedTickets"), 0)) into  allocated_tckts
	from "eventManagement"."EventTicketAllocation" eta
	inner join "eventManagement"."TicketCategory" tc
	on eta."TicketCategoryID"=tc."TicketCategoryID"
	where eta."TicketCategoryID"=ticket_dtsl."TicketCategoryID";

	-- first transaction 
	if allocated_tckts is null then 
	allocated_tckts := 0;
	end if;

	available_tickets:=ticket_dtsl."MaxTicket" - allocated_tckts;

	if available_tickets < ticket_allocte then
		raise exception 'Avaialble ticket for allocation is:% for category:% ',available_tickets,ticket_dtsl."CategoryName";
	else
		insert into "eventManagement"."EventTicketAllocation" ("ResellerID","TicketCategoryID","AllocatedTickets")
		values(reseller_id,ticket_dtsl."TicketCategoryID",ticket_allocte);
	end if;
end loop;
end;
$BODY$;
ALTER PROCEDURE "eventManagement".insert_ticket_allocation(character varying, json)
    OWNER TO postgres;
