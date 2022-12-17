USE cataract_service_db;

-- Using any type of the joins create a view that combines multiple
-- tables in a logical way

CREATE OR REPLACE VIEW vw_rt_sx_eyes AS
	SELECT r.rt_id AS RE, l.lt_id AS LE FROM 
    (SELECT * FROM right_eye 
		WHERE rt_Sx_plan = 1 AND rt_id NOT IN (SELECT op_case_id FROM op_done)) AS r
    LEFT OUTER JOIN
    (SELECT * FROM left_eye 
		WHERE lt_Sx_plan = 1 AND lt_id NOT IN (SELECT op_case_id FROM op_done)) AS l
    ON r.rt_consult = l.lt_consult;
    

CREATE OR REPLACE VIEW vw_lt_sx_eyes AS 
	SELECT r.rt_id AS RE, l.lt_id AS LE FROM 
    (SELECT * FROM right_eye 
		WHERE rt_Sx_plan = 1 AND rt_id NOT IN (SELECT op_case_id FROM op_done)) AS r
    RIGHT OUTER JOIN 
    (SELECT * FROM left_eye 
		WHERE lt_Sx_plan = 1 AND lt_id NOT IN (SELECT op_case_id FROM op_done)) AS l
    ON r.rt_consult = l.lt_consult;


CREATE OR REPLACE VIEW vw_combined_sx_eyes AS (
	SELECT * FROM vw_rt_sx_eyes) 
	UNION 
	(SELECT * FROM vw_lt_sx_eyes);


 -- In your database, create a stored function that can be applied to
-- a query in your DB

-- the stored function

DELIMITER //
CREATE FUNCTION waiting_time(eye_vision DECIMAL(3,2))
	RETURNS INT
	DETERMINISTIC
	BEGIN
	DECLARE w_time INT;
	IF eye_vision <= 0.5 THEN SET w_time = 12;
	ELSEIF eye_vision <= 0.8 THEN SET w_time = 6;
	ELSE SET w_time = 3;
	END IF;
	RETURN (w_time);
	END// eye_vision
DELIMITER ;

-- query that analyses data in the op_list, shows the eyes waiting, 
-- the listing date, ideal time frame (using the function) and delay 

(SELECT c.p_id AS patient_id, w.eye_id, c.c_date AS listing_date,
	waiting_time(r.rt_vision) AS wait_time, 
	round(datediff(curdate(), c.c_date)/30) AS delay_in_mths
	FROM op_list w, right_eye r, consultation c 
	WHERE r.rt_Sx_plan = 1 AND w.eye_id = r.rt_id 
	AND w.op_done = 0 AND r.rt_consult = c.c_id) 
UNION
(SELECT c.p_id AS patient_id, w.eye_id,c.c_date AS listing_date, 
	waiting_time(l.lt_vision) AS wait_time ,  
	round(datediff(curdate(), c.c_date)/30) AS delay_in_mths
	FROM op_list w, left_eye l, consultation c 
	WHERE l.lt_Sx_plan = 1 AND w.eye_id = l.lt_id 
	AND w.op_done = 0 AND l.lt_consult= c.c_id) 
ORDER BY wait_time;


-- Prepare an example query with a subquery to demonstrate how
-- to extract data from your DB for analysis

-- to show the factors in the complicated cases
SELECT o.op_case_id, o.surgeon_id, o.op_date, o.complication, v.vision 
AS pre_op_vision,c.c_high_risk AS high_risk, p.p_id AS patient_id, 
(SELECT (round(datediff(curdate(), p.p_DOB)/365.25)) AS sub) AS p_age
FROM op_done o, vw_all_eyes v, consultation c, patient p WHERE
o.op_case_id = v.eye_id AND v.consult = c.c_id 
AND c.p_id = p.p_id AND o.complication = 1;


 -- In your database, create a stored procedure and
-- demonstrate how it runs

-- STORED PROCS TO UPDATE OP_DONE (not created in the database)
DELIMITER //
CREATE PROCEDURE update_op
	(opCase_id VARCHAR (6), opDate DATE, surgeonId INT, asstId INT, timeStart TIME, 
	timeEnd TIME, complication BOOLEAN)
	BEGIN
	IF opCase_id NOT IN (SELECT eye_id FROM op_list WHERE op_done = 0) THEN
	-- set new.op_case_id = null;
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'An error occured. This data is not on the waiting list';
	ELSE
	UPDATE op_list o SET o.op_done = 1 WHERE o.eye_id = opCase_id;
	END IF;
	END //
DELIMITER ;

-- incorrect entry
CALL update_op('r16', '2021-11-9', 10006, 10004,'11:45:05','12:08:47', 0);

