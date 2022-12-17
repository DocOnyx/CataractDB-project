
CREATE DATABASE cataract_service_db;
USE cataract_service_db;

-- create staff table (data will be inserted)

CREATE TABLE staff 
(s_id INT PRIMARY KEY, s_fname VARCHAR (50) NOT NULL, 
s_lname VARCHAR (50) NOT NULL, 
s_position VARCHAR (50) NOT NULL, s_email VARCHAR  (50));


-- create patient table(data will be imported from csv)

CREATE TABLE patient 
(p_id VARCHAR(10) PRIMARY KEY, p_fname VARCHAR (50) NOT NULL, 
p_lname VARCHAR (50) NOT NULL, 
p_DOB DATE NOT NULL,p_gender VARCHAR (20), p_phonenum VARCHAR (15), 
p_street_add VARCHAR(100), p_city VARCHAR (50), p_email VARCHAR (50));


-- create consultation record table (data will be imported from csv)

CREATE TABLE consultation 
(c_id INT PRIMARY KEY, p_id VARCHAR(10) NOT NULL, s_id INT NOT NULL, 
c_date DATE NOT NULL, c_high_risk BOOLEAN NOT NULL, 
c_allergy BOOLEAN NOT NULL,
FOREIGN KEY (p_id) REFERENCES patient(p_id), FOREIGN KEY (s_id) 
REFERENCES staff(s_id));


-- create right eye table (data will be imported from csv)

CREATE TABLE right_eye 
(rt_id VARCHAR(6) PRIMARY KEY, rt_consult INT NOT NULL, rt_vision DECIMAL(3, 2) 
NOT NULL, rt_Sx_plan BOOLEAN NOT NULL,
FOREIGN KEY (rt_consult) REFERENCES consultation (c_id));


-- create left eye table (data will be imported from csv)

CREATE TABLE left_eye 
(lt_id VARCHAR(6) PRIMARY KEY, lt_consult INT NOT NULL, lt_vision DECIMAL(3, 2) 
NOT NULL, lt_Sx_plan BOOLEAN NOT NULL,
FOREIGN KEY (lt_consult) REFERENCES consultation (c_id));


-- create waiting list table ( eye_id is unique to avoid duplication)


CREATE TABLE op_list 
(eye_id VARCHAR(10) NOT NULL UNIQUE, 
consult_id INT NOT NULL, listing_date DATE NOT NULL, op_done BOOLEAN DEFAULT 0,
FOREIGN KEY (consult_id) REFERENCES consultation (c_id));


-- create table op_done for the surgeries. op_case_id set to unique to 
-- avoid duplication in data entry
-- op_case_id will reference either rt_id or lt_id in right_eye or left_eye tables


CREATE TABLE op_done
(op_id INT PRIMARY KEY AUTO_INCREMENT, op_case_id VARCHAR(10) UNIQUE NOT NULL, 
op_date DATE NOT NULL, surgeon_id INT NOT NULL,
asst_id INT NOT NULL, start_time TIME NOT NULL, end_time TIME NOT NULL, 
complication BOOLEAN,
FOREIGN KEY (surgeon_id) REFERENCES staff (s_id),
FOREIGN KEY (asst_id) REFERENCES staff (s_id));

ALTER TABLE op_done AUTO_INCREMENT=100;


CREATE TABLE post_op 
(post_op_id INT PRIMARY KEY AUTO_INCREMENT, px_id VARCHAR(10) NOT NULL, op_id INT NOT NULL, 
post_op_staff_id INT NOT NULL, post_op_vision DECIMAL (3,2) NOT NULL,
discharge BOOLEAN NOT NULL,
FOREIGN KEY (px_id) REFERENCES patient (p_id),
FOREIGN KEY (op_id) REFERENCES op_done (op_id),
FOREIGN KEY (post_op_staff_id) REFERENCES staff (s_id));

ALTER TABLE post_op AUTO_INCREMENT = 1000;

-- POPULATE CREATED TABLES

-- BEFORE INSERT TRIGGER
-- create trigger for title_case for staff

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


-- insert data into table staff

INSERT INTO staff
(s_id, s_fname, s_lname, s_position)
VALUES
	(1001,'jenny', 'cooke', 'ophthalmologist'),
	(1002, 'nancy', 'bell', 'nurse'),
	(1003, 'jill', 'maine', 'technician'),
	(1004, 'brian', 'james', 'nurse'),
	(1005, 'arjun', 'sid', 'administrator'),
	(1006, 'tolu', 'abu', 'ophthalmologist'),
	(1007, 'jill', 'maine', 'administrator'),
	(1008, 'sherry', 'hill', 'nurse'),
	(1009, 'john', 'ali', 'optometrist');



-- csv files imported for patient, consultation, right_eye, left_eye tables

-- STORED PROCS
-- insert data into op list table from right and left eye records using 
-- stored procs which checks that the 'new' data needs Sx and is not already in the op list


DELIMITER //
CREATE PROCEDURE insert_data(tbl_name VARCHAR (15))
	BEGIN
	DECLARE query1 VARCHAR (350);
	DECLARE query2 VARCHAR (350);
	SET @query1 = 'insert into op_list (eye_id, consult_id, listing_date) 
	select r.rt_id, r.rt_consult, c.c_date from right_eye r, consultation c
	where r.rt_Sx_plan = 1 and r.rt_id not in 
	(select eye_id from op_list) and r.rt_consult = c.c_id';
	SET @query2 = 'insert into op_list (eye_id, consult_id, listing_date) 
	select l.lt_id, l.lt_consult, c.c_date from left_eye l, consultation c
	where l.lt_Sx_plan = 1 and l.lt_id not in
	(select eye_id from op_list) and l.lt_consult = c.c_id';
	IF tbl_name = 'right_eye' THEN
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	ELSEIF tbl_name = 'left_eye' THEN
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	END IF;
	END//
