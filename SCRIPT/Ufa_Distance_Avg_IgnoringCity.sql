﻿SELECT y.GROUP_NUMBER,y.ROUTE_NAME,y.ROUTE_NUMBER,x.DISTANCE from (
SELECT RID,SUM(DISTANCE*AMOUNT)/SUM(AMOUNT) DISTANCE FROM(
SELECT y.RID,x.BGN,x.EGN,x.AMOUNT,AVG(ABS(d.DISTANCE-c.DISTANCE)) DISTANCE FROM (
SELECT RGN,BGN,EGN,SUM(AMOUNT) AMOUNT FROM (
select 
 b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and c.SOURCE=2)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP and d.SOURCE=2)
UNION ALL
select 
 b.GROUP_NUMBER RGN,BGN,EGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x
GROUP BY RGN,BGN,EGN
) x
join (SELECT b.ID as RID, b.GROUP_NUMBER as RGN FROM Ufa_Intercity a 
join ULTIMATE_ROUTES b on (a.RGN like b.GROUP_NUMBER and b.SOURCE=1)) y
on (x.RGN=y.RGN)
join ULTIMATE_STOPS a on (a.GROUP_NUMBER=x.BGN and a.SOURCE=1)
join ULTIMATE_STOPS b on (b.GROUP_NUMBER=x.EGN and b.SOURCE=1)
join ULTIMATE_RBS c on (c.ROUTE_ID=RID and c.STOP_ID=a.ID and c.DISTANCE is not null)
join ULTIMATE_RBS d on (d.ROUTE_ID=RID and d.STOP_ID=b.ID and d.DISTANCE is not null)
WHERE (a.CITY_NUMBER not like N'Уфа' and b.CITY_NUMBER not like N'Уфа')
GROUP BY y.RID,x.BGN,x.EGN,x.AMOUNT
UNION ALL
SELECT y.RID,x.BGN,x.EGN,x.AMOUNT,AVG(ABS(d.DISTANCE-12)) DISTANCE FROM (
SELECT RGN,BGN,EGN,SUM(AMOUNT) AMOUNT FROM (
select 
 b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and c.SOURCE=2)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP and d.SOURCE=2)
UNION ALL
select 
 b.GROUP_NUMBER RGN,BGN,EGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x
GROUP BY RGN,BGN,EGN
) x
join (SELECT b.ID as RID, b.GROUP_NUMBER as RGN FROM Ufa_Intercity a 
join ULTIMATE_ROUTES b on (a.RGN like b.GROUP_NUMBER and b.SOURCE=1)) y
on (x.RGN=y.RGN)
join ULTIMATE_STOPS a on (a.GROUP_NUMBER=x.BGN and a.SOURCE=1)
join ULTIMATE_STOPS b on (b.GROUP_NUMBER=x.EGN and b.SOURCE=1)
join ULTIMATE_RBS d on (d.ROUTE_ID=RID and d.STOP_ID=b.ID and d.DISTANCE is not null)
WHERE (a.CITY_NUMBER like N'Уфа' and b.CITY_NUMBER not like N'Уфа')
GROUP BY y.RID,x.BGN,x.EGN,x.AMOUNT
UNION ALL
SELECT y.RID,x.BGN,x.EGN,x.AMOUNT,AVG(ABS(c.DISTANCE-12)) DISTANCE FROM (
SELECT RGN,BGN,EGN,SUM(AMOUNT) AMOUNT FROM (
select 
 b.GROUP_NUMBER RGN,c.GROUP_NUMBER BGN,d.GROUP_NUMBER EGN,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b 
on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE and b.SOURCE=2)
join ULTIMATE_STOPS c on (c.SOURCE_REGION=a.IdDataSource and c.SOURCE_CODE=a.BSTOP and c.SOURCE=2)
join ULTIMATE_STOPS d on (d.SOURCE_REGION=a.IdDataSource and d.SOURCE_CODE=a.ESTOP and d.SOURCE=2)
UNION ALL
select 
 b.GROUP_NUMBER RGN,BGN,EGN,AMOUNT from ULTIMATE_RISE_TRANSACT a join ULTIMATE_ROUTES b 
on (a.ROUTE_ID=b.ID)
) x
GROUP BY RGN,BGN,EGN
) x
join (SELECT b.ID as RID, b.GROUP_NUMBER as RGN FROM Ufa_Intercity a 
join ULTIMATE_ROUTES b on (a.RGN like b.GROUP_NUMBER and b.SOURCE=1)) y
on (x.RGN=y.RGN)
join ULTIMATE_STOPS a on (a.GROUP_NUMBER=x.BGN and a.SOURCE=1)
join ULTIMATE_STOPS b on (b.GROUP_NUMBER=x.EGN and b.SOURCE=1)
join ULTIMATE_RBS c on (c.ROUTE_ID=RID and c.STOP_ID=a.ID and c.DISTANCE is not null)
WHERE (a.CITY_NUMBER not like N'Уфа' and b.CITY_NUMBER like N'Уфа')
GROUP BY y.RID,x.BGN,x.EGN,x.AMOUNT
) x
GROUP BY RID
) x 
join ULTIMATE_ROUTES y on (x.RID=y.ID)