/** Drop the load database sp, if it already exits **/
DROP PROCEDURE  IF EXISTS sp_load_clinicdb;

/** Change the delimiter to // **/
DELIMITER //
/** Create the sp **/
CREATE PROCEDURE sp_load_clinicdb()
BEGIN

    /**Set foreign key checks to zero, so that existing tables can be deleted without foreign key conflicts **/
    SET FOREIGN_KEY_CHECKS = 0;


    /** Drop tables if it exists **/
    DROP TABLE IF EXISTS `AppointmentsTests`;
    DROP TABLE IF EXISTS `Appointments`;
    DROP TABLE IF EXISTS `Patients`;
    DROP TABLE IF EXISTS `Clinics`;
    DROP TABLE IF EXISTS `Statuses`;
    DROP TABLE IF EXISTS `Results`;
    DROP TABLE IF EXISTS `Tests`;

    /** Disable autocommiting so that all transactions are completed at once, or rolled back if there is an error **/
    SET AUTOCOMMIT = 0;

    /** Start the transaction, to allow rollback if needed **/
    START TRANSACTION;


    /**Create the Clinics table. Represents the location of a clinic where appointments take place. **/
    CREATE TABLE `Clinics` (
        `clinicId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `address` varchar(45) NOT NULL,
        `city` varchar(45) NOT NULL,
        `state` char(2) NOT NULL,
        `postalCode` varchar(5) NOT NULL,
        `phoneNumber` char(12) DEFAULT NULL,
        PRIMARY KEY (`clinicId`),
        CONSTRAINT full_address UNIQUE (`address`,`city`,`state`, `postalCode`)
    );




    /**Insert example data into Clinics. **/
    INSERT INTO `Clinics` (`address`, `city`, `state`, `postalCode`, `phoneNumber`)
    VALUES ('123 Main Street', 'Seattle', 'WA', '12345', '888-123-4567'),
    ('789 Lincoln Avenue', 'Tacoma', 'WA', '23456', '888-234-5678'),
    ('456 South Street', 'Phoenix', 'AZ', '34567', '888-345-6789');




    /**Create the Patients table. Represents a patient who may make an appointment at a clinic. **/
    CREATE TABLE `Patients` (
        `patientId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `firstName` varchar(45) NOT NULL,
        `lastName` varchar(45) NOT NULL,
        `phoneNumber` char(12) NOT NULL,
        `email` varchar(150) NOT NULL,
        `dateOfBirth` DATE NOT NULL,
        `gender` ENUM('Male','Female','Unknown') NOT NULL,
        `clinicId` int,
        PRIMARY KEY (`patientId`),
        FOREIGN KEY (`clinicId`) REFERENCES Clinics(clinicId) ON DELETE SET NULL
    );




    /**Insert example data into Patients. **/
    INSERT INTO `Patients` (`firstName`, `lastName`, `phoneNumber`, `email`, `dateOfBirth`, `gender`, `clinicId`)
    VALUES (
    'John',
    'Smith',
    '123-456-7890',
    'johnsmith@gmail.com',
    '1990-01-01',
    'Male',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '123 Main Street, Seattle, WA')),
    ('Mary',
    'Smith',
    '222-555-8888',
    'marysmith@gmail.com',
    '1995-12-31',
    'Female',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '789 Lincoln Avenue, Tacoma, WA')),
    ('Adam',
    'Doe',
    '111-333-9999',
    'adamdoe@gmail.com',
    '1988-07-04',
    'Male',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '123 Main Street, Seattle, WA'));




    /**Create the Statuses table. Represents an appointment status. Each status (Scheduled, Walk In, No Show, Cancelled, Complete) is represented by a specific statusId. **/
    CREATE TABLE `Statuses` (
        `statusId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `status` varchar(45) NOT NULL UNIQUE,
        PRIMARY KEY (`statusId`)
    );




    /**Insert statuses into the Statuses table**/
    INSERT INTO `Statuses` (`status`)
    VALUES ('Scheduled'),
    ('Walk In'),
    ('No Show'),
    ('Cancelled'),
    ('Completed');




    /**Create the Appointments table. Represents an appointment for a patient**/
    CREATE TABLE `Appointments` (
        `appointmentId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `dateTime` datetime NOT NULL,
        `clinicId` int NOT NULL,
        `patientId` int NOT NULL,
        `statusId` int NOT NULL,
        PRIMARY KEY (`appointmentId`),
        FOREIGN KEY (`statusId`) REFERENCES Statuses(statusId) ON DELETE RESTRICT,
        FOREIGN KEY (`clinicId`) REFERENCES Clinics(clinicId) ON DELETE CASCADE,
        FOREIGN KEY (`patientId`) REFERENCES Patients(patientId) ON DELETE RESTRICT
    );






    /**Insert example data in the Appointments table**/
    INSERT INTO `Appointments` (`dateTime`, `clinicId`, `patientId`, `statusId`)
    VALUES (
    '2025-04-23 09:00:00',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '123 Main Street, Seattle, WA'),
    (SELECT patientId FROM Patients WHERE firstName = 'John' AND lastName = 'Smith' AND email = 'johnsmith@gmail.com'),
    (SELECT statusId FROM Statuses WHERE status = 'Completed')),
    ('2025-05-05 11:30:00',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '123 Main Street, Seattle, WA'),
    (SELECT patientId FROM Patients WHERE firstName = 'Adam' AND lastName = 'Doe' AND email = 'adamdoe@gmail.com'),
    (SELECT statusId FROM Statuses WHERE status = 'Scheduled')),
    ('2025-05-05 11:30:00',
    (SELECT clinicId FROM Clinics WHERE CONCAT(address, ', ', city, ', ', state) = '789 Lincoln Avenue, Tacoma, WA'),
    (SELECT patientId FROM Patients WHERE firstName = 'John' AND lastName = 'Smith' AND email = 'johnsmith@gmail.com'),
    (SELECT statusId FROM Statuses WHERE status = 'Scheduled'));




    /**Create the Tests table. Represents a test that a patient may take during an appointment at a clinic. **/
    CREATE TABLE `Tests` (
        `testId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `name` varchar(45) UNIQUE NOT NULL,
        PRIMARY KEY (`testId`)
    );




    /**Insert example data into the Tests table**/
    INSERT INTO `Tests` (`name`)
    VALUES ('TB Screening'),
    ('HIV Antibody Testing'),
    ('Influenza / Covid testing');


    /**Create the Results table. Represents the results of a test performed during an appointment. **/
    CREATE TABLE `Results` (
        `testResultId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `result` varchar(45) NOT NULL UNIQUE,
        PRIMARY KEY (`testResultId`)
    );




    /**Insert possible test results into the Results table. **/
    INSERT INTO `Results` ( `result`)
    VALUES ('positive'),
    ('negative'),
    ('invalid');




    /**Create the AppointmentsTests table. Represents the M:N relationship between appointments and tests. Each appointmentTest is also associated with one test result. **/
    CREATE TABLE `AppointmentsTests` (
        `appointmentTestId` int NOT NULL UNIQUE AUTO_INCREMENT,
        `appointmentId` int,
        `testId` int NOT NULL,
        `testResultId` int NULL,
        PRIMARY KEY (`appointmentTestID`),
        FOREIGN KEY (`appointmentId`) REFERENCES Appointments(appointmentId) ON DELETE SET NULL,
        FOREIGN KEY (`testId`) REFERENCES Tests(testId) ON DELETE CASCADE,
        FOREIGN KEY (`testResultId`) REFERENCES Results(testResultId) ON DELETE RESTRICT
        );




    /** Insert example data into the Appointments_Tests table. **/
    INSERT INTO `AppointmentsTests` (`appointmentId`, `testId`, `testResultId`)
    VALUES ((SELECT appointmentId FROM Appointments WHERE dateTime = '2025-04-23 09:00:00' AND clinicId = (SELECT clinicId FROM Clinics WHERE address = '123 Main Street' AND city = 'Seattle' AND state = 'WA')),
    (SELECT TestId FROM Tests WHERE name = 'Influenza / Covid testing'),
    (SELECT testResultId FROM Results WHERE result = 'negative')),
    ((SELECT appointmentId FROM Appointments WHERE dateTime ='2025-05-05 11:30:00' AND clinicId = (SELECT clinicId FROM Clinics WHERE address = '789 Lincoln Avenue' AND city = 'Tacoma' AND state ='WA')),
    (SELECT TestId FROM Tests WHERE name = 'HIV Antibody Testing'),
    (SELECT testResultId FROM Results WHERE result = 'negative')),
    ((SELECT appointmentId FROM Appointments WHERE dateTime = '2025-05-05 11:30:00' AND clinicId = (SELECT clinicId FROM Clinics WHERE address = '123 Main Street' AND city = 'Seattle' AND state = 'WA')),
    (SELECT TestId FROM Tests WHERE name = 'Influenza / Covid testing'),
    (SELECT testResultId FROM Results WHERE result = 'Positive'));



    /** change foreign key checks back to 1, so database integrity is maintained. Commit the changes **/
    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;

/** end the transaction **/
END //

/** Set the delimeter back to ; **/
DELIMITER ;

