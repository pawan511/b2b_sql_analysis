-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS "eventManagement"."Commission"
(
    "CommissionID" serial NOT NULL,
    "SaleDetailID" integer,
    "ResellerID" integer,
    "CommissionAmount" numeric(10, 2),
    CONSTRAINT "Commission_pkey" PRIMARY KEY ("CommissionID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."Customer"
(
    "CustomerID" serial NOT NULL,
    "CustName" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "EmailId" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "ContactInfo" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "Customer_pkey" PRIMARY KEY ("CustomerID"),
    CONSTRAINT email UNIQUE ("EmailId")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."Event"
(
    "EventId" integer NOT NULL DEFAULT nextval('"eventManagement"."Event_EventID_seq"'::regclass),
    "VenueOrganizerID" integer,
    "EventName" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "IsRecurring" boolean,
    "RecurrencePattern" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Event_pkey" PRIMARY KEY ("EventId")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."EventTicketAllocation"
(
    "AllocationID" serial NOT NULL,
    "ResellerID" integer,
    "TicketCategoryID" integer,
    "AllocatedTickets" numeric NOT NULL,
    CONSTRAINT "EventTicketAllocation_pkey" PRIMARY KEY ("AllocationID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."Reseller"
(
    "ResellerID" serial NOT NULL,
    "Name" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "ContactInfo" character varying(255) COLLATE pg_catalog."default",
    "CommissionRate" numeric(5, 2) NOT NULL,
    CONSTRAINT "Reseller_pkey" PRIMARY KEY ("ResellerID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."Seller"
(
    "SellerID" integer NOT NULL DEFAULT nextval('"eventManagement"."Seller_SellerId_seq"'::regclass),
    "VenueOrganizerID" integer,
    "ResellerID" integer,
    "SellerType" character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT "Seller_pkey" PRIMARY KEY ("SellerID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."SubEvent"
(
    "SubEventId" serial NOT NULL,
    "EventId" integer,
    "EventDate" timestamp without time zone NOT NULL,
    "TotalTicket" numeric(10, 0) NOT NULL,
    CONSTRAINT subevent_pk PRIMARY KEY ("SubEventId")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."TicketCategory"
(
    "TicketCategoryID" serial NOT NULL,
    "SubEventId" integer,
    "CategoryName" character varying COLLATE pg_catalog."default" NOT NULL,
    "Price" numeric(10, 2) NOT NULL,
    "MaxTicket" numeric NOT NULL,
    CONSTRAINT "TicketCategory_pkey" PRIMARY KEY ("TicketCategoryID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."TicketSale"
(
    "SaleID" serial NOT NULL,
    "CustomerID" integer,
    "SellerID" integer,
    "SaleDate" timestamp without time zone,
    CONSTRAINT ticketsale_pk PRIMARY KEY ("SaleID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."TicketSaleDetail"
(
    "SaleDetailID" serial NOT NULL,
    "SaleID" integer,
    "TicketCategoryID" integer,
    "Quantity" numeric(10, 0) NOT NULL,
    "Amount" numeric(10, 2) NOT NULL,
    CONSTRAINT "TicketSaleDetail_pkey" PRIMARY KEY ("SaleDetailID")
);

CREATE TABLE IF NOT EXISTS "eventManagement"."VenueOrganizer"
(
    "VenueOrganizerID" serial NOT NULL,
    "Name" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "ContactInfo" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "VenueOrganizer_pkey" PRIMARY KEY ("VenueOrganizerID")
);

ALTER TABLE IF EXISTS "eventManagement"."Commission"
    ADD CONSTRAINT "Commission_ResellerID_fkey" FOREIGN KEY ("ResellerID")
    REFERENCES "eventManagement"."Reseller" ("ResellerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."Commission"
    ADD CONSTRAINT "Commission_SaleDetailID_fkey" FOREIGN KEY ("SaleDetailID")
    REFERENCES "eventManagement"."TicketSaleDetail" ("SaleDetailID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."Event"
    ADD CONSTRAINT "VenueOrganizerID" FOREIGN KEY ("VenueOrganizerID")
    REFERENCES "eventManagement"."VenueOrganizer" ("VenueOrganizerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."EventTicketAllocation"
    ADD CONSTRAINT "ResellerID" FOREIGN KEY ("ResellerID")
    REFERENCES "eventManagement"."Reseller" ("ResellerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."EventTicketAllocation"
    ADD CONSTRAINT "TicketCategoryID" FOREIGN KEY ("TicketCategoryID")
    REFERENCES "eventManagement"."TicketCategory" ("TicketCategoryID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."Seller"
    ADD CONSTRAINT "Seller_ResellerID_fkey" FOREIGN KEY ("ResellerID")
    REFERENCES "eventManagement"."Reseller" ("ResellerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS "eventManagement"."Seller"
    ADD CONSTRAINT "Seller_VenueOrganizerID_fkey" FOREIGN KEY ("VenueOrganizerID")
    REFERENCES "eventManagement"."VenueOrganizer" ("VenueOrganizerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS "eventManagement"."SubEvent"
    ADD CONSTRAINT "EventId" FOREIGN KEY ("EventId")
    REFERENCES "eventManagement"."Event" ("EventId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."TicketCategory"
    ADD CONSTRAINT "SubEventId" FOREIGN KEY ("SubEventId")
    REFERENCES "eventManagement"."SubEvent" ("SubEventId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."TicketSale"
    ADD CONSTRAINT "CustomerID" FOREIGN KEY ("CustomerID")
    REFERENCES "eventManagement"."Customer" ("CustomerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."TicketSale"
    ADD CONSTRAINT "SellerId" FOREIGN KEY ("SellerID")
    REFERENCES "eventManagement"."Seller" ("SellerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."TicketSaleDetail"
    ADD CONSTRAINT "SaleID" FOREIGN KEY ("SaleID")
    REFERENCES "eventManagement"."TicketSale" ("SaleID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS "eventManagement"."TicketSaleDetail"
    ADD CONSTRAINT "TicketSaleDetail_TicketCategoryID_fkey" FOREIGN KEY ("TicketCategoryID")
    REFERENCES "eventManagement"."TicketCategory" ("TicketCategoryID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;