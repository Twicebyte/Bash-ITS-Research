--select sum(ACTIVEDAYS*(M+N+E+G)) from julyAim



--select SUM(CAST(AMOUNT AS INT)) from ULTIMATE_RISE_TRANSACT 
--WHERE
--(dmon = 7 and DDAY in (17,18,19,20,21))

select SUM(AMOUNT) initial from ULTIMATE_DS_TRANSACT 

select SUM(AMOUNT) joinedRoutes from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b on (a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE)

select SUM(AMOUNT) joinedStops from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b on 
(a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE)
join ULTIMATE_STOPS c on (a.IdDataSource=c.SOURCE_REGION and a.BSTOP=c.SOURCE_CODE)
join ULTIMATE_STOPS d on (a.IdDataSource=d.SOURCE_REGION and a.ESTOP=d.SOURCE_CODE)

select SUM(AMOUNT) FROM (
select ROW_NUMBER() OVER (PARTITION BY b.ID,cR.Group_Number,dR.Group_Number,ddate ORDER BY cR.Stop_Name,dR.Stop_Name) rang,AMOUNT from ULTIMATE_DS_TRANSACT a join ULTIMATE_ROUTES b on 
(a.IdDataSource=b.SOURCE_REGION and a.IdRoute=b.SOURCE_CODE)
join ULTIMATE_STOPS c on (a.IdDataSource=c.SOURCE_REGION and a.BSTOP=c.SOURCE_CODE)
join ULTIMATE_STOPS d on (a.IdDataSource=d.SOURCE_REGION and a.ESTOP=d.SOURCE_CODE)
join ULTIMATE_STOPS cR on (cR.GROUP_NUMBER=c.GROUP_NUMBER and cR.SOURCE=1)
join ULTIMATE_STOPS dR on (dR.GROUP_NUMBER=d.GROUP_NUMBER and dR.SOURCE=1)
) x where rang = 1