--新建表
CREATE TABLE Account(
	ID varchar(50)  PRIMARY KEY,
	deposit INT CHECK(deposit>=1),
)
--开户
CREATE OR ALTER PROCEDURE Register(@ID varchar(50),@deposit INT)
AS
	BEGIN
		IF EXISTS(SELECT * FROM ACCOUNT WHERE ID=@ID)
			PRINT 'This username has been taken'
		ELSE 
		BEGIN
			IF (@deposit<1)
				PRINT 'Deposit must be more than 1.'
			ELSE
				BEGIN
					INSERT INTO ACCOUNT(ID,deposit) VALUES(@ID,@deposit)
					PRINT 'Register success'
				END
		END
	END
GO
--存款
CREATE OR ALTER PROCEDURE DEPOSIT(@ID varchar(50),@deposit INT)
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE ID=@ID)
			PRINT 'User not exsist'
		ELSE 
		BEGIN
			IF (@deposit<1)
				PRINT 'Deposit must be more than 1.'
			ELSE
				BEGIN
					UPDATE Account
					SET deposit += @deposit
					WHERE ID =@ID
				END
		END
	END
GO
--取款
CREATE OR ALTER PROCEDURE WITHDRAWAL(@ID varchar(50),@deposit INT)
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM ACCOUNT WHERE ID=@ID)
			PRINT 'User not exsist'
		ELSE 
		BEGIN
			BEGIN
				UPDATE Account
				SET deposit -= @deposit
				WHERE ID =@ID
			END
		END
	END
GO
--转账
CREATE OR ALTER PROCEDURE TransferMoney(@FROM varchar(50),@TO varchar(50),@money INT)
AS
	BEGIN TRY
		BEGIN TRANSACTION transferaccounts
			UPDATE Account
				SET deposit -= @money
				WHERE ID = @FROM
			UPDATE Account
				SET deposit += @money
				WHERE ID = @TO
		COMMIT TRANSACTION transferaccounts
	END TRY
	BEGIN CATCH
		PRINT ('Transfer not succeed')
		ROLLBACK TRANSACTION transferaccounts
	END CATCH
GO

--开户：Fu同学开户存了1块钱，Huang老师也开户存了1块钱
EXECUTE Register 'Fu',1
EXECUTE Register 'Huang',1
--存款：Huang老师存款3999元
EXECUTE DEPOSIT 'Huang',3999
--取款：Huang老师取走了2000元
EXECUTE WITHDRAWAL 'Huang',2000
--转账： Huang老师从自己的账户向Fu同学发放补贴1000元，第二天又发放了1000元
EXECUTE TransferMoney 'Huang','Fu',1000
EXECUTE TransferMoney 'Huang','Fu',1000