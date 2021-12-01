--1. ѡ��3�Ź˿������С��50Ԫ��ʳ�������
SELECT Quantity
FROM (
	select FID, Quantity 
	from [Order]
	where [Order].CID=3
) AS table1 inner join food on table1.FID=food.FID 
where Price<50

--2. ѡ�����Ѷ�֮�����Ĺ˿�ID
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

--3. ѡ�����۶�֮�����ĳ�����City
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

--4. ѡ������ƽ�����Ѷ����������"����ƽ������"��Ů�Թ˿͵�ID
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
WHERE Gender='Ů'  and average >(
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
	WHERE City='����'
)

--5. ѡ�����������Ѷ���������������˾�������"�����Թ˿͵�ID
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
WHERE Gender='��'  and sumsell <=(
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
	WHERE City='����'
)

--6. ѡ������������ߣ����Ѷ�֮����󣩵Ĺ˿������Եĳ�����CIty
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

--7. ѡ�����Ե�ÿ�ζ�����ƽ�����Ѷ�
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
WHERE gender='��'
)as table3

--8. ѡ�����ж������Ѷ����50�Ķ���ID
SELECT OID
FROM 
(
	SELECT OID, Quantity*Price as sell
	FROM [Order] inner join Food on [Order].FID=Food.FID
)as table1
WHERE sell>50

--9. ѡ���������ҩˮ�����Ʒ�Ĺ˿�ID
SELECT CID
FROM Food inner join [Order] on Food.FID=[Order].FID
WHERE [Name] like '%ҩˮ%'

--10. ѡ�������ˮ������ʳ��������ĩ���ʳ��Ĺ˿�ID
SELECT DISTINCT CID
FROM
(
	SELECT table1.CID,FID
	FROM
	(
		SELECT CID
		FROM [Order] inner join Food on Food.FID=[Order].FID
		WHERE City='ˮ����'
	)as table1 inner join [Order] on [Order].CID=table1.CID
)as table2 inner join Food on Food.FID=table2.FID
WHERE City='��ĩ��'

--11. ѡ�������������Ĵ����ص�ʳ��Ĺ˿�ID
SELECT DISTINCT CID
FROM [Order] inner join Food on Food.FID=[Order].FID
WHERE City in('����','�Ĵ�')

--12. ѡ��ֻ���������������Ĵ����ص�ʳ��Ĺ˿�ID
SELECT DISTINCT CID
FROM [Order] inner join Food on Food.FID=[Order].FID
WHERE City in ('����','�Ĵ�') and CID not in
(
	SELECT DISTINCT CID
	FROM [Order] inner join Food on Food.FID=[Order].FID
	WHERE City not in('����','�Ĵ�')
)

--13. ѡ��û�й����¼�Ĺ˿�ID
SELECT CID
FROM Customer
WHERE CID not in
(
	SELECT CID
	FROM [Order]
)

--14. ѡ��TOP3���������������֮�ͣ�����ʳ��ID
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