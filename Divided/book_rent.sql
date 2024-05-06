SET SERVEROUTPUT ON;
SET VERIFY OFF;

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
		
		DBMS_OUTPUT.PUT_LINE(no_of_books);
		
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
			
			-- UPDATE books SET subscribed_to = 0 WHERE 


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
	

SELECT * FROM lib;
SELECT * FROM books;
SELECT * FROM customer;
SELECT * FROM subscription;