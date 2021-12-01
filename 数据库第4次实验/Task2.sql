--1. ���������������Ĵ�ʳ��Ĺ˿���ͼShu-view������Customer��CID��City��
CREATE VIEW Shu_view(CID,CITY)
AS
SELECT Customer.CID,Customer.CITY
FROM [Order],Customer,Food
WHERE Customer.CID=[Order].CID AND Food.FID=[Order].FID AND Food.City IN ('����','�Ĵ�')

--2. ��ѡ����ͼShu-view�ж�����������ߵĹ˿�CID
SELECT TOP 1 CID
FROM
	(
		SELECT CID,SUM(Quantity * Price) as Total
		FROM [Order] JOIN Food ON [Order].FID = Food.FID
		GROUP BY CID
	)AS table1
WHERE CID IN 
	(
		SELECT CID
		FROM Shu_view
	)
ORDER BY Total DESC

--3.����ͼShu-view������16�����ϣ����ܳɹ���Ϊʲô��
--���Գɹ�����Ϊ��ͼ��ֻ�����У�������������Ӧ���Ҳ�û��with check option
INSERT INTO Shu_view
VALUES (16,'����')

--4. �������Թ˿͵���ͼMale-view������Customer��CID��City��,��Ҫ��Ը���ͼ���еĸ��²���ֻ�漰���Թ˿͡���WITH CHECK OPTION����������ͼ�Ŀ������ԣ�
CREATE VIEW Male_view(CID,CITY)
AS
SELECT CID,CITY
FROM Customer
WHERE Gender='��'
WITH CHECK OPTION

--5. ����ͼMale-view������17�����ϣ����ܳɹ���Ϊʲô��
--���ܳɹ���ԭ����û��ָ���Ա�Ϊ�С�������Ŀ����ͼ����Ŀ����ͼ����Խ��ĳһ��ͼָ���� WITH CHECK OPTION�����ò�����һ������������ֲ����� CHECK OPTION Լ����
INSERT INTO Male_view
VALUES (76,'����')