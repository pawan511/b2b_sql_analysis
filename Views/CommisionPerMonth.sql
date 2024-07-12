-- View: eventManagement.CommisionPerMonth

-- DROP VIEW "eventManagement"."CommisionPerMonth";

CREATE OR REPLACE VIEW "eventManagement"."CommisionPerMonth"
 AS
 SELECT r."Name" AS "ResellerName",
    upper(to_char(ts."SaleDate", 'month'::text)) AS month,
    sum(COALESCE(cms."CommissionAmount", 0::numeric)) AS "TotalCommision"
   FROM "eventManagement"."Commission" cms
     JOIN "eventManagement"."TicketSaleDetail" tsd ON cms."SaleDetailID" = tsd."SaleDetailID"
     JOIN "eventManagement"."TicketSale" ts ON tsd."SaleID" = ts."SaleID"
     JOIN "eventManagement"."Seller" s ON ts."SellerID" = s."SellerID"
     JOIN "eventManagement"."Reseller" r ON r."ResellerID" = s."ResellerID"
  GROUP BY r."Name", (upper(to_char(ts."SaleDate", 'month'::text)))
  ORDER BY r."Name";

ALTER TABLE "eventManagement"."CommisionPerMonth"
    OWNER TO postgres;

