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

select * from ULTIMATE_RBS 
where ROUTE_ID in (200004,200005,200006,200007,200008,200009)

select * from ultimate_rbs where ROUTE_ID=1203
select * from ULTIMATE_STOPS where ID in (4437,13096,13263,13264)
--update  ULTIMATE_STOPS set GROUP_NUMBER = 4437 where GROUP_NUMBER in (4437,13096)


--select * from VisumDistances where Name like N'%Уфа%Салават%'
--select x.ID ROUTE_ID, x.ROUTE_NAME, a.[Index] STOP_INDEX, a.StopName STOP_NAME, b.ID STOP_ID, c.AllDist
--from ReestrAsVisumByStop a 
--join ULTIMATE_ROUTES x on (x.ID=200054)
--join ULTIMATE_STOPS b on (a.StopId=b.SOURCE_CODE and b.SOURCE=1) 
--left join VisumDistances c on (a.StopId=c.StopId and c.Name like N'%Уфа%Салават%')
--where a.Name like N'Уфа - Салават через Ишимбай'
--order by x.ID,a.[Index],b.ID
select * from ULTIMATE_ROUTES where GROUP_NUMBER = 54
--insert into ULTIMATE_ROUTES VALUES (200054,54,1,NULL,NULL,N'Уфа - Салават через Ишимбай',N'551И',193)

--delete from ULTIMATE_RBS where STOP_ID in (Select STOP_ID from ULTIMATE_ROUTES x join ULTIMATE_RBS a on (x.ID=a.ROUTE_ID and x.SOURCE=1)
--left join ULTIMATE_STOPS b on (a.STOP_ID=b.ID) where b.ID is NULL) and
--ROUTE_ID in (Select ID from ULTIMATE_ROUTES where SOURCE=1)