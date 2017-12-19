--==================================
--RECONSTRUCT ULTIMATE_RISE_TRANSACT
--==================================

--select * INTO ULTIMATE_RISE_TRANSACT_BACKUP from ULTIMATE_RISE_TRANSACT
--drop table ULTIMATE_RISE_TRANSACT

SELECt ROW_NUMBER() OVER(ORDER BY b.ID,c.GROUP_NUMBER,d.GROUP_NUMBER,DATEPART(MM,a.StartDate),DATEPART(DD,a.StartDate),DATEPART(HH,a.StartDate)) ID, 
b.ID ROUTE_ID, DATEPART(HH,a.StartDate) DHOR, DATEPART(DD,a.StartDate) DDAY,
DATEPART(MM,a.StartDate) DMON, DATEPART(DW,a.StartDate) DDOW, c.GROUP_NUMBER BGN, d.GROUP_NUMBER EGN, SUM(CAST(Amount as INT)) AMOUNT 
--into ULTIMATE_RISE_TRANSACT 
from RisePassengerAmount a 
join ULTIMATE_ROUTES b on (a.RouteName like b.ROUTE_NAME and b.SOURCE=0)
join ULTIMATE_STOPS c on (c.STOP_NAME like StartStop and c.SOURCE=0)
join ULTIMATE_STOPS d on (d.STOP_NAME like EndStop and d.SOURCE=0)
where CONCAT(b.ID,' ',c.ID) in (SELECT CONCAT(ROUTE_ID,' ',STOP_ID) from ULTIMATE_RBS)
and CONCAT(b.ID,' ',d.ID) in (SELECT CONCAT(ROUTE_ID,' ',STOP_ID) from ULTIMATE_RBS)
group by b.ID, DATEPART(HH,a.StartDate), DATEPART(DD,a.StartDate),
DATEPART(MM,a.StartDate), DATEPART(DW,a.StartDate), 
c.GROUP_NUMBER, d.GROUP_NUMBER

--=================================
--REORDER ROUTE AMOUNTS AND AVGDIST
--=================================

select a.* from somecrap2 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER
UNION ALL
(select * from somecrap2
EXCEPT
select a.* from somecrap2 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER)

select a.* from somecrap1 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER
UNION ALL
(select * from somecrap1
EXCEPT
select a.* from somecrap1 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER)

select a.* from AVGDIST2 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER
UNION ALL
(select * from AVGDIST2
EXCEPT
select a.* from AVGDIST2 a join AVGDIST1 b on a.ROUTE_NAME like b.ROUTE_NAME and a.ROUTE_NUMBER like b.ROUTE_NUMBER)

--=================================
--UTILITIES TO BOND STOPS BY GROUPS
--=================================

select * from ultimate_rbs where ROUTE_ID=1203
select * from ULTIMATE_STOPS where ID in (4437,13096,13263,13264)
--update  ULTIMATE_STOPS set GROUP_NUMBER = 4437 where GROUP_NUMBER in (4437,13096)

--=================================
--DROP RBS WHICH HAVE NO CONNECTION
--=================================

--delete from ULTIMATE_RBS where STOP_ID in (Select STOP_ID from ULTIMATE_ROUTES x join ULTIMATE_RBS a on (x.ID=a.ROUTE_ID and x.SOURCE=1)
--left join ULTIMATE_STOPS b on (a.STOP_ID=b.ID) where b.ID is NULL) and
--ROUTE_ID in (Select ID from ULTIMATE_ROUTES where SOURCE=1)

--===============================
--UTILITIES TO ADD SPECIFIC ROUTE
--===============================

select * from ULTIMATE_ROUTES where GROUP_NUMBER = 54
--insert into ULTIMATE_ROUTES VALUES (200054,54,1,NULL,NULL,N'Уфа - Салават через Ишимбай',N'551И',193)

--===================================
--ADD EXTRA ROUTES TO ULTIMATE_ROUTES
--===================================

--INSERT INTO ULTIMATE_ROUTES
SELECT 200073+ROW_NUMBER() OVER(ORDER BY GROUP_NUMBER ASC) ID, GROUP_NUMBER, SOURCE, SOURCE_REGION, SOURCE_CODE, ROUTE_NAME, ROUTE_NUMBER, ITEMS_COUNT from (
SELECT distinct [Group] GROUP_NUMBER, 1 SOURCE, NULL SOURCE_REGION, NULL SOURCE_CODE, Route_NAME ROUTE_NAME, Route_number ROUTE_NUMBER, 0 ITEMS_COUNT FROM
(
Select * from ConnectorReestrGroups a join VisumDistances b on (REPLACE(b.RouteAndName,' ','') like CONCAT('%',REPLACE(a.Route_NAME,' ',''),'%'))
where Direction like '>'
EXCEPT
SELECT a.* from
(Select * from ConnectorReestrGroups a join VisumDistances b on (REPLACE(b.RouteAndName,' ','') like CONCAT('%',REPLACE(a.Route_NAME,' ',''),'%'))
where Direction like '>') a join ULTIMATE_ROUTES b on (a.[Group]=b.GROUP_NUMBER and b.SOURCE=1)
) x
) x

--================================
--ADD EXTRA ROUTES TO ULTIMATE_RBS
--================================

--INSERT INTO ULTIMATE_RBS
SELECT a.ID ROUTE_ID, x.Route_NAME ROUTE_NAME, [Index] STOP_INDEX, StopName STOP_NAME, b.ID STOP_ID, x.AllDist DISTANCE
FROM
(
Select * from ConnectorReestrGroups a join VisumDistances b on (REPLACE(b.RouteAndName,' ','') like CONCAT('%',REPLACE(a.Route_NAME,' ',''),'%'))
where Direction like '>'
EXCEPT
SELECT a.* from
(Select * from ConnectorReestrGroups a join VisumDistances b on (REPLACE(b.RouteAndName,' ','') like CONCAT('%',REPLACE(a.Route_NAME,' ',''),'%'))
where Direction like '>') a join ULTIMATE_ROUTES b on (a.[Group]=b.GROUP_NUMBER and b.SOURCE=1) join ULTIMATE_RBS c on (c.ROUTE_ID=b.ID)
) x
join ULTIMATE_ROUTES a on (a.GROUP_NUMBER=x.[Group] and a.SOURCE=1)
join ULTIMATE_STOPS b on (b.SOURCE_CODE=x.StopId and b.SOURCE=1)
ORDER BY ROUTE_ID,DISTANCE,STOP_ID