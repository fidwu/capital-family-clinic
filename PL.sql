-- #############################
-- CREATE clinic
-- #############################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_insert_clinic;


DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_insert_clinic(
    IN p_address varchar(45),
    IN p_city varchar(45),
    IN p_state varchar(2),
    IN p_postalCode varchar(5),
    IN p_phoneNumber char(12),
    OUT p_id INT)

-- Begin the transaction to insert the given data into Clinics
BEGIN
    INSERT INTO `Clinics` (`address`, `city`, `state`, `postalCode`, `phoneNumber`)
    VALUES (p_address, p_city, p_state, p_postalCode, p_phoneNumber);


    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted clinic
    SELECT LAST_INSERT_ID() AS 'new_id';
END / /

DELIMITER ;


-- #############################
-- CREATE patient
-- #############################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_insert_patient;


DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_insert_patient(
    IN p_firstName varchar(45),
    IN p_lastName varchar(45),
    IN p_phoneNumber char(12),
    IN p_email varchar(150),
    IN p_dateOfBirth DATE,
    IN p_gender varchar(10),
    IN p_clinicId INT,
    OUT p_id INT)
-- Begin the transaction to insert the given data into Patients
BEGIN
    INSERT INTO `Patients` (`firstName`, `lastName`, `phoneNumber`, `email`, `dateOfBirth`, `gender`, `clinicId`)
    VALUES (p_firstName, p_lastName, p_phoneNumber, p_email, p_dateOfBirth, p_gender, p_clinicId);


    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted patient
    SELECT LAST_INSERT_ID() AS 'new_id';
END / /

DELIMITER ;


-- #############################
-- CREATE appointment
-- #############################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_insert_appointment;

DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_insert_appointment(
    IN p_dateTime DATETIME,
    IN p_clinicId INT,
    IN p_patientId INT,
    IN p_statusId INT,
    OUT p_id INT)

-- Begin the transaction to insert the given data into Appointments
BEGIN
    INSERT INTO `Appointments` (`dateTime`, `clinicId`,`patientId`,`statusId`)
    VALUES(p_dateTime, p_clinicId, p_patientId, p_statusId);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted appointment
    SELECT LAST_INSERT_ID() AS 'new_id';
END / /

DELIMITER ;


-- #############################
-- CREATE appointmenttest
-- #############################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_insert_appointmenttest;


DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_insert_appointmenttest(
    IN p_appointmentId INT,
    IN p_testId INT,
    IN p_testResultId INT,
    OUT p_id INT)

-- Begin the transaction to insert the given data into appointmentstests
BEGIN
    INSERT INTO `AppointmentsTests` (`appointmentId`, `testId`, `testResultId`)
    VALUES (p_appointmentId, p_testId, p_testResultId);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted appointmentTest
    SELECT LAST_INSERT_ID() AS 'new_id';
END / /

DELIMITER ;


-- #############################
-- CREATE test
-- #############################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_insert_test;


DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_insert_test(
    IN p_name VARCHAR(45),
    OUT p_id INT)

-- Start the transaction to insert the given data into Tests
BEGIN
    INSERT INTO `Tests` (`name`)
    VALUES (p_name);


    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted appointmentTest
    SELECT LAST_INSERT_ID() AS 'new_id';
END / /

DELIMITER ;

-- ###################
-- DELETE Tests
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_delete_test;
DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_delete_test(IN p_testId INT)
BEGIN
    -- Create the exit handler to handle errors, rollback as necessary
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;
    -- Start the transaction to delete from Tests at the given Id
    START TRANSACTION;
        DELETE FROM `Tests` WHERE `testId` = p_testId;
        IF ROW_COUNT() =0 THEN
            SET error_message = CONCAT('No matching record found in Tests for testId:', p_testId);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END / /

DELIMITER ;
-- ###################
-- DELETE Clinics
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_delete_clinic;
DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_delete_clinic(IN p_clinicId INT)
BEGIN
    -- Create the exit handler to handle errors, rollback as necessary
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;
    -- Start the transaction to delete from clincs at the given Id
    START TRANSACTION;
        DELETE FROM `Clinics` WHERE `clinicId` = p_clinicId;
        IF ROW_COUNT() =0 THEN
            SET error_message = CONCAT('No matching record found in Clinics for clinicId:', p_clinicId);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END / /

DELIMITER ;


-- ####################
-- DELETE Appointments
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_delete_appointment;
DELIMITER / /

-- Create the procedure with the appropriate variables 
CREATE PROCEDURE sp_delete_appointment(IN p_appointmentId INT)
BEGIN
-- Create the exit handler to handle errors, rollback as necessary
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;
    -- Start the transaction to delete from Appointments at the given Id
    START TRANSACTION;
        DELETE FROM `Appointments` WHERE `appointmentId` = p_appointmentId;
        IF ROW_COUNT() =0 THEN
            SET error_message = CONCAT('No matching record found in Appointments for appointmentId:', p_appointmentId);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END / /

