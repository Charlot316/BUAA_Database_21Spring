--1. 写一个批处理，打印3遍消息“This is a test message”
PRINT 'This is a test message'
GO 3

--2. 建一个表Grade(Sno, value)，用循环结构插入100条记录，其中Sno是递增的奇自然数，value是0到100间的随机整数（rand函数）
CREATE TABLE Grade
(
	Sno INT,
	[value] INT
)
DECLARE @sno INT,@value INT
SET @sno=0 
WHILE @sno<100 		
BEGIN 
	SET @value=floor(0 + rand() * (101 - 0)) 
	INSERT INTO Grade
	VALUES(@sno*2+1,@value)
	SET @sno=@sno+1  
END
--3. 写一个查询，展示学生的学号（Sno）和成绩状况。（成绩状况：对于Grade表中value大于80的行显示为’good’，60到80之间的显示’pass’，否则显示’not good’）
SELECT Sno as 学号, 
	CASE 
		WHEN [value]>80 then 'good'
		WHEN [value]>=60 AND [VALUE]<=80 then 'pass'
		WHEN [value]<60 then 'not good'
	END as 成绩状况
FROM Grade
--4.用模拟的方法算PI的值，采样值取5000即可
DECLARE @x FLOAT,@y FLOAT,@count INT, @totalcount INT,@ans FLOAT
SET @totalcount=0 
SET @count=0
WHILE @totalcount<5000		
BEGIN 
	SET @x=rand()
	SET @y=rand()
	IF(@x*@x+@y*@y<=1) SET @count=@count+1
	SET @totalcount=@totalcount+1  
END
SET @ans=4.0*CAST(@count as FLOAT)/CAST(@totalcount as FLOAT)
PRINT @ans