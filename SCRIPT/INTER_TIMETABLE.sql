drop table STARTER_PACK

SELECT distinct a.RNAME,A.DIR,b.IND,b.SNAME,a.PERIOD,a.COND,SINCE, TILL,SEASON INTO STARTER_PACK FROM PRR_INTER_DATA a
join (SELECT a.*, ISNULL(b.POSTRUNTIME,0) PRERUNTIME from 
pre_inter a left join pre_inter b on 
(a.RNAME like b.RNAME and a.DIR like b.DIR and a.IND = b.IND + 1 and a.TIMEPROFILE like b.TIMEPROFILE)
) b on (a.RNAME like b.RNAME and a.DIR like b.DIR)
WHERE IND=1
order by a.RNAME,a.DIR,a.COND,IND,SINCE

WHILE ((SELECT MAX(IND) FROM STARTER_PACK)<(SELECT MAX(IND) FROM PRE_INTER))
BEGIN
INSERT INTO STARTER_PACK
SELECT a.RNAME,A.DIR,c.IND,c.SNAME,a.PERIOD,a.COND,
CASE
WHEN COND like N'��-��' 
THEN CASE
WHEN CAST(SINCE as DATETIME) > CAST('6:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('7:00' as DATETIME) THEN DATEADD(SS,c.B,SINCE)
WHEN CAST(SINCE as DATETIME) > CAST('7:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('9:00' as DATETIME) THEN DATEADD(SS,c.M,SINCE)
WHEN CAST(SINCE as DATETIME) > CAST('9:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('16:00' as DATETIME) THEN DATEADD(SS,c.B,SINCE)
WHEN CAST(SINCE as DATETIME) > CAST('16:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('19:00' as DATETIME) THEN DATEADD(SS,c.E,SINCE)
ELSE DATEADD(SS,c.B,SINCE)
END
ELSE CASE
WHEN CAST(SINCE as DATETIME) > CAST('6:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('12:00' as DATETIME) THEN DATEADD(SS,c.B,SINCE)
WHEN CAST(SINCE as DATETIME) > CAST('12:00' as DATETIME) and CAST(SINCE as DATETIME) <= CAST('16:00' as DATETIME) THEN DATEADD(SS,c.M,SINCE)
ELSE DATEADD(SS,c.B,SINCE)
END
END SINCE,
CASE
WHEN COND like N'��-��' 
THEN CASE
WHEN CAST(TILL as DATETIME) > CAST('6:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('7:00' as DATETIME) THEN DATEADD(SS,c.B,TILL)
WHEN CAST(TILL as DATETIME) > CAST('7:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('9:00' as DATETIME) THEN DATEADD(SS,c.M,TILL)
WHEN CAST(TILL as DATETIME) > CAST('9:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('16:00' as DATETIME) THEN DATEADD(SS,c.B,TILL)
WHEN CAST(TILL as DATETIME) > CAST('16:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('19:00' as DATETIME) THEN DATEADD(SS,c.E,TILL)
ELSE DATEADD(SS,c.B,TILL)
END
ELSE CASE
WHEN CAST(TILL as DATETIME) > CAST('6:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('12:00' as DATETIME) THEN DATEADD(SS,c.B,TILL)
WHEN CAST(TILL as DATETIME) > CAST('12:00' as DATETIME) and CAST(TILL as DATETIME) <= CAST('16:00' as DATETIME) THEN DATEADD(SS,c.M,TILL)
ELSE DATEADD(SS,c.B,TILL)
END
END TILL,
a.SEASON FROM (SELECT * FROM STARTER_PACK WHERE IND like (SELECT MAX(IND) FROM STARTER_PACK)) a 
join 
(
SELECT RNAME,DIR,IND,SNAME,B,M,E FROM
(
SELECT a.RNAME,a.DIR,a.IND,a.SNAME,a.TIMEPROFILE, ISNULL(b.POSTRUNTIME+B.STOPTIME,0) PRERUNTIME from 
pre_inter a left join pre_inter b on 
(a.RNAME like b.RNAME and a.DIR like b.DIR and a.IND = b.IND + 1 and a.TIMEPROFILE like b.TIMEPROFILE)
) x
PIVOT
(
AVG(PRERUNTIME)
for TIMEPROFILE in ([B],[M],[E])
) y
) c on (a.RNAME like c.RNAME and a.DIR like c.DIR and a.IND=c.IND-1 )
order by a.RNAME,a.DIR,a.COND,IND,SINCE
END

--DELETE FROM STARTER_PACK WHERE SNAME IS NULL
SELECT RNAME,DIR,IND,COND,SEASON,SNAME,REGNO,INTER,PERIOD_F,PERIOD_B,SINCE_F,SINCE_B,TILL_F,TILL_B FROM (
SELECT distinct x.RNAME,x.DIR,x.IND,COND,SEASON,x.SNAME,ISNULL(REPLACE(STR(CODE),' ',''),'-') REGNO,
CASE 
WHEN ISNULL(SINCE_F,SINCE_B)<=ISNULL(SINCE_B,SINCE_F) AND ISNULL(TILL_F,TILL_B)>=ISNULL(TILL_B,TILL_F) THEN CONCAT(SUBSTRING(CONCAT(CAST(dbo.FLOORTIME(ISNULL(SINCE_F,SINCE_B),5) AS TIME),''),1,5),' - ',SUBSTRING(CONCAT(CAST(dbo.CEILINGTIME(ISNULL(TILL_F,TILL_B),5) AS TIME),''),1,5))
WHEN ISNULL(SINCE_F,SINCE_B)>=ISNULL(SINCE_B,SINCE_F) AND ISNULL(TILL_F,TILL_B)>=ISNULL(TILL_B,TILL_F) THEN CONCAT(SUBSTRING(CONCAT(CAST(dbo.FLOORTIME(ISNULL(SINCE_B,SINCE_F),5) AS TIME),''),1,5),' - ',SUBSTRING(CONCAT(CAST(dbo.CEILINGTIME(ISNULL(TILL_F,TILL_B),5) AS TIME),''),1,5))
WHEN ISNULL(SINCE_F,SINCE_B)<=ISNULL(SINCE_B,SINCE_F) AND ISNULL(TILL_F,TILL_B)<=ISNULL(TILL_B,TILL_F) THEN CONCAT(SUBSTRING(CONCAT(CAST(dbo.FLOORTIME(ISNULL(SINCE_F,SINCE_B),5) AS TIME),''),1,5),' - ',SUBSTRING(CONCAT(CAST(dbo.CEILINGTIME(ISNULL(TILL_B,TILL_F),5) AS TIME),''),1,5))
WHEN ISNULL(SINCE_F,SINCE_B)>=ISNULL(SINCE_B,SINCE_F) AND ISNULL(TILL_F,TILL_B)<=ISNULL(TILL_B,TILL_F) THEN CONCAT(SUBSTRING(CONCAT(CAST(dbo.FLOORTIME(ISNULL(SINCE_B,SINCE_F),5) AS TIME),''),1,5),' - ',SUBSTRING(CONCAT(CAST(dbo.CEILINGTIME(ISNULL(TILL_B,TILL_F),5) AS TIME),''),1,5))
END INTER,
CONCAT(PERIOD_F,'') PERIOD_F, CONCAT(PERIOD_B,'') PERIOD_B,
SUBSTRING(CONCAT(DATEADD(MI,CASE WHEN DATEPART(SS,SINCE_F)<30 THEN 0 ELSE 1 END,SINCE_F),''),1,5) SINCE_F,
SUBSTRING(CONCAT(DATEADD(MI,CASE WHEN DATEPART(SS,SINCE_B)<30 THEN 0 ELSE 1 END,SINCE_B),''),1,5) SINCE_B,
SUBSTRING(CONCAT(DATEADD(MI,CASE WHEN DATEPART(SS,TILL_F)<30 THEN 0 ELSE 1 END,TILL_F),''),1,5) TILL_F,
SUBSTRING(CONCAT(DATEADD(MI,CASE WHEN DATEPART(SS,TILL_B)<30 THEN 0 ELSE 1 END,TILL_B),''),1,5) TILL_B
FROM
(
SELECT RNAME,COND,SEASON,DIR,IND,SNAME,'-' REGNO,
CASE WHEN DIR like '>' THEN PERIOD ELSE NULL END PERIOD_F,
CASE WHEN DIR like '<' THEN PERIOD ELSE NULL END PERIOD_B,
CASE WHEN DIR like '>' THEN SINCE ELSE NULL END SINCE_F,
CASE WHEN DIR like '<' THEN SINCE ELSE NULL END SINCE_B,
CASE WHEN DIR like '>' THEN TILL ELSE NULL END TILL_F,
CASE WHEN DIR like '<' THEN TILL ELSE NULL END TILL_B 
FROM STARTER_PACK 
WHERE SNAME is not NULL
)
x
join
CITY_CODES y
on (x.RNAME like y.RNAME and x.DIR like y.DIR and x.IND like y.IND)
) x
ORDER BY RNAME,IND,DIR,COND,SINCE_F,SINCE_B


SELECT * FROM CITY_CODES WHERE CODE is NULL