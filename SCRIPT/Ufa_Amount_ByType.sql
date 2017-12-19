SELECT ROUTE_NAME,ISNULL([INNER],0) [INNER],ISNULL([INTER],0) [INTER],ISNULL([OUTER],0) [OUTER] FROM (
select ROUTE_NAME, Class, sum(Amount) Amount from
(select y.Route_NAME,
CASE 
      WHEN (b.CITY_NUMBER like N'���' AND c.CITY_NUMBER like N'���') 
	  or (b.STOP_NAME like N'�����' and c.STOP_NAME like N'�� ������%')
	  or (c.STOP_NAME like N'�����' and b.STOP_NAME like N'�� ������%') THEN N'INNER' 
      WHEN b.CITY_NUMBER not like N'���' AND c.CITY_NUMBER not like N'���' THEN N'OUTER' 
      ELSE N'INTER'
END Class, Amount from ULTIMATE_DS_TRANSACT a
join ULTIMATE_ROUTES x on (a.IdDataSource=x.SOURCE_REGION and a.IdRoute=x.SOURCE_CODE and x.ROUTE_NAME like N'%���%')
join (SELECT GROUP_NUMBER,ROUTE_NAME FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY GROUP_NUMBER ORDER BY LEN(ROUTE_NAME) ASC) rang,
GROUP_NUMBER,ROUTE_NAME FROM ULTIMATE_ROUTES where SOURCE=1)x where rang=1) y on (x.GROUP_NUMBER=y.GROUP_NUMBER)
join ULTIMATE_STOPS b on (a.IdDataSource=b.SOURCE_REGION and a.BSTOP=b.SOURCE_CODE)
join ULTIMATE_STOPS c on (a.IdDataSource=c.SOURCE_REGION and a.ESTOP=c.SOURCE_CODE)
union ALL
select y.Route_NAME,
CASE 
      WHEN (b.CITY_NUMBER like N'���' AND c.CITY_NUMBER like N'���') THEN N'INNER' 
      WHEN b.CITY_NUMBER not like N'���' AND c.CITY_NUMBER not like N'���' THEN N'OUTER' 
      ELSE 'INTER'
END Class, Amount from ULTIMATE_RISE_TRANSACT a
join ULTIMATE_ROUTES x on (a.ROUTE_ID=x.ID and x.ROUTE_NAME like N'%���%')
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