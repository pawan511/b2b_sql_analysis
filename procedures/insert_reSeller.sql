-- PROCEDURE: eventManagement.insert_reSeller(character varying, character varying, numeric)

-- DROP PROCEDURE IF EXISTS "eventManagement"."insert_reSeller"(character varying, character varying, numeric);

CREATE OR REPLACE PROCEDURE "eventManagement"."insert_reSeller"(
	IN reseller_name character varying,
	IN reseller_contact character varying,
	IN commission_val numeric)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  isPresent INT;
  new_reSeller_id INT;
BEGIN

		IF EXISTS (
            SELECT 1
            FROM "eventManagement"."Reseller"
			where "Name" = reseller_name
        ) THEN
            RAISE EXCEPTION 'Reseller  name % already exists', reseller_name;
        END IF;

    INSERT INTO "eventManagement"."Reseller" ("Name", "ContactInfo","CommissionRate")
      VALUES (reSeller_name, reSeller_contact,commission_val) 
    RETURNING "ResellerID" INTO new_reSeller_id;

    INSERT INTO "eventManagement"."Seller" ("VenueOrganizerID", "ResellerID", "SellerType")
    VALUES (Null,new_reSeller_id,'Reseller');
END;
$BODY$;
ALTER PROCEDURE "eventManagement"."insert_reSeller"(character varying, character varying, numeric)
    OWNER TO postgres;
