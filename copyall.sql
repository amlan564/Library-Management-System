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
	
	
INSERT INTO lib VALUES ('Adventures','Mark Twain','tata',4);
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

SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- book insert

DECLARE

	bookno number;
	bname varchar(15);
	noc number;
	noc1 number;
	author varchar(15);
	publication varchar(10);
	nobooks number;
	lib_rec lib%rowtype;

BEGIN

	bookno:=&bookno;
	bname:='&bookname';
	author:='&author';
	publication:='&publication';
	noc:=&noofcopies;
	noc1:=noc;
	
	SELECT COUNT(*) INTO nobooks FROM lib WHERE bookname=bname;
	
	IF nobooks=0 THEN
	
		INSERT INTO lib VALUES(bname,author,publication,noc);
		
	ELSE
	
		UPDATE lib SET noofcopies=noofcopies+noc WHERE bookname=bname;
		
	END IF;
	
	WHILE noc!=0
	
	LOOP
	
		INSERT INTO books VALUES(bookno,bname,'yes',0);
		noc:=noc-1;
		bookno:=bookno+1;
		
	END LOOP;
END;
/

SELECT * FROM books;

-- book rent

CREATE OR REPLACE PROCEDURE sub(bname IN CHAR, roll_no IN NUMBER)
IS

lib_rec lib%ROWTYPE;
book_rec books%ROWTYPE;
stud_rec customer%ROWTYPE;
sub_rec subscription%ROWTYPE;
book_no NUMBER;
no_of_books NUMBER;

BEGIN

	SELECT * INTO stud_rec FROM customer WHERE rollno = roll_no;
	
	IF stud_rec.no_card = 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('no card available');
		
	ELSE
	
		SELECT COUNT(*) INTO no_of_books FROM books WHERE bookname = bname AND available = 'yes';
		
		-- DBMS_OUTPUT.PUT_LINE(no_of_books);
		
	END IF;
	
	IF no_of_books = 0 THEN
	
		DBMS_OUTPUT.PUT_LINE(bname || ' is not available');
		
	ELSE
	
		SELECT MIN(bookno) INTO book_no FROM books WHERE bookname = bname AND available = 'yes';
		
		INSERT INTO subscription VALUES(book_no,roll_no,SYSDATE,SYSDATE+7,0,'ntreturned');

        IF stud_rec.no_card > 0 THEN 

		    UPDATE customer SET no_card = no_card - 1 WHERE rollno = roll_no;

        ELSE 

		    UPDATE customer SET no_card = 0 WHERE rollno = roll_no;


        END IF;
		
		-- UPDATE customer SET no_card = no_card - 1 WHERE rollno = roll_no;
		
		UPDATE books SET available = 'no' WHERE bookno = book_no;
		
		UPDATE books SET subscribed_to = roll_no WHERE bookno = book_no;
		
	END IF;
	
	EXCEPTION
	
	WHEN no_data_found THEN
	
		DBMS_OUTPUT.PUT_LINE('You are not a user');
		
END;
/

-- BEGIN
	-- sub('evs',5058);
-- END;
-- /

ACCEPT B CHAR PROMPT "Enter the name of book you want to rent = ";

-- ACCEPT N CHAR PROMPT "Enter student name = ";

ACCEPT R NUMBER PROMPT "Enter student roll no = ";

DECLARE

	X VARCHAR(20);
	Y NUMBER;
	
BEGIN

	X := &B;
	y := &R;

	sub(X,Y);

END;
/

SELECT * FROM customer;


SELECT * FROM lib;
SELECT * FROM books;
SELECT * FROM customer;
SELECT * FROM subscription;

-- Return Book

CREATE OR REPLACE PROCEDURE ret(bno IN NUMBER) 
IS

lib_rec lib%ROWTYPE;
book_rec books%ROWTYPE;
stud_rec customer%ROWTYPE;
sub_rec subscription%ROWTYPE;
book_no NUMBER;
no_of_books NUMBER;
fine NUMBER;

BEGIN

	SELECT * INTO book_rec FROM books WHERE bookno=bno;
	
	IF book_rec.available='yes' THEN
	
		DBMS_OUTPUT.PUT_LINE('book available');
		
	ELSE
	
		UPDATE subscription SET do_return=SYSDATE WHERE bookno=bno AND status='ntreturned';
		
		SELECT do_return-do_sub INTO fine from subscription WHERE bookno=bno AND status='ntreturned';
		
		IF fine>7 then
		
			UPDATE subscription SET fineamount=fine WHERE bookno=bno AND status='ntreturned';
			
			DBMS_OUTPUT.PUT_LINE('u have to pay a fine of||rs||fine||');
			
		END IF;
		
		UPDATE subscription SET status='returned' WHERE bookno=bno;
		
		UPDATE customer SET no_card=no_card+1 WHERE rollno=book_rec.subscribed_to;
		
		UPDATE books SET available='yes' WHERE bookno=bno;
		
		UPDATE books SET subscribed_to=0 WHERE bookno=bno;
		
	END IF;
	
	EXCEPTION
	
	WHEN no_data_found THEN
	
		DBMS_OUTPUT.PUT_LINE('Book does not belong to library');
		
END;
/

CREATE OR REPLACE TRIGGER subs_trig
AFTER UPDATE
OF status 
ON subscription
BEGIN
	DBMS_OUTPUT.PUT_LINE('Subscription status updated');
END;
/

COMMIT;