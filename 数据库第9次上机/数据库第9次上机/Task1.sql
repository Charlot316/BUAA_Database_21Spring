--�������쳣
PRINT 'Before Error'
SELECT 1/0
PRINT 'After Error'
GO

--�����쳣����
BEGIN TRY
	PRINT 'Before Error'
	SELECT 1/0
	PRINT 'After Error'
END TRY
BEGIN CATCH
	SELECT text FROM sys.messages
		WHERE language_id=2052
		AND message_id=@@ERROR
END CATCH
GO

--�Զ������/�Զ��׳�����
EXECUTE sp_addmessage 233333,10,'A user-defined error.','us_english'
RAISERROR (233333,10,1)
RAISERROR ('This is a tmp error message',10,1)

--�����������
BEGIN TRANSACTION T1
	PRINT ('Begin T1')
	INSERT INTO Test VALUES(1,0.1)
SAVE TRANSACTION S1
	PRINT ('Save S1')
	INSERT INTO Test VALUES(2,0.2)
SAVE TRANSACTION S2
	PRINT ('Save S2')
	INSERT INTO Test VALUES(3,0.3)
ROLLBACK TRANSACTION S1
COMMIT TRANSACTION T1
GO

--һ��������ܣ����������
BEGIN TRY
	BEGIN TRANSACTION T
		INSERT INTO Test VALUES(1,0.1)
		INSERT INTO Test VALUES(2,0.2)
		--������ͻ
		INSERT INTO Test VALUES(2,0.2)
		INSERT INTO Test VALUES(3,0.3)
	COMMIT TRANSACTION T
END TRY
BEGIN CATCH
	PRINT ('Error Caught')
	ROLLBACK TRANSACTION T
END CATCH
GO

--�鿴��ǰ����״��
EXECUTE sp_lock
SELECT * FROM sys.dm_tran_locks

--�ֶ��޸��������㼶
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

--����æ�ȴ�
--�û�1.sql
--�û�1�ȵ�������һ����Ҫ����Ĳ���
BEGIN TRANSACTION T1
    SELECT * FROM Test WITH (HOLDLOCK,XLOCK)
--�û�1һֱ���ύT1


--�û�1���ھ����ύ
COMMIT TRANSACTION T1
--֮���û�2��UPDATE�ű�����ִ��

--�û�2.sql
--�û�2�����������޸ı����ı�
BEGIN TRANSACTION T2
    UPDATE Test SET val = 2
        WHERE id = 1
--�����û�2�Ĳ���æ�ȴ�
COMMIT TRANSACTION T2

--�ֹ�ģ������
--�û�1
--�û�1��OK
BEGIN TRANSACTION T1
SELECT * FROM Test WITH (HOLDLOCK,XLOCK) WHERE id = 1

--�û�1��æ�ȴ�
SELECT * FROM Test WITH (HOLDLOCK,XLOCK) WHERE id = 2

--�û�2
--�û�2��OK
BEGIN TRANSACTION T2
SELECT * FROM Test WITH (HOLDLOCK,XLOCK) WHERE id = 2

--�û�2����������
SELECT * FROM Test WITH (HOLDLOCK,XLOCK) WHERE id = 1

--��־Undo
BEGIN TRAN MakeACrash
	INSERT INTO Test VALUES(4,0.4)
	INSERT INTO Test VALUES(5,0.5)
	--δ�ύȴǿ��ʹ����ҳд�����
	CHECKPOINT
	GO
	--�鿴һ�¿ɼ���ʱȷʵ������д��
	SELECT * FROM Test

--Ȼ��ɱ������mssqlserver
--ע���Ƿ���˽��̶����ǿͻ���SSMS
--Ȼ���������ӣ��鿴Undo�ظ����д�����
SELECT * FROM Test
--�鿴���ݿ�������־
SELECT * FROM sys.fn_dblog(NULL,NULL)