-- MySQL dump 10.13  Distrib 8.0.29, for macos12 (x86_64)
--
-- Host: 127.0.0.1    Database: cataract_service_db
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `consultation`
--

DROP TABLE IF EXISTS `consultation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultation` (
  `c_id` int NOT NULL,
  `p_id` varchar(10) NOT NULL,
  `s_id` int NOT NULL,
  `c_date` date NOT NULL,
  `c_high_risk` tinyint(1) NOT NULL,
  `c_allergy` tinyint(1) NOT NULL,
  PRIMARY KEY (`c_id`),
  KEY `p_id` (`p_id`),
  KEY `s_id` (`s_id`),
  CONSTRAINT `consultation_ibfk_1` FOREIGN KEY (`p_id`) REFERENCES `patient` (`p_id`),
  CONSTRAINT `consultation_ibfk_2` FOREIGN KEY (`s_id`) REFERENCES `staff` (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultation`
--

LOCK TABLES `consultation` WRITE;
/*!40000 ALTER TABLE `consultation` DISABLE KEYS */;
INSERT INTO `consultation` VALUES (1,'P001',1001,'2021-07-23',1,0),(2,'P002',1001,'2021-06-18',1,0),(3,'P003',1001,'2021-07-23',0,1),(4,'P004',1006,'2021-06-18',0,0),(5,'P005',1001,'2021-07-23',0,0),(6,'P006',1006,'2021-07-23',1,0),(7,'P007',1001,'2021-05-05',1,0),(8,'P008',1006,'2021-05-05',0,0),(9,'P009',1006,'2021-05-05',0,1),(10,'P010',1006,'2021-05-05',0,0),(11,'P011',1001,'2021-06-18',0,1),(12,'P012',1006,'2021-06-18',0,0),(13,'P013',1006,'2021-07-23',0,0),(14,'P014',1001,'2021-06-18',0,0),(15,'P015',1001,'2021-06-18',1,0),(16,'P016',1001,'2021-06-14',0,0),(17,'P017',1006,'2021-08-12',1,0),(18,'P018',1001,'2021-08-12',0,0),(19,'P019',1006,'2021-08-12',0,1),(20,'P020',1001,'2021-08-12',0,1),(21,'P021',1001,'2021-08-12',1,1);
/*!40000 ALTER TABLE `consultation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `left_eye`
--

DROP TABLE IF EXISTS `left_eye`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `left_eye` (
  `lt_id` varchar(6) NOT NULL,
  `lt_consult` int NOT NULL,
  `lt_vision` decimal(3,2) NOT NULL,
  `lt_Sx_plan` tinyint(1) NOT NULL,
  PRIMARY KEY (`lt_id`),
  KEY `lt_consult` (`lt_consult`),
  CONSTRAINT `left_eye_ibfk_1` FOREIGN KEY (`lt_consult`) REFERENCES `consultation` (`c_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `left_eye`
--

LOCK TABLES `left_eye` WRITE;
/*!40000 ALTER TABLE `left_eye` DISABLE KEYS */;
INSERT INTO `left_eye` VALUES ('l1',1,0.20,0),('l10',10,0.90,1),('l11',11,0.50,1),('l12',12,0.10,0),('l13',13,0.40,1),('l14',14,0.10,0),('l15',15,0.70,1),('l16',16,0.20,0),('l17',17,1.10,1),('l18',18,0.80,1),('l19',19,0.10,0),('l2',2,0.00,0),('l20',20,1.30,0),('l21',21,0.80,1),('l3',3,0.80,1),('l4',4,0.70,1),('l5',5,0.00,0),('l6',6,0.40,0),('l7',7,0.50,1),('l8',8,0.20,0),('l9',9,0.30,0);
/*!40000 ALTER TABLE `left_eye` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `op_done`
--

DROP TABLE IF EXISTS `op_done`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `op_done` (
  `op_id` int NOT NULL AUTO_INCREMENT,
  `op_case_id` varchar(10) NOT NULL,
  `op_date` date NOT NULL,
  `surgeon_id` int NOT NULL,
  `asst_id` int NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `complication` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`op_id`),
  UNIQUE KEY `op_case_id` (`op_case_id`),
  KEY `surgeon_id` (`surgeon_id`),
  KEY `asst_id` (`asst_id`),
  CONSTRAINT `op_done_ibfk_1` FOREIGN KEY (`surgeon_id`) REFERENCES `staff` (`s_id`),
  CONSTRAINT `op_done_ibfk_2` FOREIGN KEY (`asst_id`) REFERENCES `staff` (`s_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_done`
--

LOCK TABLES `op_done` WRITE;
/*!40000 ALTER TABLE `op_done` DISABLE KEYS */;
INSERT INTO `op_done` VALUES (100,'l10','2021-11-10',1001,1002,'09:15:15','10:01:00',1),(101,'l4','2021-11-10',1001,1002,'10:45:03','11:21:00',0),(102,'l15','2021-11-10',1006,1008,'14:07:15','14:55:11',1),(103,'r2','2021-11-09',1006,1004,'13:15:00','13:55:05',0),(104,'l3','2021-11-09',1006,1004,'11:45:05','12:08:47',0);
/*!40000 ALTER TABLE `op_done` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_into_op` BEFORE INSERT ON `op_done` FOR EACH ROW BEGIN
	IF NEW.op_case_id NOT IN (SELECT eye_id FROM op_list WHERE op_done = 0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT= 'This record is not on the waiting list';
	ELSE
	UPDATE op_list o SET o.op_done = 1 WHERE o.eye_id = NEW.op_case_id;
	END IF;
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `op_list`
--

DROP TABLE IF EXISTS `op_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `op_list` (
  `eye_id` varchar(10) NOT NULL,
  `consult_id` int NOT NULL,
  `listing_date` date NOT NULL,
  `op_done` tinyint(1) DEFAULT '0',
  UNIQUE KEY `eye_id` (`eye_id`),
  KEY `consult_id` (`consult_id`),
  CONSTRAINT `op_list_ibfk_1` FOREIGN KEY (`consult_id`) REFERENCES `consultation` (`c_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_list`
--

LOCK TABLES `op_list` WRITE;
/*!40000 ALTER TABLE `op_list` DISABLE KEYS */;
INSERT INTO `op_list` VALUES ('l10',10,'2021-05-05',1),('l11',11,'2021-06-18',0),('l13',13,'2021-07-23',0),('l15',15,'2021-06-18',1),('l17',17,'2021-08-12',0),('l18',18,'2021-08-12',0),('l21',21,'2021-08-12',0),('l3',3,'2021-07-23',1),('l4',4,'2021-06-18',1),('l7',7,'2021-05-05',0),('r10',10,'2021-05-05',0),('r12',12,'2021-06-18',0),('r13',13,'2021-07-23',0),('r14',14,'2021-06-18',0),('r15',15,'2021-06-18',0),('r18',18,'2021-08-12',0),('r2',2,'2021-06-18',1),('r21',21,'2021-08-12',0),('r3',3,'2021-07-23',0),('r4',4,'2021-06-18',0),('r5',5,'2021-07-23',0),('r7',7,'2021-05-05',0),('r8',8,'2021-05-05',0),('r9',9,'2021-05-05',0);
/*!40000 ALTER TABLE `op_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `p_id` varchar(10) NOT NULL,
  `p_fname` varchar(50) NOT NULL,
  `p_lname` varchar(50) NOT NULL,
  `p_DOB` date NOT NULL,
  `p_gender` varchar(20) DEFAULT NULL,
  `p_phonenum` varchar(15) DEFAULT NULL,
  `p_street_add` varchar(100) DEFAULT NULL,
  `p_city` varchar(50) DEFAULT NULL,
  `p_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES ('P001','Laura','Gates','1939-09-09','Male','0131496 0557','3 Park Lane','Kent','l.gates@trial.com'),('P002','Salma','Jones','1928-12-02','Female','0 113 496 0182','22 Johnson street','Cairne','salma@trial.com'),('P003','Siobhan','Browne','1940-02-10','female','0 117 496 0885','52 Queensway','Chelmsford','cskratch@goldinbox.net'),('P004','Kenzo','Rodrigues','1944-08-03','male','0113 496 0460','3 Church Road','Lerwick',''),('P005','Sammy','Ritter','1954-04-02','male','0 116 496 0178','76 Manchester road','Exeter',''),('P006','Kaylee','Mccray','1939-02-09','female','0 20 7946 0544','44 Windsor street','Taunton',''),('P007','Firat','Irwin','1951-07-15','','0 7700 900560','40 King street','Kilmarnock',''),('P008','Alicia','Deleon','1941-04-23','female','','72 North road','South London','fainarjanzeva@asifboot.com'),('P009','Divine','Oneal','1946-09-07','Male','0 151 496 0393','59 Old street','Croyton','dennissio@bogsmail.me'),('P010','Jayde','Cobb','1932-04-18','','','22 South street','Kent',''),('P011','Nimrah','Cairns','1968-08-14','female','0 8081 570678','23 Queen road','Kilmarnock','michele75@hotmail.com'),('P012','Roscoe','Lawrence','1933-03-12','male','','62 Millie road','Taunton','chanelle.lubowitz@gmail.com\n'),('P013','Beyonce','Macdonald','1950-06-16','female','0 8081 570213','34 Chester lane','Cartine',''),('P014','Sian','Tomlinson','1955-05-31','female','03069 990722','73 Monique road','Calven',''),('P015','Rhonda','Stout','1953-04-22','female','0141 496 0244','23 Caravan close','Hayne',''),('P016','Evan','Bird','1965-07-08','male','08081 570169','44 Mickey lane','Keynes','evebird@getme.com'),('P017','Shiba','James','1965-07-08','Male','','56 Hospice street','Exeter','shibaj@coolmail.com'),('P018','Roseline','Rawlings','1942-09-12','female','08881 570332','12 McCarthy road','South London',''),('P019','Jack','Pierre','1939-02-01','Male','0 151 496 4203','Moonlight Homes','Chelmsford','j.piere@patient.com'),('P020','Ahmed','Abdul','1971-12-15','male','','13 Airport road','Bristol',''),('P021','Kim','Yin','1965-07-08','female','0 291 496 4523','21 South Street','Kent','');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_op`
--

DROP TABLE IF EXISTS `post_op`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_op` (
  `post_op_id` int NOT NULL AUTO_INCREMENT,
  `px_id` varchar(10) NOT NULL,
  `op_id` int NOT NULL,
  `post_op_staff_id` int NOT NULL,
  `post_op_vision` decimal(3,2) NOT NULL,
  `discharge` tinyint(1) NOT NULL,
  PRIMARY KEY (`post_op_id`),
  KEY `px_id` (`px_id`),
  KEY `op_id` (`op_id`),
  KEY `post_op_staff_id` (`post_op_staff_id`),
  CONSTRAINT `post_op_ibfk_1` FOREIGN KEY (`px_id`) REFERENCES `patient` (`p_id`),
  CONSTRAINT `post_op_ibfk_2` FOREIGN KEY (`op_id`) REFERENCES `op_done` (`op_id`),
  CONSTRAINT `post_op_ibfk_3` FOREIGN KEY (`post_op_staff_id`) REFERENCES `staff` (`s_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_op`
--

LOCK TABLES `post_op` WRITE;
/*!40000 ALTER TABLE `post_op` DISABLE KEYS */;
INSERT INTO `post_op` VALUES (1000,'P010',100,1009,0.00,1),(1001,'P004',101,1009,0.10,1),(1002,'P015',102,1009,0.90,0),(1003,'P002',103,1009,0.10,1),(1004,'P003',104,1009,0.20,1);
/*!40000 ALTER TABLE `post_op` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `right_eye`
--

DROP TABLE IF EXISTS `right_eye`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `right_eye` (
  `rt_id` varchar(6) NOT NULL,
  `rt_consult` int NOT NULL,
  `rt_vision` decimal(3,2) NOT NULL,
  `rt_Sx_plan` tinyint(1) NOT NULL,
  PRIMARY KEY (`rt_id`),
  KEY `rt_consult` (`rt_consult`),
  CONSTRAINT `right_eye_ibfk_1` FOREIGN KEY (`rt_consult`) REFERENCES `consultation` (`c_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `right_eye`
--

LOCK TABLES `right_eye` WRITE;
/*!40000 ALTER TABLE `right_eye` DISABLE KEYS */;
INSERT INTO `right_eye` VALUES ('r1',1,0.20,0),('r10',10,0.60,1),('r11',11,0.30,0),('r12',12,0.50,1),('r13',13,0.90,1),('r14',14,1.10,1),('r15',15,1.00,1),('r16',16,0.10,0),('r17',17,0.00,0),('r18',18,0.60,1),('r19',19,0.10,0),('r2',2,1.00,1),('r20',20,0.20,0),('r21',21,0.70,1),('r3',3,0.80,1),('r4',4,0.80,1),('r5',5,0.60,1),('r6',6,0.40,0),('r7',7,0.50,1),('r8',8,1.10,1),('r9',9,0.70,1);
/*!40000 ALTER TABLE `right_eye` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `s_id` int NOT NULL,
  `s_fname` varchar(50) NOT NULL,
  `s_lname` varchar(50) NOT NULL,
  `s_position` varchar(50) NOT NULL,
  `s_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1001,'Jenny','Cooke','ophthalmologist','jenny.cooke@email.com'),(1002,'Nancy','Bell','nurse','nancy.bell@email.com'),(1003,'Jill','Maine','technician','jill.maine@email.com'),(1004,'Brian','James','nurse','brian.james@email.com'),(1005,'Arjun','Sid','administrator','arjun.sid@email.com'),(1006,'Tolu','Abu','ophthalmologist','tolu.abu@email.com'),(1007,'Jill','Maine','administrator','jill.maine1@email.com'),(1008,'Sherry','Hill','nurse','sherry.hill@email.com'),(1009,'John','Ali','optometrist','john.ali@email.com');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `title_case` BEFORE INSERT ON `staff` FOR EACH ROW BEGIN
	SET NEW.s_fname = concat(upper(substring(NEW.s_fname, 1, 1)), 
	lower(substring(NEW.s_fname FROM 2)));
	SET NEW.s_lname = concat(upper(substring(NEW.s_lname, 1, 1)), 
	lower(substring(NEW.s_lname FROM 2)));
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_email` BEFORE INSERT ON `staff` FOR EACH ROW BEGIN
	IF concat(NEW.s_fname,'.',NEW.s_lname,'@email.com') NOT IN 
	(SELECT s_email FROM staff)
	THEN SET NEW.s_email = 
	concat(lower(NEW.s_fname),'.',lower(NEW.s_lname),'@email.com');
	ELSE SET NEW.s_email = concat(lower(NEW.s_fname),'.',lower(NEW.s_lname),
	(SELECT count(s_email) FROM staff WHERE s_email LIKE 
	concat(NEW.s_fname,'.',NEW.s_lname,'%@email.com')),'@email.com');
	END IF;
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vw_all_eyes`
--

DROP TABLE IF EXISTS `vw_all_eyes`;
/*!50001 DROP VIEW IF EXISTS `vw_all_eyes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_all_eyes` AS SELECT 
 1 AS `eye_id`,
 1 AS `consult`,
 1 AS `vision`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_combined_info`
--

DROP TABLE IF EXISTS `vw_combined_info`;
/*!50001 DROP VIEW IF EXISTS `vw_combined_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_combined_info` AS SELECT 
 1 AS `op_case_id`,
 1 AS `surgeon_id`,
 1 AS `op_date`,
 1 AS `complication`,
 1 AS `pre_op_vision`,
 1 AS `high_risk`,
 1 AS `patient_id`,
 1 AS `p_age`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_combined_sx_eyes`
--

DROP TABLE IF EXISTS `vw_combined_sx_eyes`;
/*!50001 DROP VIEW IF EXISTS `vw_combined_sx_eyes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_combined_sx_eyes` AS SELECT 
 1 AS `RE`,
 1 AS `LE`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_lt_sx_eyes`
--

DROP TABLE IF EXISTS `vw_lt_sx_eyes`;
/*!50001 DROP VIEW IF EXISTS `vw_lt_sx_eyes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_lt_sx_eyes` AS SELECT 
 1 AS `RE`,
 1 AS `LE`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_month_sum`
--

DROP TABLE IF EXISTS `vw_month_sum`;
/*!50001 DROP VIEW IF EXISTS `vw_month_sum`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_month_sum` AS SELECT 
 1 AS `date_of_consultation`,
 1 AS `ophthalmologist_id`,
 1 AS `patient_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_rt_sx_eyes`
--

DROP TABLE IF EXISTS `vw_rt_sx_eyes`;
/*!50001 DROP VIEW IF EXISTS `vw_rt_sx_eyes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_rt_sx_eyes` AS SELECT 
 1 AS `RE`,
 1 AS `LE`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_all_eyes`
--

/*!50001 DROP VIEW IF EXISTS `vw_all_eyes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_all_eyes` AS select `right_eye`.`rt_id` AS `eye_id`,`right_eye`.`rt_consult` AS `consult`,`right_eye`.`rt_vision` AS `vision` from `right_eye` union select `left_eye`.`lt_id` AS `eye_id`,`left_eye`.`lt_consult` AS `consult`,`left_eye`.`lt_vision` AS `vision` from `left_eye` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_combined_info`
--

/*!50001 DROP VIEW IF EXISTS `vw_combined_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_combined_info` AS select `o`.`op_case_id` AS `op_case_id`,`o`.`surgeon_id` AS `surgeon_id`,`o`.`op_date` AS `op_date`,`o`.`complication` AS `complication`,`v`.`vision` AS `pre_op_vision`,`c`.`c_high_risk` AS `high_risk`,`p`.`p_id` AS `patient_id`,(select round(((to_days(curdate()) - to_days(`p`.`p_DOB`)) / 365.25),0) AS `sub`) AS `p_age` from (((`op_done` `o` join `vw_all_eyes` `v`) join `consultation` `c`) join `patient` `p`) where ((`o`.`op_case_id` = `v`.`eye_id`) and (`v`.`consult` = `c`.`c_id`) and (`c`.`p_id` = `p`.`p_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_combined_sx_eyes`
--

/*!50001 DROP VIEW IF EXISTS `vw_combined_sx_eyes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_combined_sx_eyes` AS select `vw_rt_sx_eyes`.`RE` AS `RE`,`vw_rt_sx_eyes`.`LE` AS `LE` from `vw_rt_sx_eyes` union select `vw_lt_sx_eyes`.`RE` AS `RE`,`vw_lt_sx_eyes`.`LE` AS `LE` from `vw_lt_sx_eyes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_lt_sx_eyes`
--

/*!50001 DROP VIEW IF EXISTS `vw_lt_sx_eyes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_lt_sx_eyes` AS select `r`.`rt_id` AS `RE`,`l`.`lt_id` AS `LE` from ((select `left_eye`.`lt_id` AS `lt_id`,`left_eye`.`lt_consult` AS `lt_consult`,`left_eye`.`lt_vision` AS `lt_vision`,`left_eye`.`lt_Sx_plan` AS `lt_Sx_plan` from `left_eye` where ((`left_eye`.`lt_Sx_plan` = 1) and `left_eye`.`lt_id` in (select `op_done`.`op_case_id` from `op_done`) is false)) `l` left join (select `right_eye`.`rt_id` AS `rt_id`,`right_eye`.`rt_consult` AS `rt_consult`,`right_eye`.`rt_vision` AS `rt_vision`,`right_eye`.`rt_Sx_plan` AS `rt_Sx_plan` from `right_eye` where ((`right_eye`.`rt_Sx_plan` = 1) and `right_eye`.`rt_id` in (select `op_done`.`op_case_id` from `op_done`) is false)) `r` on((`r`.`rt_consult` = `l`.`lt_consult`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_month_sum`
--

/*!50001 DROP VIEW IF EXISTS `vw_month_sum`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_month_sum` AS select `c`.`c_date` AS `date_of_consultation`,`c`.`s_id` AS `ophthalmologist_id`,count(`c`.`p_id`) AS `patient_id` from `consultation` `c` group by `c`.`s_id`,`c`.`c_date` having ((month(`c`.`c_date`) = month(curdate())) and (year(`c`.`c_date`) = year(curdate()))) order by `c`.`c_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_rt_sx_eyes`
--

/*!50001 DROP VIEW IF EXISTS `vw_rt_sx_eyes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_rt_sx_eyes` AS select `r`.`rt_id` AS `RE`,`l`.`lt_id` AS `LE` from ((select `right_eye`.`rt_id` AS `rt_id`,`right_eye`.`rt_consult` AS `rt_consult`,`right_eye`.`rt_vision` AS `rt_vision`,`right_eye`.`rt_Sx_plan` AS `rt_Sx_plan` from `right_eye` where ((`right_eye`.`rt_Sx_plan` = 1) and `right_eye`.`rt_id` in (select `op_done`.`op_case_id` from `op_done`) is false)) `r` left join (select `left_eye`.`lt_id` AS `lt_id`,`left_eye`.`lt_consult` AS `lt_consult`,`left_eye`.`lt_vision` AS `lt_vision`,`left_eye`.`lt_Sx_plan` AS `lt_Sx_plan` from `left_eye` where ((`left_eye`.`lt_Sx_plan` = 1) and `left_eye`.`lt_id` in (select `op_done`.`op_case_id` from `op_done`) is false)) `l` on((`r`.`rt_consult` = `l`.`lt_consult`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-11 22:50:13
