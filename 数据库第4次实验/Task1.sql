--1. ��ѯ��CID=1�Ĺ˿�ͬһ�����е����й˿�ID
SELECT CID
FROM Customer
WHERE City=
(
	SELECT City
	FROM Customer
	WHERE CID=1
)
--2. ��ѯ���������ʡ�ݣ�Food���г��ֹ���City����ʳ��Ĺ˿�ID
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

--3. ��ѯ���ٹ����IDΪ13�Ĺ˿������ȫ��ʳ��Ĺ˿�ID
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