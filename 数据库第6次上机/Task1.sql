--1. ģ��PPT�еĽ����ֵ���̣�id INT, val INT������������Լ10,000���ɣ���
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
--2. ����id����ͬʱval����ķǾ���������
CREATE UNIQUE INDEX idx_tset_id ON TEST(id ASC,val DESC);
--3. �ֱ�����д�������кͲ���������������������������ָ��2����������Ĳ�ѯ��
--���еĲ�ѯ
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
--�����еĲ�ѯ
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
--4�漰���������ԣ�id������ֵ��ֱ�Ӵ�С�ȽϵĲ�ѯ��������������
--5. �������������������ݺ���valֵΪ��ȫƽ������1,4,9...��ʱ��ӡ��Good��������������ݼ�ⴥ�����Ƿ���Ч��
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