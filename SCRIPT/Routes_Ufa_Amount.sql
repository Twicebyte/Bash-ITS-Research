SELECT RNAME,RNUMBER,isnull([1],CONCAT('AMOUNT: ',STR(0),'; AVGDIST: ',STR(0))) as WITH_UFA,isnull([0],CONCAT('AMOUNT: ',STR(0),'; AVGDIST: ',STR(0))) as NO_UFA FROM (
Select RNAME,RNUMBER,UFA_BOUND,CONCAT('AMOUNT: ',STR(AMOUNT),'; AVGDIST: ',STR(Dist/Amount)) VAL FROM (
SELECT y.RNAME,y.RNUMBER,UFA_BOUND,SUM(AMOUNT) Amount, SUM(AMOUNT*Dist) DIST FROM (
SELECT RGN,BGN,EGN,UFA_BOUND,SUM(AMOUNT) AMOUNT,AVG(DIST) DIST FROM (
select 
2 SOURCE, 
--DATEPART(DD,a.DDATE) DDAY,DATEPART(MM,a.DDATE) DMON,DATEPART(DW,a.DDATE) DDOW, 
b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,
CASE
	WHEN (c.CITY_NUMBER like N'Уфа%' or d.CITY_NUMBER like N'Уфа%') and (c.CITY_NUMBER not like d.CITY_NUMBER) THEN 1
	WHEN (c.CITY_NUMBER not like N'Уфа%' and d.CITY_NUMBER not like N'Уфа%') THEN 0
END UFA_BOUND,
AMOUNT,abs(bc.DISTANCE - bd.DISTANCE) DIST from ULTIMATE_DS_TRANSACT a 
join ULTIMATE_ROUTES b on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and c.SOURCE=2)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP and d.SOURCE=2)
join ULTIMATE_RBS bc on (b.ID=bc.ROUTE_ID and c.ID=bc.STOP_ID)
join ULTIMATE_RBS bd on (b.ID=bd.ROUTE_ID and d.ID=bd.STOP_ID)
join Ufa_Intercity y on (b.GROUP_NUMBER=y.RGN)
UNION ALL
select 
0 Source, 
--DATEPART(DD,a.StartDate) DDAY,DATEPART(MM,a.StartDate) DMON,DATEPART(DW,a.StartDate) DDOW, 
b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,
CASE
	WHEN (c.CITY_NUMBER like N'Уфа%' or d.CITY_NUMBER like N'Уфа%') and (c.CITY_NUMBER not like d.CITY_NUMBER) THEN 1
	WHEN (c.CITY_NUMBER not like N'Уфа%' and d.CITY_NUMBER not like N'Уфа%') THEN 0
END UFA_BOUND,
AMOUNT,abs(bc.DISTANCE - bd.DISTANCE) DIST from RiseContracted a 
join ULTIMATE_ROUTES b on (a.RouteName like b.ROUTE_NAME and b.SOURCE=0)
join ULTIMATE_STOPS c on (a.StartStop like c.STOP_NAME and b.SOURCE=0)
join ULTIMATE_RBS bc on (b.ID=bc.ROUTE_ID and c.ID=bc.STOP_ID)
join ULTIMATE_STOPS d on (a.EndStop like d.STOP_NAME and b.SOURCE=0)
join ULTIMATE_RBS bd on (b.ID=bd.ROUTE_ID and d.ID=bd.STOP_ID)
join Ufa_Intercity y on (b.GROUP_NUMBER=y.RGN)
) x
--[[[FILTER BEGIN]]]
--where
--(RGN in (109))
--and 
--(DMON = 4 and DDAY in (3,4,5,6,7,8,9)) 
--or
--(DMON = 7 and DDAY in (17,18,19,20,21,22,23))
--AND
--(DDOW in (6,2,3,4,5))
--(DDOW in (1,7))
--[[[FILTER END]]]
GROUP BY RGN,BGN,EGN,UFA_BOUND) x
right join Ufa_Intercity y on (x.RGN=y.RGN)
group by y.RNAME,y.RNUMBER,UFA_BOUND
) x
WHERE UFA_BOUND is not NULL
) x
pivot
(
MAX(VAL)
FOR UFA_BOUND in ([0],[1])
) y
ORDER BY RNAME, RNUMBER