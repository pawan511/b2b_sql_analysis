-- PROCEDURE: eventManagement.insert_venue_organizer(character varying, character varying)

-- DROP PROCEDURE IF EXISTS "eventManagement".insert_venue_organizer(character varying, character varying);

CREATE OR REPLACE PROCEDURE "eventManagement".insert_venue_organizer(
	IN organizer_name character varying,
	IN organizer_contact character varying)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  isPresent INT;
  new_organizer_id INT;
BEGIN
  SELECT COUNT(*) INTO isPresent  
  FROM "eventManagement"."VenueOrganizer" AS a
  WHERE a."Name" = organizer_name;

  IF isPresent > 0 THEN
    RAISE EXCEPTION 'VenueOrganizer:% name already exists',organizer_name;
  ELSE
    INSERT INTO "eventManagement"."VenueOrganizer" ("Name", "ContactInfo")
      VALUES (organizer_name, organizer_contact) 
    RETURNING "VenueOrganizerID" INTO new_organizer_id;

    INSERT INTO "eventManagement"."Seller" ("VenueOrganizerID", "ResellerID", "SellerType")
    VALUES (new_organizer_id, NULL, 'VenueOrganizer');
  END IF;
END;
$BODY$;
ALTER PROCEDURE "eventManagement".insert_venue_organizer(character varying, character varying)
    OWNER TO postgres;
