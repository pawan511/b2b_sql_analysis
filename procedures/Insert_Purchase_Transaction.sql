-- PROCEDURE: eventManagement.Insert_Purchase_Transaction(character varying, character varying, character varying, timestamp without time zone, json)

-- DROP PROCEDURE IF EXISTS "eventManagement"."Insert_Purchase_Transaction"(character varying, character varying, character varying, timestamp without time zone, json);

CREATE OR REPLACE PROCEDURE "eventManagement"."Insert_Purchase_Transaction"(
	IN cust_name character varying,
	IN seller_name character varying,
	IN seller_type character varying,
	IN sale_date timestamp without time zone,
	IN purchase_details json)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	cust_id int;
seller_id int;
  new_sale_id INT;
  pur_transaction JSON;
  quantity INT; 
  ticket_price NUMERIC(10,2);
  total_amount NUMERIC(10,2);
  sold_tickets INT;
  ticket_limit INT;
  allocated_tickets INT;
  reseller_id INT;
  reseller_id_lst INT[];
  organizer_id INT;
  s_organizer_id int;	
  commision_rate numeric(5,2);
  commision_amt numeric(10,2);
  new_sale_detail_id int;
  available_tckts int;
event_name varchar(255);
event_date timestamp;
ticket_type varchar(20);
  ticket_cat_id INT;
BEGIN

	select "CustomerID" into cust_id
	from "eventManagement"."Customer"
	where "CustName"=cust_name;
	if not found then
		raise exception 'Customer :% not found',cust_name;
	end if;
	
	seller_id:="eventManagement".get_seller_id(seller_name,seller_type );	

  -- Insert sale record and get generated ID
  INSERT INTO "eventManagement"."TicketSale" ("CustomerID", "SellerID", "SaleDate")
  VALUES (cust_id, seller_id, sale_date)
  RETURNING "SaleID" INTO new_sale_id;

  -- Loop through each purchase item in JSON array
  FOR pur_transaction IN SELECT * FROM json_array_elements(purchase_details) LOOP
	event_name:= (pur_transaction ->> 'event_name')::varchar(20);
	event_date:=(pur_transaction ->> 'event_date')::timestamp;
    ticket_type := (pur_transaction ->> 'ticket_type')::varchar(20);
    quantity := (pur_transaction ->> 'quantity')::INT;

	ticket_cat_id:=  "eventManagement".get_ticket_category_id(event_name, event_date, ticket_type);

    IF seller_type = 'Reseller' THEN
		--get reseller id
      SELECT COALESCE("ResellerID",0) INTO reseller_id
      FROM "eventManagement"."Seller"
      WHERE "SellerID" = seller_id;
