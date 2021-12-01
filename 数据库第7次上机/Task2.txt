--1.注册（注册时密码必须含有数字和字母，长度大于等于4；用户名冲突时不能注册 ）
CREATE FUNCTION check_pwd(
@pwd varchar(50)
)RETURNS INT AS
BEGIN
	DECLARE @result AS INT
	IF (@pwd LIKE'%[a-zA-Z]%' AND @pwd LIKE '%[0-9]%' AND LEN(@pwd)>=4)
		SET @result = 1
	ELSE 
		SET @result = 0
	RETURN @result
END
GO
CREATE OR ALTER PROCEDURE Register(@username varchar(50),@pwd varchar(50))
AS
	BEGIN
		IF EXISTS(SELECT * FROM ACCOUNT WHERE Username=@username)
			PRINT 'This username has been taken'
		ELSE 
		BEGIN
			IF (dbo.check_pwd(@pwd)=0)
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
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE Username=@username )
			PRINT 'User not found'
		ELSE 
		BEGIN
			IF @pwd!=(SELECT psw FROM ACCOUNT WHERE Username=@username)
				PRINT 'Password incorrect'
			ELSE
				PRINT 'Login success'
		END
	END
GO
EXECUTE Log_in 'jia','123a'
EXECUTE Log_in '甲','123b'
EXECUTE Log_in '甲','123a'
GO;
--3.修改密码（也需要满足注册时的密码要求）
CREATE OR ALTER PROCEDURE Change_pwd(@username varchar(50),@pwd varchar(50),@newpwd varchar(50))
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE Username=@username )
			PRINT 'User not found'
		ELSE
		BEGIN
				IF @pwd!=(SELECT psw FROM ACCOUNT WHERE Username=@username)
				PRINT 'Password incorrect'
			ELSE
			BEGIN
				If (dbo.check_pwd(@newpwd)=0)
					PRINT 'newassword illegal'
				ELSE 
				BEGIN
					UPDATE ACCOUNT
					SET psw=@newpwd
					WHERE Username=@Username
					PRINT 'Change password success'
				END
			END
		END
	END
GO
EXECUTE Change_pwd 'jia','aaaa','aaaa'
EXECUTE Change_pwd '甲','aaaa','aaaa'
EXECUTE Change_pwd '甲','123a','aaaa'
EXECUTE Change_pwd '甲','123a','1234a'

--4.借书（需要考虑没有足够的书或者用户不存在等特殊情况，规定一个人不能同时借两本同样的书）
CREATE OR ALTER PROCEDURE Borrow_book(@username varchar(50),@Bookname varchar(50))
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE Username=@username )
			PRINT 'User not found'
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT * FROM BOOKS WHERE @Bookname=Bookname )
				PRINT  'Book not found'
			ELSE
			BEGIN
				IF ((SELECT Bookcount FROM BOOKS WHERE @Bookname=Bookname)<1)
					PRINT 'Book out of store'
				ELSE 
				BEGIN
					IF EXISTS(SELECT * FROM RECORD WHERE @Bookname=Bookname AND Username=@username)
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

--还书（同样需要考虑参数不合法情况） 
CREATE OR ALTER PROCEDURE Return_book(@username varchar(50),@Bookname varchar(50))
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE Username=@username )
			PRINT 'User not found'
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT * FROM BOOKS WHERE @Bookname=Bookname )
				PRINT  'Book not found'
			ELSE
			BEGIN
				IF NOT EXISTS(SELECT * FROM RECORD WHERE @Bookname=Bookname AND Username=@username)
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

--6.查看当前借阅记录(用户名, 书名, 到期时间)
CREATE OR ALTER PROCEDURE check_record(@mode INT=0,@username varchar(50)='NULL')
AS
	BEGIN
		IF(@mode=0)--模式0代表查看全部
			SELECT Username AS 用户名,Bookname AS 书名,Duetime AS 到期时间 FROM RECORD
		ELSE--模式1代表查看指定用户
		BEGIN
			IF NOT EXISTS(SELECT * FROM RECORD WHERE Username=@username )
				PRINT 'User did not borrow books'
			ELSE
				SELECT Username AS 用户名,Bookname AS 书名,Duetime AS 到期时间 FROM RECORD WHERE Username=@username
		END
	END
GO
EXECUTE Borrow_book '甲','第三本书'
EXECUTE Borrow_book '乙','第三本书'
EXECUTE Borrow_book '甲','第二本书'
EXECUTE Borrow_book '丁','第四本书'
EXECUTE check_record
EXECUTE check_record 0
EXECUTE check_record 1,'丙'
EXECUTE check_record 1,'甲'

--7.查看当前超期借阅记录(用户名, 书名, 超期了多久)
CREATE OR ALTER PROCEDURE check_overdue(@mode INT=0,@username varchar(50)='NULL')
AS
	BEGIN
		IF(@mode=0)--模式0代表查看全部
			SELECT Username AS 用户名,Bookname AS 书名,DATEDIFF(dd,Duetime,getdate())AS 超期天数 FROM RECORD WHERE Duetime<getdate()
		ELSE--模式1代表查看指定用户
		BEGIN
			IF NOT EXISTS(SELECT * FROM RECORD WHERE Username=@username )
				PRINT 'User did not borrow books'
			ELSE
				SELECT Username AS 用户名,Bookname AS 书名,DATEDIFF(dd,Duetime,getdate())AS 超期天数 FROM RECORD WHERE Duetime<getdate() AND Username=@username
		END
	END
GO
insert into RECORD (Username,Bookname,Loantime)
	values('甲','第一本书','2010-12-12'),('乙','第二本书','2019-12-12');
GO
EXECUTE check_overdue
EXECUTE check_overdue 0
EXECUTE check_overdue 1,'丙'
EXECUTE check_overdue 1,'甲'