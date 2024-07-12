-- View: eventManagement.CommisionPerEvent

-- DROP VIEW "eventManagement"."CommisionPerEvent";

CREATE OR REPLACE VIEW "eventManagement"."CommisionPerEvent"
 AS
 SELECT r."Name" AS "ResellerName",
    e."EventName",
    se."EventDate",
    sum(COALESCE(cms."CommissionAmount", 0::numeric)) AS "TotalCommision"
   FROM "eventManagement"."Commission" cms
     JOIN "eventManagement"."TicketSaleDetail" tsd ON cms."SaleDetailID" = tsd."SaleDetailID"
     JOIN "eventManagement"."TicketSale" ts ON tsd."SaleID" = ts."SaleID"
     JOIN "eventManagement"."Seller" s ON ts."SellerID" = s."SellerID"
     JOIN "eventManagement"."Reseller" r ON r."ResellerID" = s."ResellerID"
     JOIN "eventManagement"."TicketCategory" tc ON tsd."TicketCategoryID" = tc."TicketCategoryID"
     JOIN "eventManagement"."SubEvent" se ON tc."SubEventId" = se."SubEventId"
     JOIN "eventManagement"."Event" e ON se."EventId" = e."EventId"
  GROUP BY r."Name", e."EventName", se."EventDate"
  ORDER BY r."Name";

ALTER TABLE "eventManagement"."CommisionPerEvent"
    OWNER TO postgres;

