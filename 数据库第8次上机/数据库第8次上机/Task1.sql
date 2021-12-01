--1. 注册（注册时密码必须含有数字和字母，长度大于等于4；用户名冲突时不能注册 ）
CREATE OR ALTER PROCEDURE Register(@username varchar(50),@pwd varchar(50))
AS
	BEGIN
		DECLARE curAccount CURSOR
			FAST_FORWARD
		FOR 
			SELECT * FROM ACCOUNT
		DECLARE @flag INT
		SET @flag = 1
		DECLARE @u AS VARCHAR(50)
		DECLARE @p AS VARCHAR(50)
		OPEN curAccount
		FETCH FROM curAccount INTO @u,@p
		WHILE @@FETCH_STATUS=0
		BEGIN
				IF(@u=@username)
				BEGIN
					SET @flag=0
					BREAK
				END
				FETCH FROM curAccount INTO @u,@p
		END
		CLOSE curAccount
		DEALLOCATE curAccount
		IF (@flag=0)
			PRINT 'This username has been taken'
		ELSE 
		BEGIN
			IF NOT (@pwd LIKE'%[a-zA-Z]%' AND @pwd LIKE '%[0-9]%' AND LEN(@pwd)>=4)
				PRINT 'Password illegal'
			ELSE
				BEGIN
					INSERT INTO ACCOUNT(Username,psw) VALUES(@username,@pwd)
					PRINT 'Register success'
				END
		END
	END
GO
EXECUTE Register '甲','23a'
EXECUTE Register '甲','123a'
EXECUTE Register '乙','1234'
EXECUTE Register '乙','1234a'
EXECUTE Register '丙','1234a'
EXECUTE Register '丙','123a4'
EXECUTE Register '丁','1234a'
--2.登录
CREATE OR ALTER PROCEDURE Log_in(@username varchar(50),@pwd varchar(50))
AS
	BEGIN
		DECLARE curAccount CURSOR
			FAST_FORWARD
		FOR 
			SELECT * FROM ACCOUNT
		DECLARE @flag INT
		DECLARE @pwdflag INT
		SET @flag = 0
		SET @pwdflag = 0
		DECLARE @u AS VARCHAR(50)
		DECLARE @p AS VARCHAR(50)
		OPEN curAccount
		FETCH FROM curAccount INTO @u,@p
		WHILE @@FETCH_STATUS=0
		BEGIN
				IF(@u=@username)
				BEGIN
					SET @flag=1
					IF(@p=@pwd)
						SET @pwdflag=1
					BREAK
				END
				FETCH FROM curAccount INTO @u,@p
		END
		CLOSE curAccount
		DEALLOCATE curAccount
		IF (@flag=0)
			PRINT 'User not found'
		ELSE 
		BEGIN
			IF (@pwdflag=0)
				PRINT 'Password incorrect'
			ELSE
				PRINT 'Login success'
		END
	END
GO
EXECUTE Log_in 'jia','123a'
EXECUTE Log_in '甲','123b'
EXECUTE Log_in '甲','123a'

--3.借书（需要考虑没有足够的书或者用户不存在等特殊情况，规定一个人不能同时借两本同样的书）
CREATE OR ALTER PROCEDURE Borrow_book(@username varchar(50),@Bookname varchar(50))
AS
	BEGIN
		DECLARE curAccount CURSOR
			FAST_FORWARD
		FOR 
			SELECT * FROM ACCOUNT
		DECLARE @flag INT
		SET @flag = 0
		DECLARE @u AS VARCHAR(50)
		DECLARE @p AS VARCHAR(50)
		OPEN curAccount
		FETCH FROM curAccount INTO @u,@p
		WHILE @@FETCH_STATUS=0
		BEGIN
				IF(@u=@username)
				BEGIN
					SET @flag=1
					BREAK
				END
				FETCH FROM curAccount INTO @u,@p
		END
		CLOSE curAccount
		DEALLOCATE curAccount
		IF (@flag=0)
			PRINT 'User not found'
		ELSE
		BEGIN
			DECLARE curBook CURSOR
				FAST_FORWARD
			FOR 
				SELECT * FROM BOOKS
			DECLARE @bookflag INT
			DECLARE @countflag INT
			SET @bookflag = 0
			SET @countflag = 1
			DECLARE @b AS VARCHAR(50)
			DECLARE @c AS VARCHAR(50)
			OPEN curBook
			FETCH FROM curBook INTO @b,@c
			WHILE @@FETCH_STATUS=0
			BEGIN
					IF(@b=@Bookname)
					BEGIN
						SET @bookflag=1
						IF (@c<1)
							SET @countflag = 0
						BREAK
					END
					FETCH FROM curBook INTO @b,@c
			END
			CLOSE curBook
			DEALLOCATE curBook
			IF (@bookflag=0)
				PRINT  'Book not found'
			ELSE
			BEGIN
				IF (@countflag=0)
					PRINT 'Book out of store'
				ELSE 
				BEGIN
					DECLARE curRecord CURSOR
					FAST_FORWARD
					FOR 
						SELECT * FROM RECORD
					DECLARE @recordflag INT
					SET @recordflag = 1
					DECLARE @un AS VARCHAR(50)
					DECLARE @bn AS VARCHAR(50)
					DECLARE @lt AS DATE
					DECLARE @dt AS DATE
					OPEN curRecord
					FETCH FROM curRecord INTO @un,@bn,@lt,@dt
					WHILE @@FETCH_STATUS=0
					BEGIN
						IF(@bn=@Bookname AND @un=@username)
						BEGIN
							SET @recordflag=0
							BREAK
						END
						FETCH FROM curRecord INTO @un,@bn,@lt,@dt
					END
					CLOSE curRecord 
					DEALLOCATE curRecord 
					IF (@recordflag=0)
						PRINT 'User has already borrowed that book'
					ELSE
					BEGIN
						INSERT INTO RECORD(Username,Bookname)
						VALUES(@username,@Bookname)
						UPDATE BOOKS
						SET Bookcount=Bookcount-1
						WHERE Bookname=@Bookname
						PRINT 'Borrow book success'
					END
				END
			END
		END
	END
