-- =====================================================================
-- 05_validation.sql : Sanity checks + headline insights
-- =====================================================================

-- Row counts
SELECT 'FACT_BOOKINGS' t, COUNT(*) n FROM FACT_BOOKINGS
UNION ALL SELECT 'DIM_CUSTOMER', COUNT(*) FROM DIM_CUSTOMER
UNION ALL SELECT 'DIM_DATE',     COUNT(*) FROM DIM_DATE;

-- 1. Revenue & cancellation by property type
SELECT h.PROPERTYTYPE,
       COUNT(*)                       AS TOTAL_BOOKINGS,
       ROUND(SUM(f.TOTALREVENUE),2)   AS TOTAL_REVENUE,
       ROUND(AVG(f.ADR),2)            AS AVG_ADR,
       ROUND(100*SUM(CASE WHEN f.ISCANCELLED='Y' THEN 1 ELSE 0 END)/COUNT(*),1) AS CANCEL_RATE_PCT
FROM FACT_BOOKINGS f
JOIN DIM_HOTEL h ON f.HOTELKEY = h.HOTELKEY
GROUP BY h.PROPERTYTYPE;

-- 2. Top 10 source markets
SELECT cu.COUNTRY, COUNT(*) AS BOOKINGS
FROM FACT_BOOKINGS f
JOIN DIM_CUSTOMER cu ON f.CUSTOMERKEY = cu.CUSTOMERKEY
GROUP BY cu.COUNTRY
ORDER BY BOOKINGS DESC
FETCH FIRST 10 ROWS ONLY;

-- 3. Seasonal booking pattern by month
SELECT d.MONTHNAME, d.MONTHNUMBER, COUNT(*) AS BOOKINGS
FROM FACT_BOOKINGS f
JOIN DIM_DATE d ON f.DATEKEY = d.DATEKEY
GROUP BY d.MONTHNAME, d.MONTHNUMBER
ORDER BY d.MONTHNUMBER;
