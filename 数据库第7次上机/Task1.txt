CREATE DATABASE Library;
USE Library;
GO
CREATE TABLE ACCOUNT(
	Username varchar(50) PRIMARY KEY,
	psw varchar(50) NOT NULL
);
GO
CREATE TABLE BOOKS(
	Bookname varchar(50) PRIMARY KEY,
	Bookcount INT NOT NULL
);
GO
CREATE TABLE RECORD(
	Username varchar(50),
	Bookname varchar(50),
	Loantime date default getdate(),
	Duetime as dateadd(dd,30,Loantime),
	PRIMARY KEY (Username,Bookname),
	CONSTRAINT fk_record_to_account FOREIGN KEY (Username) REFERENCES ACCOUNT(Username),
	CONSTRAINT fk_record_to_books FOREIGN KEY (Bookname) REFERENCES BOOKS(Bookname),
);
GO

