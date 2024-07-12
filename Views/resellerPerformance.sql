-- View: eventManagement.resellerPerformance

-- DROP VIEW "eventManagement"."resellerPerformance";

CREATE OR REPLACE VIEW "eventManagement"."resellerPerformance"
 AS
 WITH sales AS (
         SELECT tsd."TicketCategoryID",
            s_1."ResellerID",
            e."VenueOrganizerID",
            sum(tsd."Quantity") AS "TicketSold"
           FROM "eventManagement"."TicketSaleDetail" tsd
             JOIN "eventManagement"."TicketSale" ts ON tsd."SaleID" = ts."SaleID"
             JOIN "eventManagement"."Seller" s_1 ON ts."SellerID" = s_1."SellerID"
             JOIN "eventManagement"."Reseller" r ON r."ResellerID" = s_1."ResellerID"
             JOIN "eventManagement"."TicketCategory" tc ON tsd."TicketCategoryID" = tc."TicketCategoryID"
             JOIN "eventManagement"."SubEvent" se ON tc."SubEventId" = se."SubEventId"
             JOIN "eventManagement"."Event" e ON se."EventId" = e."EventId"
             JOIN "eventManagement"."VenueOrganizer" vo ON e."VenueOrganizerID" = vo."VenueOrganizerID"
          GROUP BY tsd."TicketCategoryID", s_1."ResellerID", e."VenueOrganizerID"
        ), tckt_alloct AS (
         SELECT eta."TicketCategoryID",
            vo."VenueOrganizerID",
            vo."Name" AS "VenueOrganizerName",
            r."Name" AS "ResellerName",
            eta."ResellerID",
            sum(eta."AllocatedTickets") AS "AllocatedTickets"
           FROM "eventManagement"."EventTicketAllocation" eta
             JOIN "eventManagement"."TicketCategory" tc ON eta."TicketCategoryID" = tc."TicketCategoryID"
             JOIN "eventManagement"."SubEvent" se ON tc."SubEventId" = se."SubEventId"
             JOIN "eventManagement"."Event" e ON se."EventId" = e."EventId"
             JOIN "eventManagement"."VenueOrganizer" vo ON e."VenueOrganizerID" = vo."VenueOrganizerID"
             JOIN "eventManagement"."Reseller" r ON eta."ResellerID" = r."ResellerID"
          GROUP BY eta."TicketCategoryID", vo."VenueOrganizerID", vo."Name", r."Name", eta."ResellerID"
          ORDER BY eta."TicketCategoryID"
        )
 SELECT ta."VenueOrganizerName",
    ta."ResellerName",
    sum(COALESCE(ta."AllocatedTickets", 0::numeric)) AS "AllocatedTickets",
    sum(COALESCE(s."TicketSold", 0::numeric)) AS "TicketSold",
    (sum(COALESCE(s."TicketSold", 0::numeric)) / sum(COALESCE(ta."AllocatedTickets", 0::numeric)) * 100::numeric)::numeric(5,2) AS "SalePercentage"
   FROM tckt_alloct ta
     LEFT JOIN sales s ON ta."TicketCategoryID" = s."TicketCategoryID" AND ta."ResellerID" = s."ResellerID"
  GROUP BY ta."VenueOrganizerName", ta."ResellerName"
  ORDER BY ta."VenueOrganizerName", ((sum(COALESCE(s."TicketSold", 0::numeric)) / sum(COALESCE(ta."AllocatedTickets", 0::numeric)) * 100::numeric)::numeric(5,2)) DESC;

ALTER TABLE "eventManagement"."resellerPerformance"
    OWNER TO postgres;

