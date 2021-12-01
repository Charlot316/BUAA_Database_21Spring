--1. 建立购买过重庆或四川食物的顾客视图Shu-view（包含Customer中CID，City）
CREATE VIEW Shu_view(CID,CITY)
AS
SELECT Customer.CID,Customer.CITY
FROM [Order],Customer,Food
WHERE Customer.CID=[Order].CID AND Food.FID=[Order].FID AND Food.City IN ('重庆','四川')

--2. 挑选出视图Shu-view中订单总消费最高的顾客CID
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

--3.向视图Shu-view加入表项（16，湖南），能成功吗，为什么？
--可以成功，因为视图中只有两列，正好与插入项对应，且并没有with check option
INSERT INTO Shu_view
VALUES (16,'湖南')

--4. 建立男性顾客的视图Male-view（包含Customer中CID，City）,并要求对该视图进行的更新操作只涉及男性顾客。（WITH CHECK OPTION，并考虑视图的可扩充性）
CREATE VIEW Male_view(CID,CITY)
AS
SELECT CID,CITY
FROM Customer
WHERE Gender='男'
WITH CHECK OPTION

--5. 向视图Male-view加入表项（17，湖南），能成功吗，为什么？
--不能成功，原因是没有指定性别为男。报错是目标视图或者目标视图所跨越的某一视图指定了 WITH CHECK OPTION，而该操作的一个或多个结果行又不符合 CHECK OPTION 约束。
INSERT INTO Male_view
VALUES (76,'湖南')