-- check reseller has tikcets allocated or not
      SELECT COALESCE(array_agg(distinct eta."ResellerID"), ARRAY[0]::INTEGER[]) INTO reseller_id_lst
      FROM "eventManagement"."TicketCategory" tc
      LEFT OUTER JOIN "eventManagement"."EventTicketAllocation" eta
      ON tc."TicketCategoryID" = eta."TicketCategoryID"
      WHERE eta."TicketCategoryID" = ticket_cat_id;

      IF not reseller_id = ANY(reseller_id_lst) THEN
        RAISE EXCEPTION 'Transaction cancelled:Seller_id ID :% is not authorized to sell tickets for this category',seller_id;
      ELSE
		  --ticket allocated
        SELECT "AllocatedTickets" INTO ticket_limit
        FROM "eventManagement"."EventTicketAllocation"
        WHERE "TicketCategoryID" = ticket_cat_id
        AND "ResellerID" = reseller_id;
	
		--sold by reseller 
        SELECT COALESCE(SUM(tsd."Quantity"), 0) INTO sold_tickets
        FROM "eventManagement"."TicketSaleDetail" AS tsd
        JOIN "eventManagement"."TicketSale" AS ts ON ts."SaleID" = tsd."SaleID"
        WHERE tsd."TicketCategoryID" = ticket_cat_id
        AND ts."SellerID" = seller_id
		group by ts."SellerID",tsd."TicketCategoryID";

			if sold_tickets is null then 
			sold_tickets := 0;
			end if;

		available_tckts := (ticket_limit - sold_tickets);

        IF quantity > available_tckts THEN
          RAISE EXCEPTION 'Transaction cancelled:Ticket quantity is more than available quantity, available limit is :%',available_tckts;
        ELSE
          SELECT "Price" INTO ticket_price
          FROM "eventManagement"."TicketCategory"
          WHERE "TicketCategoryID" = ticket_cat_id;

          total_amount := ticket_price * quantity;

          INSERT INTO "eventManagement"."TicketSaleDetail" ("SaleID", "TicketCategoryID", "Quantity", "Amount")
          VALUES (new_sale_id, ticket_cat_id, quantity, total_amount)
			  returning "SaleDetailID" into new_sale_detail_id;

 		  Raise notice 'Purchase transacation done for event :% date:%  type :% for quantity :% amount is :% by reseller :% ' ,event_name,event_date,ticket_type,quantity,total_amount,seller_name;

		  --commision calculation
		  Select "CommissionRate" into commision_rate from "eventManagement"."Reseller"
			  where "ResellerID"=reseller_id;
 		  commision_amt := (commision_rate / 100) * total_amount;

		  insert into 	"eventManagement"."Commission"("SaleDetailID", "ResellerID", "CommissionAmount")
			  values(new_sale_detail_id,reseller_id,commision_amt);

        END IF;
      END IF;
	
    ELSE
		--get seller id 
		seller_id:="eventManagement".get_seller_id(seller_name,seller_type );	
	 --get venue organizer id for event
      SELECT "VenueOrganizerID" INTO organizer_id
	  from "eventManagement"."Event" 
      where "EventName"=event_name;
	 
		if not found then
			raise exception 'Transaction cancelled:Event :% not created',event_name;
		end if;
	 --get venue organizer id for organiser name
		Select COALESCE("VenueOrganizerID",0) into s_organizer_id from "eventManagement"."Seller"
		where "SellerID"=seller_id;
	--verify event organiser id  and parameter organiser id is same or not
      IF organizer_id = s_organizer_id THEN
		 --ticket allocated to others
        SELECT COALESCE(SUM("AllocatedTickets"), 0) INTO allocated_tickets
        FROM "eventManagement"."EventTicketAllocation"
        WHERE "TicketCategoryID" = ticket_cat_id;
		--total number of tickets
        SELECT "MaxTicket" INTO ticket_limit
        FROM "eventManagement"."TicketCategory"
        WHERE "TicketCategoryID" = ticket_cat_id;
		--ticket sold by orgaiser 
        SELECT COALESCE(SUM(tsd."Quantity"), 0) INTO sold_tickets
        FROM "eventManagement"."TicketSaleDetail" AS tsd
        inner JOIN "eventManagement"."TicketSale" AS ts ON ts."SaleID" = tsd."SaleID"
        WHERE tsd."TicketCategoryID" = ticket_cat_id
        AND ts."SellerID" = seller_id;

		available_tckts := ((ticket_limit - allocated_tickets) - sold_tickets);

        IF quantity > available_tckts THEN
          RAISE EXCEPTION 'Transaction cancelled:Ticket quantity is more than available quantity:%',available_tckts;

        ELSE
          SELECT "Price" INTO ticket_price
          FROM "eventManagement"."TicketCategory"
          WHERE "TicketCategoryID" = ticket_cat_id;

          total_amount := ticket_price * quantity;

          INSERT INTO "eventManagement"."TicketSaleDetail" ("SaleID", "TicketCategoryID", "Quantity", "Amount")
          VALUES (new_sale_id, ticket_cat_id, quantity, total_amount);
 
 		  Raise notice 'Purchase transacation done for event :% date:%  type :% for quantity :% amount is :% by organiser :% ' ,event_name,event_date,ticket_type,quantity,total_amount,seller_name;

        END IF;
      ELSE 
        RAISE EXCEPTION ':Seller_id ID :% is not authorized to sell tickets for this category',seller_id;
      END IF;
    END IF;
  END LOOP;
END;
$BODY$;
ALTER PROCEDURE "eventManagement"."Insert_Purchase_Transaction"(character varying, character varying, character varying, timestamp without time zone, json)
    OWNER TO postgres;
