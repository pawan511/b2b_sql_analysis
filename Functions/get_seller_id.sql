-- FUNCTION: eventManagement.get_seller_id(character varying, character varying)

-- DROP FUNCTION IF EXISTS "eventManagement".get_seller_id(character varying, character varying);

CREATE OR REPLACE FUNCTION "eventManagement".get_seller_id(
	p_name character varying,
	p_type character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    seller_id integer;
BEGIN
    IF p_type = 'VenueOrganizer' THEN
        SELECT s."SellerID"
        INTO seller_id
        FROM "eventManagement"."Seller" s
        JOIN "eventManagement"."VenueOrganizer" vo ON s."VenueOrganizerID" = vo."VenueOrganizerID"
        WHERE vo."Name" = p_name
        AND s."SellerType" = 'VenueOrganizer';

        IF NOT FOUND THEN
            RAISE EXCEPTION 'VenueOrganizer with name % not found', p_name;
        END IF;

    ELSIF p_type = 'Reseller' THEN
        SELECT s."SellerID"
        INTO seller_id
        FROM "eventManagement"."Seller" s
        JOIN "eventManagement"."Reseller" r ON s."ResellerID" = r."ResellerID"
        WHERE r."Name" = p_name
        AND s."SellerType" = 'Reseller';

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Reseller with name % not found', p_name;
        END IF;

    ELSE
        RAISE EXCEPTION 'Invalid seller type %', p_type;
    END IF;

    RETURN seller_id;
END;
$BODY$;

ALTER FUNCTION "eventManagement".get_seller_id(character varying, character varying)
    OWNER TO postgres;
