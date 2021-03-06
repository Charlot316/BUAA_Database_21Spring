--1. 查询与CID=1的顾客同一个城市的所有顾客ID
SELECT CID
FROM Customer
WHERE City=
(
	SELECT City
	FROM Customer
	WHERE CID=1
)
--2. 查询购买过所有省份（Food表中出现过的City）的食物的顾客ID
SELECT CID
FROM 
(	
	SELECT COUNT(DISTINCT City) as citycount,CID
	FROM
	(
			SELECT Food.City,Customer.CID
			FROM [Order],Customer,Food
			WHERE Customer.CID=[Order].CID AND Food.FID=[Order].FID
	)as table1
	GROUP BY CID
)as table2
WHERE citycount=
(
	SELECT COUNT(DISTINCT City)
	FROM Food
)

--3. 查询至少购买过ID为13的顾客买过的全部食物的顾客ID
SELECT DISTINCT CID
FROM [Order] orderx
WHERE NOT EXISTS
(
	SELECT *
	FROM [Order] ordery
	WHERE ordery.CID=13 AND NOT EXISTS
	(
		SELECT *
		FROM [Order] orderz
		WHERE orderz.CID=orderx.CID and orderz.FID=ordery.FID
	)
)