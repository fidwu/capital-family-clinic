/** Get all clinic information **/
SELECT clinicId AS `Clinic ID`, 
address AS `Address`, 
city AS `City`, 
state AS `State`, 
postalCode AS `Postal Code`, 
phoneNumber AS `Phone Number` 
FROM Clinics;

/** Get a single clinic’s data for the update clinic form **/
SELECT clinicId, address, city, state, postalCode, phoneNumber
FROM Clinics
WHERE clinicId = @clinic_id_selected_from_clinics_page;

/** Create new clinic **/
INSERT INTO `Clinics` (`address`, `city`, `state`, `postalCode`, `phoneNumber`)
VALUES (@addressInput, @cityInput, @stateInput, @postalCodeInput, @phoneNumberInput);

/** Update clinic **/ 
UPDATE `Clinics`
SET address = @address, city = @city, postalCode = @postalCode, phoneNumber = @phoneNumber
WHERE clinicId = @clinicId_to_update;

/** Delete clinic **/
DELETE FROM `Clinics`
WHERE clinicId = @clinicId_to_delete;


/** Get all patient information **/
SELECT patientId AS `Patient ID`, 
firstName AS `First Name`, 
lastName AS `Last Name`, 
Patients.phoneNumber AS `Phone Number`,
email AS `Email`, 
DATE_FORMAT(dateOfBirth, '%m/%d/%Y') AS `Date Of Birth`, 
gender AS `Gender`, 
CONCAT('Capital Family Clinic at ', Clinics.address, ',  ', Clinics.city, ', ', Clinics.state) AS `Primary Clinic`
FROM Patients
LEFT JOIN Clinics ON Patients.clinicId = Clinics.clinicId;

/** Add new patient **/
INSERT INTO `Patients` (`firstName`, `lastName`, `phoneNumber`, `email`, `dateOfBirth`, gender, clinicId)
VALUES (@firstNameInput, @lastNameInput, @phoneNumberInput, @emailInput, @dateOfBirthInput, @genderInput, @clinicId_from_dropdown);

/** Get a single patient’s data for the update patient form **/
SELECT patientId, firstName, lastName, phoneNumber, email, dateOfBirth, gender, clinicId
FROM Patients
WHERE patientId = @patient_id_selected_from_clinics_page;

/**  Update patient **/
UPDATE `Patients`
SET firstName = @firstNameInput, lastName = @lastNameInput, email = @emailInput, dateOfBirth = @dateOfBirthInput, gender = @genderInput, clinicId = @clinicId_from_dropdown
WHERE patientId = @patientId_to_update;

/** Note: cannot delete patient **/

/** Get all statuses **/
SELECT statusId AS `Status ID`, status AS `Status` 
FROM Statuses 
ORDER BY statusId;

/** Get a status for the update status form **/
SELECT statusId, status
FROM Statuses
WHERE statusId = @status_id_selected_from_statuses_page;


/** Update statuses **/ 
UPDATE `Statuses`
SET status = @statusInput
WHERE statusId = @statusId_to_update;

/** Note: cannot add or delete a status **/

/** Get all tests **/
SELECT testId AS `Test ID`, name AS `Name` 
FROM Tests 
ORDER BY testId;

/** Create new test **/
INSERT INTO `Tests` (`name`) 
VALUES (@name_of_new_test);

/** Update a test name **/
UPDATE `Tests`
SET name = @updated_name_of_test
WHERE testId = @testId_to_rename;

/** Delete a test **/
DELETE FROM `Tests`
WHERE testId = @testId_to_delete;

/** Get all results **/
SELECT Results.testResultId AS `Test Result ID`, 
Results.result AS `Result` 
FROM Results 
ORDER BY testResultId;

/** Note: Cannot add or delete a result **/

/** Update result result **/
UPDATE `Results`
SET result = @result_input
WHERE resultId = @resultId_to_rename;


/** Get all appointments **/
SELECT appointmentId AS `Appointment ID`,
DATE_FORMAT(dateTime, '%%m/%%d/%%Y %%h:%%i %%p') AS `Appointment Date Time`,
CONCAT('Capital Family Clinic at ', Clinics.address, ', ', Clinics.city, ', ', Clinics.state) AS `Clinic`,
CONCAT(Patients.firstName, ' ', Patients.lastName) AS `Patient Name`,
Statuses.status AS `Appointment Status`
FROM Appointments
JOIN Patients ON Appointments.patientId = Patients.patientId
JOIN Statuses ON Appointments.statusId = Statuses.statusId
JOIN Clinics ON Appointments.clinicId = Clinics.clinicId
ORDER BY appointmentId;

/** Get Appointment to Update **/ 
SELECT appointmentId, dateTime, clinicId, patientId, statusId
FROM Appointments
WHERE appointmentId = @Id_of_appointment_to_update;

/** Insert into appointments **/
INSERT INTO `Appointments` (`dateTime`, `clinicId`,`patientId`,`statusId`)
VALUES(@dateTimeInput,@clinicId_from_dropdown,@patientId_from_dropdown, @statusId_from_dropdown);

/** Update an appointment **/
UPDATE `Appointments`
SET dateTime= @dateTime, clinicId=@clinicId, patientId=@patientId, statusId=@statusId
WHERE appointmentId=@appointmentId;

/** Delete an appointment **/
DELETE FROM `Appointments`
WHERE appointmentId = @appointmentId_to_delete;

/** Change an appointment status to complete **/
UPDATE `Appointments`
SET statusId= 5
WHERE appointmentId=@appointmentId;

/** Get AppointmentsTests information, Represented in the UI as Scheduled Tests **/
SELECT AppointmentsTests.appointmentTestId AS `Scheduled Test ID`,
CONCAT(Patients.firstName, ' ', Patients.lastName) AS `Patient Name`,
CONCAT('Capital Family Clinic at ', Clinics.address, ', ', Clinics.city, ', ', Clinics.state) AS `Clinic`,
DATE_FORMAT(Appointments.dateTime, '%%m/%%d/%%Y %%h:%%i %%p') AS `Appointment Date Time`,
Tests.name AS `Test Name`,
Results.result AS `Test Result`
FROM AppointmentsTests
LEFT JOIN Appointments on AppointmentsTests.appointmentId = Appointments.appointmentId
LEFT JOIN Patients on Appointments.patientId = Patients.patientId
JOIN Tests on AppointmentsTests.testId = Tests.testID
LEFT JOIN Results on AppointmentsTests.testResultId = Results.testResultId
LEFT JOIN Clinics ON Appointments.clinicId = Clinics.clinicId
ORDER BY appointmentTestId;

/** Create new AppointmentsTests **/
INSERT INTO `AppointmentsTests` (`appointmentId`, `testId`, `testResultId`)
VALUES (@appointmentId_from_dropdown, @testId_from_dropdown, @testResultId_from_dropdown);

/** Note: Cannot delete directly from AppointmentsTests. AppointmentsTests may only be deleted by deleting the associated Test **/




