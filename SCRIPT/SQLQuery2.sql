﻿--drop table AVGDIST2

SELECT ROUTE_NUMBER, ROUTE_NAME, SUMDIST/AMOUNT AVGDIST --into AVGDIST2 
FROM (
SELECT RGN, SUM(AMOUNT) AMOUNT, SUM(AMOUNT*DIST) SUMDIST FROM (
select RGN,BGN,EGN,AMOUNT,avg(abs(ac.DISTANCE - bc.DISTANCE)) DIST from (
SELECT RGN,BGN,EGN,M+N+E+G AMOUNT FROM (
SELECT RGN,BGN,EGN,a.ID BID,b.ID EID,
ROW_NUMBER() OVER(PARTITION BY RGN,BGN,EGN 
ORDER BY (a.LATITUDE-b.LATITUDE)*(a.LATITUDE-b.LATITUDE)+(a.LONGITUDE-b.LONGITUDE)*(a.LONGITUDE-b.LONGITUDE) ASC) RANG,
M,N,E,G FROM
(
--[[[-----------------]]]
--[[[PROCESSING STARTS]]]
--[[[-----------------]]]
SELECT RGN,BGN,EGN,ISNULL(M,0) M,ISNULL(N,0) N,ISNULL(E,0) E,ISNULL(G,0) G FROM 
(
SELECT DAYPART,RGN,BGN,EGN,SUM(AMOUNT) AVGAMOUNT
FROM
(
SELECT DAYPART,DDAY,DMON,DDOW,RGN,BGN,EGN,SUM(AMOUNT) AMOUNT FROM (
select 
CASE 
      WHEN DATEPART(HH,a.DDATE) >= 6 AND DATEPART(HH,a.DDATE)<10 THEN 'M' 
      WHEN DATEPART(HH,a.DDATE) >= 10 AND DATEPART(HH,a.DDATE)<16 THEN 'N' 
      WHEN DATEPART(HH,a.DDATE) >= 16 AND DATEPART(HH,a.DDATE)<20 THEN 'E' 
      WHEN DATEPART(HH,a.DDATE) >= 20 OR DATEPART(HH,a.DDATE)<6 THEN 'G' 
END DAYPART,DATEPART(DD,a.DDATE) DDAY,DATEPART(MM,a.DDATE) DMON,DATEPART(DW,a.DDATE) DDOW, b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and c.SOURCE=2)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP and d.SOURCE=2)
UNION ALL
select 
CASE 
      WHEN DHOR >= 6 AND DHOR<10 THEN 'M' 
      WHEN DHOR >= 10 AND DHOR<16 THEN 'N' 
      WHEN DHOR >= 16 AND DHOR<20 THEN 'E' 
      WHEN DHOR >= 20 OR DHOR<6 THEN 'G' 
END DAYPART,DDAY,DMON,DDOW, b.GROUP_NUMBER RGN,BGN,EGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x

--
--[[[FILTER BEGIN]]]
--where 
--(RGN in (109)) and 
--(DMON = 4 and DDAY in (3,4,5,6,7,8,9)) 
--(DMON = 7 and DDAY in (17,18,19,20,21,22,23))
--AND
--(DDOW in (6,2,3,4,5))
--(DDOW in (1,7))
--[[[FILTER END]]]

GROUP BY DAYPART,DDAY,DMON,DDOW,RGN,BGN,EGN
) x
GROUP BY DAYPART,x.RGN,BGN,EGN
) x
PIVOT
( AVG(AVGAMOUNT) FOR DAYPART IN (M,N,E,G)) y
--[[[---------------]]]
--[[[PROCESSING ENDS]]]
--[[[---------------]]]
) x 
join ULTIMATE_STOPS a on (x.BGN=a.GROUP_NUMBER)
join ULTIMATE_STOPS b on (x.EGN=b.GROUP_NUMBER)
WHERE a.SOURCE=1 and b.SOURCE=1
) x WHERE RANG=1
) x 
join ULTIMATE_STOPS a on (x.BGN=a.GROUP_NUMBER)
join ULTIMATE_STOPS b on (x.EGN=b.GROUP_NUMBER)
join ULTIMATE_ROUTES c on (c.GROUP_NUMBER=x.RGN)
join ULTIMATE_RBS ac on (c.ID=ac.ROUTE_ID and a.ID=ac.STOP_ID)
join ULTIMATE_RBS bc on (c.ID=bc.ROUTE_ID and b.ID=bc.STOP_ID)
WHERE ac.DISTANCE is not null and bc.DISTANCE is not null and BGN!=EGN
group by RGN,BGN,EGN,AMOUNT
) x GROUP BY RGN
) x join ULTIMATE_ROUTES y on (y.Group_Number=RGN and source=1)