DELIMITER ;


CALL insert_data('right_eye');
CALL insert_data('left_eye');


-- create a table that combines right n left eye table to show which patients 
-- need both or one eye surgery

-- firstly, create views that meet the condition, then union both 

-- create or replace keyword used b/c this could be enveloped in an event
-- to update the view at scheduled intervals.



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



-- STORED FUNCTION
-- create stored function that checks if both eyes are listed and use the 
-- function to query the combined view and get info on laterality

DELIMITER //
CREATE FUNCTION check_lat(eye1 VARCHAR (6), eye2 VARCHAR(6))
	RETURNS VARCHAR (10)
	DETERMINISTIC
	BEGIN
	DECLARE result VARCHAR (10);
	IF eye1 IS NULL THEN
	SET result = 'left eye';
	ELSEIF eye2 IS NULL THEN
	SET result = 'right eye';
	ELSE SET result = 'both eyes';
	END IF;
	RETURN (result);
	END// eye1, eye2
DELIMITER ;


-- 	query to show the laterality using the function check_lat
SELECT v.RE, v.LE, check_lat(v.RE, v.LE) AS laterality
FROM vw_combined_sx_eyes v
ORDER BY laterality;



-- create before insert trigger to insert surgery data into op_done table
-- the trigger checks that the data is IN the op list already 
-- and updates the op_done column of the op list

DELIMITER //
CREATE TRIGGER insert_into_op
	BEFORE INSERT ON op_done FOR EACH ROW
	BEGIN
	IF NEW.op_case_id NOT IN (SELECT eye_id FROM op_list WHERE op_done = 0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT= 'This record is not on the waiting list';
	ELSE
	UPDATE op_list o SET o.op_done = 1 WHERE o.eye_id = NEW.op_case_id;
	END IF;
	END //
DELIMITER ;

-- sample data entry to op table

-- correct data

INSERT INTO op_done 
(op_case_id, op_date, surgeon_id,asst_id, start_time, end_time, complication)
VALUES 
	('l10', '2021-11-10', 1001, 1002,'09:15:15','10:01:00', 1),
	('l4', '2021-11-10', 1001, 1002,'10:45:03','11:21:00', 0),
	('l15', '2021-11-10', 1006, 1008,'14:07:15','14:55:11', 1),
	('r2', '2021-11-9', 1006, 1004,'13:15:00','13:55:05', 0),
	('l3', '2021-11-9', 1006, 1004,'11:45:05','12:08:47', 0);

-- incorrect data

INSERT INTO op_done 
(op_case_id, op_date, surgeon_id,asst_id, start_time, end_time, complication)
VALUES ('r16', '2021-11-10', 1006, 1004,'15:45:05','16:08:00', 0);

-- check that data entry was accurate
SELECT * FROM op_done;
SELECT * FROM op_list;


-- create function to determine ideal time_frame from patient's vision

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
-- the listing date, ideal time framE (using the function) and delay 

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


-- example query with group by and having 
-- to find the number of patients seen by each ophthalmologist in the year 2021.

SELECT c.c_date AS date_of_consultation, c.s_id AS ophthalmologist_id, 
count(c.p_id) AS patient_id 
FROM consultation c
GROUP BY c.s_id, c.c_date
HAVING c.c_date LIKE '2021-%'
ORDER BY c.c_date;



-- EVENT
-- create event to assess similar query every month by creating a view
-- start at current timestamp for testing purposes

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


-- create view from 3-4 base tables

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



-- create event to update view vw_combined_info every month


DELIMITER //
CREATE EVENT update_combined_vw
	ON SCHEDULE EVERY 1 MONTH
	STARTS CURRENT_TIMESTAMP
	ENDS CURRENT_TIMESTAMP + INTERVAL 1 YEAR
	DO
	BEGIN
	CREATE OR REPLACE VIEW vw_combined_info AS 
	SELECT o.op_case_id, o.surgeon_id, o.op_date, o.complication, v.vision 
	AS pre_op_vision, c.c_high_risk AS high_risk, p.p_id AS patient_id, 
	(SELECT (round(datediff(curdate(), p.p_DOB)/365.25)) AS sub) AS p_age
	FROM op_done o, vw_all_eyes v, consultation c, patient p 
    WHERE o.op_case_id = v.eye_id AND v.consult = c.c_id AND c.p_id = p.p_id;
    END //
DELIMITER ;


-- query to determine number of complicated cases per surgeon

SELECT surgeon_id, count(complication) AS no_of_complications 
FROM vw_combined_info 
WHERE complication = 1 
GROUP BY surgeon_id;


-- create procedure to find out number of px seen in a month

DELIMITER //
CREATE PROCEDURE consult_sum (mth INT)
	BEGIN
	SELECT count(*) FROM consultation WHERE MONTH(c_date) = mth;
	END//
DELIMITER ;


CALL consult_sum(8);


-- enter data into post op table

INSERT INTO post_op 
(px_id, op_id, post_op_staff_id, post_op_vision,
discharge) 
VALUES
	('P010', 100, 1009, 0.00, 1),
	('P004', 101, 1009, 0.10, 1),
	('P015', 102, 1009, 0.90, 0),
	('P002', 103, 1009, 0.10, 1),
	('P003', 104, 1009, 0.20, 1);

