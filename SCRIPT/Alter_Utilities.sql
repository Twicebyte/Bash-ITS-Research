﻿sELECT * from ULTIMATE_ROUTES WHERE (GROUP_NUMBER=101)

SELECT b.SOURCE,a.*,c.GROUP_NUMBER,c.CITY_NUMBER from ULTIMATE_RBS a 
join ULTIMATE_STOPS c on (c.ID=a.STOP_ID)
JOIN
(select * from ULTIMATE_ROUTES where GROUP_NUMBER=101)
b on (a.ROUTE_ID=b.ID) 
ORDER BY ROUTE_ID,DISTANCE,STOP_INDEX

SELECT * FROM ULTIMATE_STOPS WHERE GROUP_NUMBER in (7365,502422)

UPDATE ULTIMATE_STOPS SET GROUP_NUMBER=(9) WHERE GROUP_NUMBER IN (9,11008)


DELETE FROM ULTIMATE_RBS WHERE ROUTE_ID in (SELECT ID FROM VID_ULR)

INSERT INTO ULTIMATE_RBS
SELECT ROUTE_ID,ROUTE_NAME,STOP_INDEX,STOP_NAME,STOP_ID,DISTANCE FROM (
SELECT ROW_NUMBER() OVER(PARTITION BY b.id,alldist,StopId ORDER BY d.id) RANG, b.ID ROUTE_ID, b.ROUTE_NAME, c.[Index] STOP_INDEX, d.STOP_NAME, d.ID STOP_ID, c.AllDist DISTANCE 
FROM VID_ULR a 
join ULTIMATE_ROUTES b on (a.ID=b.ID)
join (SELECT ROUTEANDNAME,DIRECTION,ROW_NUMBER() OVER(partition by Routeandname order by CNT desc) rang FROM
(SELECT ROUTEANDNAME,DIRECTION,COUNT(*) CNT FROM VisumDistances GROUP BY ROUTEANDNAME,DIRECTION) x) x
on (x.rang=1 and x.RouteAndName like a.RouteAndName)
join VisumDistances c on (a.RouteAndName=c.RouteAndName and c.Direction like x.Direction)
join ULTIMATE_STOPS d on (d.SOURCE_CODE=c.StopId and d.SOURCE=1) ) x WHERE RANG=1
ORDER BY ROUTE_ID, DISTANCE, STOP_INDEX, STOP_ID

--DROP TABLE ViD_UlR
select distinct ID,b.ROUTE_NUMBER,b.ROUTE_NAME,RouteAndName --INTO ViD_UlR 
from VisumDistances a join ULTIMATE_ROUTES b on (REPLACE(REPLACE(a.Name,'"',''),' ','') like CONCAT('%',REPLACE(REPLACE(b.ROUTE_NAME,'"',''),' ',''),'%') and RouteAndName like CONCAT('% ',ROUTE_NUMBER,' %')) where SOURCE=1

--INSERT INTO VID_ULR
SELECT distinct b.ID,b.ROUTE_NUMBER,b.ROUTE_NAME,a.RouteAndName FROM VisumDistances a JOIN (
SELECT * FROM ULTIMATE_ROUTES WHERE ID NOT IN (SELECT ID FROM VID_ULR) and SOURCE=1
) b on (a.RouteAndName like CONCAT('% ',b.ROUTE_NUMBER,' %'))

--INSERT INTO VID_ULR VALUES (1012,N'2',N'Туймазы- Октябрьский- Серафимовский',N'П 002 Туймазы - Октябрьский - Серафимовский')

SELECT * FROM VisumDistances WHERE RouteAndName like N'М 737 Уфа - Кандры'

SELECT b.GROUP_NUMBER FROM AVGDIST2 a join ULTIMATE_ROUTES b on (a.ROUTE_NAME like b.ROUTE_NAME) WHERE AVGDIST is NULL

select * from VID_ULR