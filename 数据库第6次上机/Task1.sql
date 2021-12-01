--1. 模仿PPT中的建表插值过程（id INT, val INT）（数据量大约10,000即可）。
CREATE TABLE TEST(
	id INT,
	val INT
);
GO
BEGIN
	DECLARE @i INT;
	SET @i = 16210000;
	WHILE @i <16220000
		BEGIN 
			INSERT INTO TEST VALUES(@i,FLOOR(RAND()*100));
			SET @i=@i+1;
		END
END
GO
--2. 建立id升序同时val降序的非聚类索引。
CREATE UNIQUE INDEX idx_tset_id ON TEST(id ASC,val DESC);
--3. 分别至少写两个命中和不命中这个索引（“这个索引”均指第2题的索引）的查询。
--命中的查询
--1
SELECT id
FROM TEST
WHERE id < 16215000
ORDER BY ID
--2
SELECT val
FROM TEST
WHERE id >16210000
ORDER BY ID
--不命中的查询
--1
SELECT val
FROM TEST
WHERE val = 50
ORDER BY val
--2
SELECT val
FROM TEST
WHERE id>val
ORDER BY val
GO
--4涉及主索引属性（id）与数值的直接大小比较的查询语句可以命中索引
--5. 建立触发器，插入数据后，若val值为完全平方数（1,4,9...）时打印“Good”，自拟测试数据检测触发器是否生效。
CREATE TRIGGER checkval
	ON TEST
	FOR INSERT
	AS
		DECLARE @val INT,@floor INT,@ceiling INT
		SELECT @val=val FROM INSERTED
		SET @floor=FLOOR(SQRT(@val))
		SET @ceiling=CEILING(SQRT(@val))
		IF(@floor=@ceiling)
			PRINT 'good'
			--PRINT @val
GO

INSERT INTO TEST VALUES(1,121);
INSERT INTO TEST VALUES(2,100);
INSERT INTO TEST VALUES(3,99);
INSERT INTO TEST VALUES(4,25);
INSERT INTO TEST VALUES(5,77);
BEGIN
	DECLARE @i INT;
	SET @i = 1;
	WHILE @i <10
		BEGIN 
			INSERT INTO TEST VALUES(@i,FLOOR(RAND()*200));
			SET @i=@i+1;
		END
END