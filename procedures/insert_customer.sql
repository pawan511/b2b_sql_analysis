-- PROCEDURE: eventManagement.insert_customer(character varying, character varying, character varying)

-- DROP PROCEDURE IF EXISTS "eventManagement".insert_customer(character varying, character varying, character varying);

CREATE OR REPLACE PROCEDURE "eventManagement".insert_customer(
	IN custname character varying,
	IN mailid character varying,
	IN contactinfo character varying)
LANGUAGE 'plpgsql'
AS $BODY$
declare 
	isExist int;
Begin
	select count(*) into isExist
	from "eventManagement"."Customer" a
	where a."EmailId"=mailId;

	if isExist >0 then
		raise exception 'Customer already exists';
	else
		insert into "eventManagement"."Customer"("CustName","EmailId","ContactInfo")
		values(custName,mailId,ContactInfo);
	end if;
end;
$BODY$;
ALTER PROCEDURE "eventManagement".insert_customer(character varying, character varying, character varying)
    OWNER TO postgres;
