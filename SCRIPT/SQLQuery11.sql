﻿--drop table somecrap1

SELECT ROUTE_NAME,ROUTE_NUMBER,AMOUNT 
--into somecrap1 
FROM(
SELECT ROW_NUMBER() OVER(PARTITION BY RGN ORDER BY LEN(ROUTE_NAME) ASC) rang, ROUTE_NAME,ROUTE_NUMBER,AMOUNT FROM (
SELECT RGN,SUM(AMOUNT) AMOUNT FROM (
select 
CASE 
      WHEN DATEPART(HH,a.DDATE) >= 6 AND DATEPART(HH,a.DDATE)<10 THEN 'M' 
      WHEN DATEPART(HH,a.DDATE) >= 10 AND DATEPART(HH,a.DDATE)<16 THEN 'N' 
      WHEN DATEPART(HH,a.DDATE) >= 16 AND DATEPART(HH,a.DDATE)<20 THEN 'E' 
      WHEN DATEPART(HH,a.DDATE) >= 20 OR DATEPART(HH,a.DDATE)<6 THEN 'G' 
END DAYPART,DATEPART(DD,a.DDATE) DDAY,DATEPART(MM,a.DDATE) DMON,DATEPART(DW,a.DDATE) DDOW, b.GROUP_NUMBER RGN,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
UNION ALL
select 
CASE 
      WHEN DHOR >= 6 AND DHOR<10 THEN 'M' 
      WHEN DHOR >= 10 AND DHOR<16 THEN 'N' 
      WHEN DHOR >= 16 AND DHOR<20 THEN 'E' 
      WHEN DHOR >= 20 OR DHOR<6 THEN 'G' 
END DAYPART,DDAY,DMON,DDOW, b.GROUP_NUMBER RGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x
--
--[[[FILTER BEGIN]]]
--where 
--(RGN in (109)) and 
--(DMON = 4 and DDAY in (3,4,5,6,7,8,9)) 
--or
--(DMON = 7 and DDAY in (17,18,19,20,21,22,23))
--AND
--(DDOW in (6,2,3,4,5))
--(DDOW in (1,7))
--[[[FILTER END]]]
GROUP BY RGN)
x
join ULTIMATE_ROUTES y on (x.RGN=y.GROUP_NUMBER and y.SOURCE=1)
) x WHERE RaNG=1