DELIMITER ;


-- ###################
-- UPDATE Patients
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_update_patient;
DELIMITER / /

-- Create the stored procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_patient`(IN p_patientId INT,
    IN p_firstName VARCHAR(45),
    IN p_lastName VARCHAR(45),
    IN p_phoneNumber char(12),
    IN p_email VARCHAR(150),
    IN p_dateOfBirth DATE,
    IN p_gender ENUM('Male', 'Female', 'Unknown'),
    IN p_clinicId INT  )

-- Begin the procedure to update the clinic at the given Id, with the given data 
BEGIN
    UPDATE `Patients`
    SET `firstName` = p_firstName,
    `lastName` = p_lastName,
    `phoneNumber` = p_phoneNumber,
    `email` = p_email,
    `dateOfBirth` = p_dateOfBirth,
    `gender` = p_gender,
    `clinicId` = p_clinicId
    WHERE `patientId` = p_patientId;
END / /
DELIMITER ;


-- ###################
-- UPDATE Tests
-- ####################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_update_test;
DELIMITER / /

-- Create the procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_test`(
    IN p_testId INT,
    IN p_name VARCHAR(45))

-- Begin the transaction to update Test at the given Id, with the given data
BEGIN
    UPDATE `Tests`
    SET `name` = p_name
    WHERE `testId` = p_testId;
END / /
DELIMITER ;
-- ###################
-- UPDATE Clinics
-- ####################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_update_clinic;
DELIMITER / /

-- Create the procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_clinic`(
    IN p_clinicId INT,
    IN p_address VARCHAR(45),
    IN p_city VARCHAR(45),
    IN p_state CHAR(2),
    IN p_postalCode VARCHAR(5),
    IN p_phoneNumber CHAR(12))

-- Begin the transactio to update clinics at the given Id, with the given data
BEGIN
    UPDATE `Clinics`
    SET `address` = p_address,
    `city` = p_city,
    `state` = p_state,
    `postalCode` = p_postalCode,
    `phoneNumber`= p_phoneNumber
    WHERE `clinicId` = p_clinicId;
END / /
DELIMITER ;


-- ###################
-- UPDATE Appointments
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_update_appointment;
DELIMITER / /
-- Create the procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_appointment`(
    IN p_appointmentId INT,
    IN p_dateTime DATETIME,
    IN p_clinicId INT,
    IN p_patientId INT,
    IN p_statusId INT
    )
-- Begin the transaction to update Appointments at the given Id, with the given data
BEGIN
    UPDATE `Appointments`
    SET `dateTime` = p_dateTime,
    `clinicId` = p_clinicId,
    `patientId`= p_patientId,
    `statusId` = p_statusId
    WHERE `appointmentId` = p_appointmentId;
END / /
DELIMITER ;


-- ###################
-- UPDATE AppointmentsTests
-- ####################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_update_appointmenttest;
DELIMITER / /

-- Create the stored procedure with the appropriate variables
CREATE PROCEDURE `sp_update_appointmenttest`(
    IN p_appointmentTestId INT,
    IN p_appointmentId INT,
    IN p_testId INT,
    IN p_testResultId INT
    )
-- Begin the transaction to update appointmentstests at the given Id, with the given data
BEGIN
    UPDATE `AppointmentsTests`
    SET `appointmentId` = p_appointmentId,
    `testId` = p_testId,
    `testResultId`= p_testResultId
    WHERE `appointmentTestId` = p_appointmentTestId;
END / /
DELIMITER ;


-- ###################
-- UPDATE Statuses
-- ####################

-- Drop the stored procedure if it already exists 
DROP PROCEDURE IF EXISTS sp_update_status;
DELIMITER / /

-- Create the procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_status`(
    IN p_statusId INT,
    IN p_status VARCHAR(45))

-- Begin the transaction to update Statuses at the given Id, with the given data
BEGIN
    UPDATE `Statuses`
    SET `status` = p_status
    WHERE `statusId` = p_statusid;
END / /
DELIMITER ;


-- ###################
-- UPDATE Results
-- ####################

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS sp_update_result;
DELIMITER / /

-- Create the stored procedure with the appropriate variables 
CREATE PROCEDURE `sp_update_result`(
    IN p_resultId INT,
    IN p_result VARCHAR(45))
-- Begin the transaction to update Results at the given id, with the given data 
BEGIN
    UPDATE `Results`
    SET `result` = p_result
    WHERE `testResultId` = p_resultId;
END / /
DELIMITER ;



