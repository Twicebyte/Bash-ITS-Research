--drop table somecrap1

SELECT y.RNAME,y.RNUMBER,UFA_BOUND,AMOUNT FROM (
SELECT RGN,UFA_BOUND,SUM(AMOUNT) AMOUNT FROM (
select 
DATEPART(DD,a.DDATE) DDAY,DATEPART(MM,a.DDATE) DMON,DATEPART(DW,a.DDATE) DDOW, b.GROUP_NUMBER RGN,
CASE
	WHEN (c.CITY_NUMBER like 'Уфа' or d.CITY_NUMBER like 'Уфа') and (c.CITY_NUMBER not like d.CITY_NUMBER) THEN 1
	WHEN (c.CITY_NUMBER not like 'Уфа' and d.CITY_NUMBER not like 'Уфа') THEN 0
END UFA_BOUND,
AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and b.SOURCE=2)
join ULTIMATE_STOPS d on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.eSTOP and b.SOURCE=2)
UNION ALL
select 
DATEPART(DD,a.StartDate) DDAY,DATEPART(MM,a.StartDate) DMON,DATEPART(DW,a.StartDate) DDOW, b.GROUP_NUMBER RGN,
CASE
	WHEN (c.CITY_NUMBER like 'Уфа' or d.CITY_NUMBER like 'Уфа') and (c.CITY_NUMBER not like d.CITY_NUMBER) THEN 1
	WHEN (c.CITY_NUMBER not like 'Уфа' and d.CITY_NUMBER not like 'Уфа') THEN 0
END UFA_BOUND,
AMOUNT from RisePassengerAmount a join ULTIMATE_ROUTES b 
on (a.RouteName like b.ROUTE_NAME and a.RouteNumber like b.ROUTE_NUMBER and b.SOURCE=0)
join ULTIMATE_STOPS c on (a.StartStop like c.STOP_NAME and b.SOURCE=0)
join ULTIMATE_RBS bc on (b.ID=bc.ROUTE_ID and c.ID=bc.STOP_ID)
join ULTIMATE_STOPS d on (a.EndStop like d.STOP_NAME and b.SOURCE=0)
join ULTIMATE_RBS bd on (b.ID=bd.ROUTE_ID and d.ID=bd.STOP_ID)
) x
--
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
GROUP BY RGN,UFA_BOUND)
x
join Ufa_Intercity y on (x.RGN=y.RGN)