GO
insert into BOOKS (Bookname,Bookcount)
	values('第一本书',0),('第二本书',5),('第三本书',5),('第四本书',1),('第五本书',5),('第六本书',2);
GO
EXECUTE Borrow_book 'jia','aa'
EXECUTE Borrow_book '甲','aa'
EXECUTE Borrow_book '甲','第一本书'
EXECUTE Borrow_book '甲','第三本书'
EXECUTE Borrow_book '甲','第三本书'

--4.还书（同样需要考虑参数不合法情况） 
CREATE OR ALTER PROCEDURE Return_book(@username varchar(50),@Bookname varchar(50))
AS
	BEGIN
		DECLARE curAccount CURSOR
			FAST_FORWARD
		FOR 
			SELECT * FROM ACCOUNT
		DECLARE @flag INT
		SET @flag = 0
		DECLARE @u AS VARCHAR(50)
		DECLARE @p AS VARCHAR(50)
		OPEN curAccount
		FETCH FROM curAccount INTO @u,@p
		WHILE @@FETCH_STATUS=0
		BEGIN
				IF(@u=@username)
				BEGIN
					SET @flag=1
					BREAK
				END
				FETCH FROM curAccount INTO @u,@p
		END
		CLOSE curAccount
		DEALLOCATE curAccount
		IF (@flag=0)
			PRINT 'User not found'
		ELSE
		BEGIN
			DECLARE curBook CURSOR
				FAST_FORWARD
			FOR 
				SELECT * FROM BOOKS
			DECLARE @bookflag INT
			DECLARE @countflag INT
			SET @bookflag = 0
			SET @countflag = 1
			DECLARE @b AS VARCHAR(50)
			DECLARE @c AS VARCHAR(50)
			OPEN curBook
			FETCH FROM curBook INTO @b,@c
			WHILE @@FETCH_STATUS=0
			BEGIN
					IF(@b=@Bookname)
					BEGIN
						SET @bookflag=1
						IF (@c<1)
							SET @countflag = 0
						BREAK
					END
					FETCH FROM curBook INTO @b,@c
			END
			CLOSE curBook
			DEALLOCATE curBook
			IF (@bookflag=0)
				PRINT  'Book not found'
			ELSE
			BEGIN
				DECLARE curRecord CURSOR
				FAST_FORWARD
				FOR 
					SELECT * FROM RECORD
				DECLARE @recordflag INT
				SET @recordflag = 0
				DECLARE @un AS VARCHAR(50)
				DECLARE @bn AS VARCHAR(50)
				DECLARE @lt AS DATE
				DECLARE @dt AS DATE
				OPEN curRecord
				FETCH FROM curRecord INTO @un,@bn,@lt,@dt
				WHILE @@FETCH_STATUS=0
				BEGIN
					IF(@bn=@Bookname AND @un=@username)
					BEGIN
						SET @recordflag=1
						BREAK
					END
					FETCH FROM curRecord INTO @un,@bn,@lt,@dt
				END
				CLOSE curRecord 
				DEALLOCATE curRecord 
				IF (@recordflag=0)
					PRINT 'User did not borrow that book'
				ELSE
				BEGIN
					DELETE
					FROM RECORD
					WHERE @Bookname=Bookname AND Username=@username
					UPDATE BOOKS
					SET Bookcount=Bookcount+1
					WHERE Bookname=@Bookname
					PRINT 'Return book success'
				END		
			END
		END
	END
GO
EXECUTE Return_book 'jia','aa'
EXECUTE Return_book '甲','aa'
EXECUTE Return_book '甲','第一本书'
EXECUTE Return_book '甲','第三本书'
EXECUTE Return_book '甲','第三本书'