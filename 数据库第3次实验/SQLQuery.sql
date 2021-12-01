--1. 选出3号顾客买过的小于50元的食物的数量
SELECT Quantity
FROM (
	select FID, Quantity 
	from [Order]
	where [Order].CID=3
) AS table1 inner join food on table1.FID=food.FID 
where Price<50

--2. 选出消费额之和最大的顾客ID
SELECT CID
FROM
(
	SELECT CID,sum(sell) as sumsell
	FROM 
	(
		SELECT CID,QUANTITY*PRICE as sell
		from [Order] inner join food on [Order].FID=Food.FID
	)as table1
	GROUP BY CID
)as table2
WHERE sumsell =
(
	SELECT MAX(sumsell)
	FROM
	(
		SELECT CID,sum(sell) as sumsell
		from
		(
			SELECT CID,[order].QUANTITY*food.PRICE as sell
			from [Order] inner join food on [Order].FID=Food.FID	
		)as table1
		GROUP BY CID
	)as table2
)

--3. 选出销售额之和最大的城市名City
SELECT CITY
FROM
(
	SELECT CITY,sum(sell) as sumsell
	FROM 
	(
		SELECT CITY,QUANTITY*PRICE as sell
		from [Order] inner join food on [Order].FID=Food.FID
	) as table1
	GROUP BY CITY
)as table2
WHERE sumsell =
(
	SELECT MAX(sumsell)
	FROM
	(
		SELECT sum(sell) as sumsell
		from
		(
			SELECT CITY,[order].QUANTITY*food.PRICE as sell
			from [Order] inner join food on [Order].FID=Food.FID	
		)as table1
		GROUP BY CITY
	)as table2
)

--4. 选出个人平均消费额超过北京地区"订单平均消费"的女性顾客的ID
SELECT CID
FROM
(
	SELECT table2.CID,Gender,Ordersum/Ordercount as average
	FROM
	(
		SELECT CID,COUNT(oid) as Ordercount,SUM(singlesell) as Ordersum
		FROM
		(
			SELECT CID,oid, Price*Quantity as singlesell
			FROM Food inner join [Order] on Food.FID = [Order].FID
		) as table1
		GROUP BY CID
	) as table2 inner join Customer on Customer.CID = table2.CID
)as table3
WHERE Gender='女'  and average >(
	SELECT average																					
	FROM
	(
		SELECT City,Ordersum/Ordercount as average
		FROM
		(
			SELECT Customer.City,COUNT(oid) as Ordercount,SUM(singlesell) as Ordersum
			FROM
			(
				SELECT CID,CITY,oid, Price*Quantity as singlesell
				FROM Food inner join [Order] on Food.FID = [Order].FID
			)as table4 inner join Customer on table4.CID=Customer.CID
			GROUP BY Customer.City
		)as table5
	) as table6
	WHERE City='北京'
)

--5. 选出个人总消费额不超过北京地区“人均总消费"的男性顾客的ID
SELECT Customer.CID
FROM
(
	SELECT Customer.CID,sum(sell) as sumsell
	FROM 
	(
		SELECT CID,QUANTITY*PRICE as sell
		from [Order] inner join food on [Order].FID=Food.FID
	)as table1 inner join Customer on Customer.CID= table1.CID
	GROUP BY Customer.CID
)as table2 inner join Customer on Customer.CID= table2.CID
WHERE Gender='男'  and sumsell <=(
	SELECT Sumtotal/peoplecount as average
	FROM
		(
		SELECT Customer.City,COUNT(Customer.CID) as peoplecount, SUM(personOrdersum) as Sumtotal
		FROM(
			SELECT Customer.CID,SUM(singlesell) as personOrdersum
			FROM
			(
				SELECT CID, Price*Quantity as singlesell
				FROM Food inner join [Order] on Food.FID = [Order].FID
			)as table3 inner join Customer on table3.CID=Customer.CID
			GROUP BY Customer.CID
			)as table4 inner join Customer on table4.CID=Customer.CID
		GROUP BY Customer.City
		)as table5
	WHERE City='北京'
)

--6. 选出消费能力最高（消费额之和最大）的顾客们来自的城市名CIty
SELECT Customer.city
FROM
(
	SELECT Customer.CID,sumsell
	FROM
	(
		SELECT CID,sum(sell) as sumsell
		FROM 
		( 
			SELECT CID,QUANTITY*PRICE as sell
			from [Order] inner join food on [Order].FID=Food.FID
		)as table1
		GROUP BY CID
	)as table2 inner join Customer on table2.CID=Customer.CID
)as table3 inner join Customer on table3.CID=Customer.CID
WHERE sumsell =
(
	SELECT MAX(sumsell)
	FROM
	(
		SELECT CID,sum(sell) as sumsell
		from
		(
			SELECT CID,[order].QUANTITY*food.PRICE as sell
			from [Order] inner join food on [Order].FID=Food.FID	
		)as table1
		GROUP BY CID
	)as table2
)

--7. 选出男性的每次订单的平均消费额
SELECT SUM(singlesell)/COUNT(oid) as average
FROM
(
SELECT oid,singlesell
FROM
(
	SELECT CID,oid,singlesell
	FROM
	(
		SELECT cid,oid,Price*Quantity as singlesell
		FROM Food inner join [Order] on Food.FID = [Order].FID
	) as table1 
)as table2 inner join Customer on table2.CID=Customer.CID
WHERE gender='男'
)as table3

--8. 选出所有订单消费额大于50的订单ID
SELECT OID
FROM 
(
	SELECT OID, Quantity*Price as sell
	FROM [Order] inner join Food on [Order].FID=Food.FID
)as table1
WHERE sell>50

--9. 选出购买过“药水”类产品的顾客ID
SELECT CID
FROM Food inner join [Order] on Food.FID=[Order].FID
WHERE [Name] like '%药水%'

--10. 选出既买过水晶都的食物，又买过游末邦的食物的顾客ID
SELECT DISTINCT CID
FROM
(
	SELECT table1.CID,FID
	FROM
	(
		SELECT CID
		FROM [Order] inner join Food on Food.FID=[Order].FID
		WHERE City='水晶都'
	)as table1 inner join [Order] on [Order].CID=table1.CID
)as table2 inner join Food on Food.FID=table2.FID
WHERE City='游末邦'

--11. 选出买过重庆或者四川两地的食物的顾客ID
SELECT DISTINCT CID
FROM [Order] inner join Food on Food.FID=[Order].FID
WHERE City in('重庆','四川')

--12. 选出只买过来自于重庆和四川两地的食物的顾客ID
SELECT DISTINCT CID
FROM [Order] inner join Food on Food.FID=[Order].FID
WHERE City in ('重庆','四川') and CID not in
(
	SELECT DISTINCT CID
	FROM [Order] inner join Food on Food.FID=[Order].FID
	WHERE City not in('重庆','四川')
)

--13. 选出没有购买记录的顾客ID
SELECT CID
FROM Customer
WHERE CID not in
(
	SELECT CID
	FROM [Order]
)

--14. 选出TOP3消费量（订单金额之和）最大的食物ID
SELECT TOP 3 FID
FROM
(
	SELECT FID,SUM(sell) as sumsell
	FROM
	(
		SELECT Food.FID,Quantity*Price as sell
		FROM Food inner join [Order] on Food.FID=[Order].FID
	)as table1
	GROUP BY FID
)as table2
Order by sumsell desc