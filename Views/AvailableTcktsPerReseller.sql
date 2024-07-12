-- View: eventManagement.AvailableTcktsPerReseller

-- DROP VIEW "eventManagement"."AvailableTcktsPerReseller";

CREATE OR REPLACE VIEW "eventManagement"."AvailableTcktsPerReseller"
 AS
 WITH sale AS (
         SELECT r."ResellerID",
            tsd."TicketCategoryID",
            sum(tsd."Quantity") AS "Quantity",
            sum(tsd."Amount") AS "TotalAmount"
           FROM "eventManagement"."TicketSaleDetail" tsd
             JOIN "eventManagement"."TicketSale" ts ON tsd."SaleID" = ts."SaleID"
             JOIN "eventManagement"."Seller" s_1 ON ts."SellerID" = s_1."SellerID"
             JOIN "eventManagement"."Reseller" r ON r."ResellerID" = s_1."ResellerID"
             JOIN "eventManagement"."TicketCategory" tc ON tsd."TicketCategoryID" = tc."TicketCategoryID"
          GROUP BY r."ResellerID", tsd."TicketCategoryID"
        ), tck_alloct AS (
         SELECT r."Name",
            eta_1."ResellerID",
            eta_1."TicketCategoryID",
            sum(eta_1."AllocatedTickets") AS "AllocatedTickets"
           FROM "eventManagement"."EventTicketAllocation" eta_1
             JOIN "eventManagement"."Reseller" r ON eta_1."ResellerID" = r."ResellerID"
          GROUP BY r."Name", eta_1."ResellerID", eta_1."TicketCategoryID"
        )
 SELECT eta."Name" AS "Reseller_Name",
    sum(eta."AllocatedTickets") AS "AllocatedTickets",
    COALESCE(sum(s."Quantity"), 0::numeric) AS "SoldTicket",
    sum(eta."AllocatedTickets" - COALESCE(s."Quantity", 0::numeric)) AS "Available_ticket"
   FROM tck_alloct eta
     LEFT JOIN sale s ON eta."TicketCategoryID" = s."TicketCategoryID" AND eta."ResellerID" = s."ResellerID"
  GROUP BY eta."Name";

ALTER TABLE "eventManagement"."AvailableTcktsPerReseller"
    OWNER TO postgres;