-- test before correct entry
SELECT * FROM op_done;
SELECT * FROM op_list;

-- correct entry
CALL update_op('r8', '2021-11-15', 1006, 1008, '08:30:30', '09:05:00',0);

-- test after correct entry
SELECT * FROM op_done;
SELECT * FROM op_list;

-- In your database, create a trigger and demonstrate how it runs

-- before insert trigger created to insert title case and autogenerated email
-- view the current staff table (note, there is no ID 1010)
SELECT * FROM staff;

-- To test, delete the trigger
DROP TRIGGER title_case;
DROP TRIGGER insert_email;

DELIMITER //
CREATE TRIGGER title_case
	BEFORE INSERT ON staff FOR EACH ROW
	BEGIN
	SET NEW.s_fname = concat(upper(substring(NEW.s_fname, 1, 1)), 
	lower(substring(NEW.s_fname FROM 2)));
	SET NEW.s_lname = concat(upper(substring(NEW.s_lname, 1, 1)), 
	lower(substring(NEW.s_lname FROM 2)));
	END//
DELIMITER ;


-- create trigger to insert email into staff
-- and avoid email duplication if similar name in db

DELIMITER //
CREATE TRIGGER insert_email
	BEFORE INSERT ON staff FOR EACH ROW
	BEGIN
	IF concat(NEW.s_fname,'.',NEW.s_lname,'@email.com') NOT IN 
	(SELECT s_email FROM staff)
	THEN SET NEW.s_email = 
	concat(lower(NEW.s_fname),'.',lower(NEW.s_lname),'@email.com');
	ELSE SET NEW.s_email = concat(lower(NEW.s_fname),'.',lower(NEW.s_lname),
	(SELECT count(s_email) FROM staff WHERE s_email LIKE 
	concat(NEW.s_fname,'.',NEW.s_lname,'%@email.com')),'@email.com');
	END IF;
	END//
DELIMITER ;

-- test trigger

INSERT INTO staff
(s_id, s_fname, s_lname, s_position)
values
(1010,'lucy', 'lawrence', 'caterer');

-- view the recent change
SELECT * FROM staff;

-- In your database, create an event and demonstrate how it runs

-- create event to update (create or replace) a view every month
-- start at current timestamp for testing purposes

-- to test drop the view
DROP VIEW vw_month_sum;

DELIMITER //
CREATE EVENT month_summary ON SCHEDULE EVERY 1 MONTH
	STARTS CURRENT_TIMESTAMP
	ENDS CURRENT_TIMESTAMP + INTERVAL 1 YEAR
	DO
	BEGIN
	CREATE OR REPLACE VIEW vw_month_sum AS
		SELECT c.c_date AS date_of_consultation, c.s_id AS ophthalmologist_id, 
		count(c.p_id) AS patient_id FROM consultation c
		GROUP BY c.s_id, c.c_date
		HAVING MONTH(c.c_date) = MONTH(curdate()) AND YEAR(c.c_date) = YEAR(curdate())
		ORDER BY c.c_date;
	END//
DELIMITER ;


-- Create a view that uses at least 3-4 base tables;
-- prepare and demonstrate a query that uses the view to
-- produce a logically arranged result set for analysis.

CREATE VIEW vw_all_eyes AS
	SELECT rt_id AS eye_id, rt_consult AS consult,
	rt_vision AS vision FROM right_eye
	UNION
    SELECT lt_id AS eye_id, lt_consult AS consult, 
    lt_vision AS vision FROM left_eye;



CREATE VIEW vw_combined_info AS 
	SELECT o.op_case_id, o.surgeon_id, o.op_date, o.complication, v.vision 
	AS pre_op_vision, c.c_high_risk AS high_risk, p.p_id AS patient_id, 
	(SELECT (round(datediff(curdate(), p.p_DOB)/365.25)) AS sub) AS p_age
	FROM op_done o, vw_all_eyes v, consultation c, patient p 
    WHERE o.op_case_id = v.eye_id AND v.consult = c.c_id AND c.p_id = p.p_id;



-- query from the view
-- query to determine number of complicated cases per surgeon

SELECT surgeon_id, count(complication) AS no_of_complications 
FROM vw_combined_info 
WHERE complication = 1 
GROUP BY surgeon_id;

-- Prepare an example query with group by and having to
-- demonstrate how to extract data from your DB for analysis

-- to find the number of patients seen by each ophthalmologist
-- (who has seen at least 1 patient) in the month of july

SELECT c.s_id AS ophthalmologist_id, 
count(c.p_id) AS num_of_patients FROM consultation c
WHERE MONTH(c.c_date) = 7
GROUP BY c.s_id
HAVING num_of_patients >= 1
ORDER BY c.s_id;

