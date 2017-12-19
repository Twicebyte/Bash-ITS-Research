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

SELECT ROUTE_NAME,ISNULL([INNER],0) [INNER],ISNULL([INTER],0) [INTER],ISNULL([OUTER],0) [OUTER] FROM (
select ROUTE_NAME, Class, sum(Amount) Amount from
(select y.Route_NAME,
CASE 
      WHEN (b.CITY_NUMBER like N'Уфа' AND c.CITY_NUMBER like N'Уфа') 
	  or (b.STOP_NAME like N'Город' and c.STOP_NAME like N'По городу%')
	  or (c.STOP_NAME like N'Город' and b.STOP_NAME like N'По городу%') THEN N'INNER' 
      WHEN b.CITY_NUMBER not like N'Уфа' AND c.CITY_NUMBER not like N'Уфа' THEN N'OUTER' 
      ELSE N'INTER'
END Class, Amount from ULTIMATE_DS_TRANSACT a
join ULTIMATE_ROUTES x on (a.IdDataSource=x.SOURCE_REGION and a.IdRoute=x.SOURCE_CODE and x.ROUTE_NAME like N'%Уфа%')
join (SELECT GROUP_NUMBER,ROUTE_NAME FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY GROUP_NUMBER ORDER BY LEN(ROUTE_NAME) ASC) rang,
GROUP_NUMBER,ROUTE_NAME FROM ULTIMATE_ROUTES where SOURCE=1)x where rang=1) y on (x.GROUP_NUMBER=y.GROUP_NUMBER)
join ULTIMATE_STOPS b on (a.IdDataSource=b.SOURCE_REGION and a.BSTOP=b.SOURCE_CODE)
join ULTIMATE_STOPS c on (a.IdDataSource=c.SOURCE_REGION and a.ESTOP=c.SOURCE_CODE)
union ALL
select y.Route_NAME,
CASE 
      WHEN (b.CITY_NUMBER like N'Уфа' AND c.CITY_NUMBER like N'Уфа') THEN N'INNER' 
      WHEN b.CITY_NUMBER not like N'Уфа' AND c.CITY_NUMBER not like N'Уфа' THEN N'OUTER' 
      ELSE 'INTER'
END Class, Amount from ULTIMATE_RISE_TRANSACT a
join ULTIMATE_ROUTES x on (a.ROUTE_ID=x.ID and x.ROUTE_NAME like N'%Уфа%')
join (SELECT GROUP_NUMBER,ROUTE_NAME FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY GROUP_NUMBER ORDER BY LEN(ROUTE_NAME) ASC) rang,
GROUP_NUMBER,ROUTE_NAME FROM ULTIMATE_ROUTES where SOURCE=1)x where rang=1) y on (x.GROUP_NUMBER=y.GROUP_NUMBER)
join (select distinct group_number, city_number from ULTIMATE_STOPS) b on (a.BGN=b.GROUP_NUMBER)
join (select distinct group_number, city_number from ULTIMATE_STOPS) c on (a.EGN=c.GROUP_NUMBER)) x
group by ROUTE_NAME,Class
) x
PIVOT
(
SUM(AMOUNT)
for CLASS in ([INNER],[INTER],[OUTER])
) y
