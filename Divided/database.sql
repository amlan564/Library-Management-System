DROP TABLE lib;
DROP TABLE customer;
DROP TABLE books;
DROP TABLE subscription;

CREATE TABLE lib(
	bookname VARCHAR(20),
	author VARCHAR(20),
	publication VARCHAR(20),
	noofcopies NUMBER);
	
CREATE TABLE customer(
	rollno NUMBER,
	name VARCHAR(20),
	no_card NUMBER);

CREATE TABLE books(
	bookno NUMBER,
	bookname VARCHAR(20),
	available VARCHAR(20),
	subscribed_to NUMBER);
	
CREATE TABLE subscription(
	bookno NUMBER,
	rollno NUMBER,
	do_sub DATE,
	do_return DATE,
	fineamount NUMBER,
	status VARCHAR(20));
	
	
INSERT INTO lib VALUES ('Adventures of Tom Sawyer','Mark Twain','tata',4);
INSERT INTO lib VALUES ('Agni Veena','Kazi Nasrul Islam','tata',4);
INSERT INTO lib VALUES ('Animal Farm','George Orwell','tata',4);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Baburnama','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);
INSERT INTO lib VALUES ('Ben Hur','Lewis Wallace','scitech',1);


-- INSERT INTO books VALUES (23,'cn','yes',0);
-- INSERT INTO books VALUES (28,'ooad','yes',0);
-- INSERT INTO books VALUES (32,'dbms','yes',0);
-- INSERT INTO books VALUES (37,'evs','yes',0);
-- INSERT INTO books VALUES (40,'evs','yes',0);
-- INSERT INTO books VALUES (42,'evs','yes',0);

INSERT INTO customer VALUES (5058,'pavi',2);
INSERT INTO customer VALUES (5056,'suresh',2);


SELECT * FROM lib;
SELECT * FROM books;
SELECT * FROM customer;