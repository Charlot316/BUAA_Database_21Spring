--�½���
CREATE TABLE Account(
	ID varchar(50)  PRIMARY KEY,
	deposit INT CHECK(deposit>=1),
)
--����
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
--���
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
--ȡ��
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
--ת��
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

--������Fuͬѧ��������1��Ǯ��Huang��ʦҲ��������1��Ǯ
EXECUTE Register 'Fu',1
EXECUTE Register 'Huang',1
--��Huang��ʦ���3999Ԫ
EXECUTE DEPOSIT 'Huang',3999
--ȡ�Huang��ʦȡ����2000Ԫ
EXECUTE WITHDRAWAL 'Huang',2000
--ת�ˣ� Huang��ʦ���Լ����˻���Fuͬѧ���Ų���1000Ԫ���ڶ����ַ�����1000Ԫ
EXECUTE TransferMoney 'Huang','Fu',1000
EXECUTE TransferMoney 'Huang','Fu',1000