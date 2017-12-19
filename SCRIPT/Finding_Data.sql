SELECT * FROM ultimate_routes WHERE route_name like N'%Чишмы%Уфа%'

SELECT * FROM ULTIMATE_routes WHERE Group_Number=303

select b.ROUTE_NAME,a.DDATE,c.STOP_NAME,c.GROUP_NUMBER,d.STOP_NAME,a.AMOUNT from ULTIMATE_DS_TRANSACT a
join ULTIMATE_ROUTES b on (b.SOURCE_REGION=IdDataSource and b.SOURCE_CODE=IdRoute)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=IdDataSource and c.SOURCE_CODE=BSTOP)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=IdDataSource and d.SOURCE_CODE=ESTOP)
where IdDataSource=2 and IdRoute=3701
and
(DATEPART(MM,DDATE) = 7 and DATEPART(DD,DDATE) in (17,18,19,20,21))

SELECt * from ULTIMATE_STOPS where group_number = 10

select * from VisumRouteList where Name like N'%Уфа%Салават%'

SELECT * FROM VisumDistances a join ULTIMATE_STOPS b on (a.StopId=b.SOURCE_CODE and b.SOURCE=1)
--join ULTIMATE_RBS c on (c.STOP_ID=b.ID and replace(c.ROUTE_NAME,' ','') like replace(a.Name,' ',''))
where a.Name like N'%Уфа%Чишмы%'

select * from ultimate_rbs where ROUTE_ID=1118

select c.STOP_NAME,d.STOP_NAME,a.AMOUNT,c.GROUP_NUMBER,d.GROUP_NUMBER from 
(select IdDataSource,IdRoute,BSTOP,ESTOP,Sum(AMOUNT) AMOUNT from ULTIMATE_DS_TRANSACT group by IdDataSource,IdRoute,BSTOP,ESTOP) a 
join ULTIMATE_ROUTES b on (b.SOURCE_REGION=a.IdDataSource and b.SOURCE_CODE=a.IdRoute and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE=2 and c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP)
join ULTIMATE_STOPS d on (d.SOURCE=2 and d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP)
where b.ID in (1489)

select a.AMOUNT,BGN,EGN from 
(select ROUTE_ID,BGN,EGN,Sum(CAST(AMOUNT as INT)) AMOUNT from ULTIMATE_RISE_TRANSACT group by ROUTE_ID,BGN,EGN) a 
join ULTIMATE_ROUTES b on (a.ROUTE_ID=b.ID)
where b.ID in (200004,200005,200006,200007,200008,200009)

select * from ULTIMATE_RBS 
where ROUTE_ID in (200004,200005,200006,200007,200008,200009)

select x.ID ROUTE_ID, x.ROUTE_NAME, a.[Index] STOP_INDEX, a.StopName STOP_NAME, b.ID STOP_ID, c.AllDist
from ReestrAsVisumByStop a 
join ULTIMATE_ROUTES x on (x.ID=200054)
join ULTIMATE_STOPS b on (a.StopId=b.SOURCE_CODE and b.SOURCE=1) 
left join VisumDistances c on (a.StopId=c.StopId and c.Name like N'%Уфа%Салават%')
where a.Name like N'Уфа - Салават через Ишимбай'
order by x.ID,a.[Index],b.ID
