﻿SELECT RNAME,RNUMBER,BSTOP,BLA,BLO,ESTOP,ELA,ELO,ACTIVEDAYS,M,N,E,G FROM (
SELECT ROUTE_NAME RNAME, ROUTE_NUMBER RNUMBER, ROW_NUMBER() OVER(PARTITION BY RGN,BSTOP,BLA,BLO,ESTOP,ELA,ELO ORDER BY ABS(1-SOURCE),LEN(ROUTE_NAME) ASC) RANG,BSTOP,BLA,BLO,ESTOP,ELA,ELO,ACTIVEDAYS,M,N,E,G FROM (
SELECT RGN,BSTOP,BLA,BLO,ESTOP,ELA,ELO,ACTIVEDAYS,SUM(M) M,SUM(N) N,SUM(E) E,SUM(G) G FROM
(
SELECT RGN,
CASE 
	WHEN a.CITY_NUMBER like '' THEN a.STOP_NAME
	WHEN a.CITY_NUMBER not like '' THEN a.CITY_NUMBER
END BSTOP,
CASE 
	WHEN a.CITY_NUMBER like '' THEN a.LATITUDE
	WHEN a.CITY_NUMBER not like '' THEN ax.LA
END BLA,
CASE 
	WHEN a.CITY_NUMBER like '' THEN a.LONGITUDE
	WHEN a.CITY_NUMBER not like '' THEN ax.LO
END BLO,
CASE 
	WHEN b.CITY_NUMBER like '' THEN b.STOP_NAME
	WHEN b.CITY_NUMBER not like '' THEN b.CITY_NUMBER
END ESTOP,
CASE 
	WHEN b.CITY_NUMBER like '' THEN b.LATITUDE
	WHEN b.CITY_NUMBER not like '' THEN bx.LA
END ELA,
CASE 
	WHEN b.CITY_NUMBER like '' THEN b.LONGITUDE
	WHEN b.CITY_NUMBER not like '' THEN bx.LO
END ELO,
ACTIVEDAYS,M,N,E,G FROM (
SELECT RGN,BID,EID,ACTIVEDAYS,M,N,E,G FROM (
SELECT RGN,a.ID BID,b.ID EID,
ROW_NUMBER() OVER(PARTITION BY RGN,BGN,EGN 
ORDER BY (a.LATITUDE-b.LATITUDE)*(a.LATITUDE-b.LATITUDE)+(a.LONGITUDE-b.LONGITUDE)*(a.LONGITUDE-b.LONGITUDE) ASC) RANG,
ACTIVEDAYS,M,N,E,G FROM
(
--[[[-----------------]]]
--[[[PROCESSING STARTS]]]
--[[[-----------------]]]
SELECT RGN,BGN,EGN,ACTIVEDAYS,ISNULL(M,0) M,ISNULL(N,0) N,ISNULL(E,0) E,ISNULL(G,0) G FROM 
(
SELECT DAYPART,x.RGN,BGN,EGN,1.0*AMOUNT/ACTIVEDAYS AVGAMOUNT, ACTIVEDAYS FROM
(
SELECT DAYPART,RGN,BGN,EGN,SUM(AMOUNT) AMOUNT
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
END DAYPART,DDAY,DMON,DDOW, b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
join ULTIMATE_STOPS c on (c.ID=a.BGN)
join ULTIMATE_STOPS d on (d.ID=a.EGN)
) x

--
--[[[FILTER BEGIN]]]
where 
--(RGN in (109)) and 
--(DMON = 4 and DDAY in (3,4,5,6,7,8,9)) 
(DMON = 7 and DDAY in (17,18,19,20,21,22,23))
AND
(DDOW in (6,2,3,4,5))
--(DDOW in (1,7))
--[[[FILTER END]]]

GROUP BY DAYPART,DDAY,DMON,DDOW,RGN,BGN,EGN
) x
GROUP BY DAYPART,x.RGN,BGN,EGN
) x join
(SELECT COUNT(CONCAT(STR(DDAY),'.',STR(DMON))) ACTIVEDAYS,RGN FROM (
select distinct
DATEPART(DD,a.DDATE) DDAY,DATEPART(MM,a.DDATE) DMON,DATEPART(DW,a.DDATE) DDOW,b.GROUP_NUMBER RGN from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
UNION
select distinct DDAY,DMON,DDOW, b.GROUP_NUMBER RGN from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x 
--[[[FILTER BEGIN]]]
where 
--(RGN in (109)) and 
--(DMON = 4 and DDAY in (3,4,5,6,7,8,9)) 
(DMON = 7 and DDAY in (17,18,19,20,21,22,23))
AND
(DDOW in (6,2,3,4,5))
--(DDOW in (1,7))
--[[[FILTER END]]]
GROUP BY RGN
) y on (x.RGN=y.RGN)
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
join ULTIMATE_STOPS a on (x.BID=a.ID)
join ULTIMATE_STOPS b on (x.EID=b.ID)
join (SELECT CITY_NUMBER,AVG(LATITUDE) LA, AVG(LONGITUDE) LO FROM ULTIMATE_STOPS GROUP BY CITY_NUMBER) ax on (a.CITY_NUMBER=ax.CITY_NUMBER)
join (SELECT CITY_NUMBER,AVG(LATITUDE) LA, AVG(LONGITUDE) LO FROM ULTIMATE_STOPS GROUP BY CITY_NUMBER) bx on (b.CITY_NUMBER=bx.CITY_NUMBER)
) x GROUP BY RGN,BSTOP,BLA,BLO,ESTOP,ELA,ELO,ACTIVEDAYS
) x join ULTIMATE_ROUTES y on (x.RGN=y.GROUP_NUMBER)
) x WHERE RANG=1 