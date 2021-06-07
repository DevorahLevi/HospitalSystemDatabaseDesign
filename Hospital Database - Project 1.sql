/*

Author: Devorah Levi

Scenario 7: Hospital

    This should track data for a hospital.  This includes doctors, patients, appointments, rooms, etc.  
    It should also include all significant equipment/machinery (e.g., MRI machines, but not stethoscopes).  
    For appointments, this should include all relevant information, including what doctors, rooms, and/or equipment needs to be booked.

-------------------
-- List of Tables:
-------------------

Hospital
    Branch (hospital can have multiple locations)
        Department
            Position
                Employee
                PayScale
        Room
        Appointment
            Equipment
Insurance
    Patient

Person -->
    Employee
    Patient   

*/


DROP DATABASE IF EXISTS hospital_database_project1;
CREATE DATABASE hospital_database_project1;

USE hospital_database_project1;

GRANT SELECT,INSERT,UPDATE,DELETE ON hospital_database_project1.*
TO hospital_database_project1_l@localhost IDENTIFIED BY 'changeme'; -- _l stands for 'limited'

        
-- TABLES --

/* Defines a person; Associated with employees and patients. */
CREATE TABLE Person (
    personID                    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    lastName                    VARCHAR(255) NOT NULL,
    firstName                   VARCHAR(255) NOT NULL,
    dateOfBirth                 DATE NOT NULL,
    homeAddress                 VARCHAR(255) NOT NULL, 
    city                        VARCHAR(255) NOT NULL,
    zipCode                     MEDIUMINT UNSIGNED NOT NULL,
    homeState                   VARCHAR(2) NOT NULL COMMENT 'Two-Letter State Abbreviation',
    INDEX (dateOfBirth),
    INDEX (lastName),
    PRIMARY KEY (personID)
) Engine = InnoDB;

/* Defines a Hospital Institution with possibility for multiple branches. */
CREATE TABLE Hospital (
    hospitalID                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    companyName                 VARCHAR(255) NOT NULL,
    INDEX (companyName),
    PRIMARY KEY (hospitalID)
) Engine = InnoDB;

/* Represents a specific branch of a given Hospital Institution. */
CREATE TABLE Branch (
    branchID                    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    hospitalID                  INT UNSIGNED NOT NULL,
    branchName                  VARCHAR(255) NOT NULL,
    homeAddress                 VARCHAR (255) NOT NULL,
    city                        VARCHAR(255) NOT NULL,
    zipCode                     MEDIUMINT UNSIGNED NOT NULL,
    homeState                   VARCHAR(255) NOT NULL,
    numberOfFloors              TINYINT UNSIGNED NOT NULL DEFAULT 1,
    numberOfRooms               SMALLINT UNSIGNED NOT NULL,
    INDEX (branchName),
    PRIMARY KEY (branchID)
) Engine = InnoDB;

/* Defines different departments that a hospital has. */
CREATE TABLE Department (
    departmentID                INT UNSIGNED NOT NULL AUTO_INCREMENT,
    departmentName              VARCHAR(255) NOT NULL,
    departmentDescription       TEXT,
    INDEX (departmentName),     
    PRIMARY KEY (departmentID)
) Engine = InnoDB;

/* Defines different positions within the departments. */
CREATE TABLE Position (
    positionID                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    departmentID                INT UNSIGNED NOT NULL,
    title                       VARCHAR(255) NOT NULL,
    uniform                     TEXT,
    positionDescription         TEXT,
    INDEX (title),
    PRIMARY KEY (positionID)
) Engine = InnoDB;

/* Defines an employee that is working for a hospital. Points to a record in the Person table. */
CREATE TABLE Employee (
    employeeID                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    personID                    INT UNSIGNED NOT NULL,
    managerID                   INT UNSIGNED COMMENT 'Points to other employees in order to portray who reports to who (null implies no superiority)',
    positionID                  INT UNSIGNED NOT NULL,
    shift                       SET ('Morning Shift', 'Afternoon Shift', 'Night Shift'),

    emergencyContact1Name       TEXT,
    emergencyContact1Cell       TEXT,
    emergencyContact1Home       TEXT,
    emergencyContact1Address    TEXT,

    emergencyContact2Name       TEXT,
    emergencyContact2Cell       TEXT,
    emergencyContact2Home       TEXT,
    emergencyContact2Address    TEXT, 

    emergencyContact3Name       TEXT,   
    emergencyContact3Cell       TEXT,
    emergencyContact3Home       TEXT,
    emergencyContact3Address    TEXT,

    UNIQUE INDEX (personID),
    PRIMARY KEY (employeeID)
) Engine = InnoDB;

/*
CREATE TABLE PayScale (
    payScaleID                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    minAmount                   INT UNSIGNED NOT NULL,
    maxAmount                   INT UNSIGNED NOT NULL,
    PRIMARY KEY (payScaleID)
) Engine = InnoDB;
*/

/* Represents the different rooms at each branch of the hospitals. */
CREATE TABLE Room (
    roomID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,  
    branchID                    INT UNSIGNED NOT NULL,
    roomName                    VARCHAR(255),
    floorNumber                 TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (roomID)
) Engine = InnoDB;

/* Defines appointments made at each hospital. */
CREATE TABLE Appointment (
    appointmentID               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    patientID                   INT UNSIGNED NOT NULL,
    branchID                    INT UNSIGNED NOT NULL,
    roomID                      INT UNSIGNED NOT NULL,
    appointmentDateTime         DATETIME,
    appointmentLength           TINYINT UNSIGNED NOT NULL DEFAULT 30 COMMENT 'IN MINUTES',
    appointmentPurpose          TEXT NOT NULL,
    equipmentNeeded             TEXT,
    INDEX (roomID),
    INDEX (patientID),
    PRIMARY KEY (appointmentID)
) Engine = InnoDB;

/* Represents different equipment used by each hospital and each branch. */
CREATE TABLE Equipment (
    equipmentID                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    branchID                    INT UNSIGNED NOT NULL,
    appointmentID               INT UNSIGNED COMMENT 'To be updated when booked for new appointment. Available if null.',
    equipmentName               VARCHAR(255) NOT NULL,
    equipmentType               VARCHAR(255) NOT NULL,
    equipmentWeight             INT UNSIGNED NOT NULL COMMENT 'IN LBS.',
    serialNumber                VARCHAR(255) NOT NULL,
    datePurchased               DATE NOT NULL,
    INDEX (equipmentName),
    INDEX (serialNumber),
    PRIMARY KEY (equipmentID)
) Engine = InnoDB;

/* Defines the possible insurances that a patient could have. */
CREATE TABLE Insurance (
    insuranceID                 INT UNSIGNED NOT NULL,
    insuranceName               VARCHAR(255) NOT NULL,
    INDEX (insuranceName),
    PRIMARY KEY (insuranceID)
) Engine = InnoDB;

/* Represents a patient of a hospital. Points to a record in the Person table. */
CREATE TABLE Patient (
    patientID                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    personID                    INT UNSIGNED NOT NULL,
    insuranceID                 INT UNSIGNED NOT NULL, 
    height                      TINYINT UNSIGNED NOT NULL COMMENT 'IN INCHES',
    patientWeight               TINYINT UNSIGNED NOT NULL COMMENT 'IN LBS.',
    
    medicineAllergies           TEXT DEFAULT NULL,
    foodAllergies               TEXT DEFAULT NULL,
    otherAllergies              TEXT DEFAULT NULL, 
    currentMedications          TEXT DEFAULT NULL,
    
    emergencyContact1Name       TEXT,
    emergencyContact1Cell       TEXT,
    emergencyContact1Home       TEXT,
    emergencyContact1Address    TEXT,

    emergencyContact2Name       TEXT,
    emergencyContact2Cell       TEXT,
    emergencyContact2Home       TEXT,
    emergencyContact2Address    TEXT, 

    emergencyContact3Name       TEXT,   
    emergencyContact3Cell       TEXT,
    emergencyContact3Home       TEXT,
    emergencyContact3Address    TEXT,

    UNIQUE INDEX (personID),
    PRIMARY KEY (patientID)
) Engine = InnoDB;



-- LINKING TABLES --

CREATE TABLE Branch_Department (
    branchID                    INT UNSIGNED NOT NULL,
    departmentID                INT UNSIGNED NOT NULL,
    PRIMARY KEY (branchID, departmentID)
) Engine = InnoDB;

CREATE TABLE Hospital_Insurance (
    hospitalID                  INT UNSIGNED NOT NULL,
    insuranceID                 INT UNSIGNED NOT NULL,
    PRIMARY KEY (hospitalID, insuranceID)
) Engine = InnoDB;

CREATE TABLE Hospital_Department (
    hospitalID                  INT UNSIGNED NOT NULL,
    departmentID                INT UNSIGNED NOT NULL,
    PRIMARY KEY (hospitalID, departmentID)
) Engine = InnoDB;

CREATE TABLE Appointment_Employee (
    appointmentID               INT UNSIGNED NOT NULL,
    employeeID                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (appointmentID, employeeID)
) Engine = InnoDB;


----------------
-- FOREIGN KEYS
----------------

-- Linking Table Foreign Keys --

ALTER TABLE Branch_Department ADD FOREIGN KEY (branchID)
REFERENCES Branch (branchID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Branch_Department ADD FOREIGN KEY (departmentID)
REFERENCES Department (departmentID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Hospital_Insurance ADD FOREIGN KEY (hospitalID)
REFERENCES Hospital (hospitalID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Hospital_Insurance ADD FOREIGN KEY (insuranceID)
REFERENCES Insurance (insuranceID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Hospital_Department ADD FOREIGN KEY (hospitalID)
REFERENCES Hospital (hospitalID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Hospital_Department ADD FOREIGN KEY (departmentID)
REFERENCES Department (departmentID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Appointment_Employee ADD FOREIGN KEY (appointmentID)
REFERENCES Appointment (appointmentID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Appointment_Employee ADD FOREIGN KEY (employeeID)
REFERENCES Employee (employeeID) ON DELETE CASCADE ON UPDATE CASCADE;


-- Table Foreign Keys --

ALTER TABLE Branch ADD FOREIGN KEY (hospitalID)
REFERENCES Hospital (hospitalID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Position ADD FOREIGN KEY (departmentID)
REFERENCES Department (departmentID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Employee ADD FOREIGN KEY (personID)
REFERENCES Person (personID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Employee ADD FOREIGN KEY (managerID)
REFERENCES Employee (employeeID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Employee ADD FOREIGN KEY (positionID)
REFERENCES Position (positionID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Room ADD FOREIGN KEY (branchID)
REFERENCES Branch (branchID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Appointment ADD FOREIGN KEY (patientID)
REFERENCES Patient (patientID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Appointment ADD FOREIGN KEY (branchID)
REFERENCES Branch (branchID) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Appointment ADD FOREIGN KEY (roomID)
REFERENCES Room (roomID) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Equipment ADD FOREIGN KEY (branchID)
REFERENCES Branch (branchID) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Equipment ADD FOREIGN KEY (appointmentID)
REFERENCES Appointment (appointmentID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Patient ADD FOREIGN KEY (personID)
REFERENCES Person (personID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Patient ADD FOREIGN KEY (insuranceID)
REFERENCES Insurance (insuranceID) ON DELETE NO ACTION ON UPDATE CASCADE;



/*

---------------------
-- REQUIRED QUERIES
---------------------

MySQL project queries

When you turn in your project, please include the following queries. 
If your database is unable to support any of these queries (i.e,. it lacks requisite information or relationships), 
then you may need to first make revisions to your data model.

*/

-- Compute a full list of all staff for a particular location, including specialization (if any).

SELECT e.employeeID, CONCAT(p.firstName, " ", p.lastName) AS employee_name, Position.positionID, Position.title AS position_title, d.departmentID, d.departmentName
FROM Employee AS e, Person AS p, Branch AS b, Position, Department AS d, Branch_Department as bd
WHERE e.personID = p.personID AND 
        Position.positionID = e.positionID AND
        Position.departmentID = d.departmentID AND 
        bd.branchID = b.branchID AND 
        bd.departmentID = d.departmentID AND 
        b.branchID = 1;

-- List all appointments scheduled for the next month.

SELECT a.appointmentID, a.appointmentDateTime, a.appointmentPurpose, a.appointmentLength, b.branchID, b.branchName, 
        r.roomID, r.roomName, a.patientID, CONCAT(Person.firstName, " ", Person.lastName) AS patient_name
FROM Appointment AS a, Person, Patient, Branch AS b,  Room AS r
WHERE a.patientID = Patient.patientID AND
        Patient.personID = Person.personID AND 
        a.branchID = b.branchID AND
        a.roomID = r.roomID AND
        a.appointmentDateTime BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY);        

-- List all hospital staff who participated in a surgery, identified by the date, as well as the patient's first and last name.
SELECT CONCAT(person_employee.firstName, " ", person_employee.lastName) AS employee_name, a.appointmentDateTime AS date_of_surgery, 
        CONCAT (person_patient.firstName, " ", person_patient.lastName) AS patient_name
FROM Appointment AS a, Appointment_Employee as ae, Employee AS e, Patient AS p, Person AS person_employee, Person AS person_patient
WHERE a.appointmentPurpose = "Surgery" AND
        ae.appointmentID = a.appointmentID AND
        ae.employeeID = e.employeeID AND
        a.patientID = p.patientID AND
        e.personID = person_employee.personID AND
        p.personID = person_patient.personID;


-----------------------------------
-- INSERTING FAKE DATA FOR TESTING
-----------------------------------

INSERT INTO Person (personID, lastName, firstName, dateOfBirth, homeAddress, city, zipCode, homeState)
VALUES
    (1, "Doe", "John", "2000-12-1", "2800 California Street", "Chicago", 60645, "IL"), 
    (2, "Nye", "Bill", "2001-11-3", "3212 Chase Street", "Chicago", 60645, "IL"),
    (3, "Dane", "Jack", "1954-03-12", "15 Smoley Drive", "Chicago", 43254, "IL"),
    (4, "Deere", "Jane", "1999-10-28", "233 Pratt Street", "Chicago", 23454, "IL"),
    (5, "Adams", "Douglas", "1976-01-23", "5432 Crawford Street", "Chicago", 60076, "IL"),
    (6, "Smith", "Lawrence", "2005-12-05", "1111 Caldwell Street", "Atlanta", 60545, "GA"),
    (7, "Wheeler", "Stephen", "1998-09-09", "1120 Lawndale Street", "Atlanta", 23676, "GA"),
    (8, "DeJulius", "Joe", "1950-05-23", "7061 Kedzie Avenue", "Atlanta", 76543, "GA"),
    (9, "Bjork", "Dawn", "2010-01-01", "34 Kenton Street", "Monsey", 23542, "NY"),
    (10, "Reschke", "Joy", "2008-12-25", "543 Sesame Street", "Brooklyn", 12345, "NY"),
    (11, "Doe", "Jane", "2013-07-04", "1234 Example Avenue", "Chicago", 45677, "IL"),
    (12, "Allen", "Joe", "2010-01-19", "2341 Lunt Street", "Chicago", 83726, "IL"),
    (13, "Meadow", "Sam", "1964-09-23", "6600 Mozart", "Chicago", 23456, "IL"),
    (14, "McConville", "Katie", "2000-09-08", "6715 Richmond", "Chicago", 60645, "IL");

INSERT INTO Hospital (hospitalID, companyName)
VALUES
    (1, "North Shore"), 
    (2, "Rejuvenate"), 
    (3, "Care One");

INSERT INTO Branch (branchID, hospitalID, branchName, homeAddress, city, zipCode, homeState, numberOfFloors, numberOfRooms)
VALUES
    (1, 1, "Evanston Hospital", "613 Sellow Avenue", "Chicago", 60645, "IL", 12, 120),
    (2, 1, "Swedish Hospital", "4566 Stone Boulevard", "Atlanta", 43234, "GA", 25, 250),
    (3, 1, "Ann & Robert Lurie Children's Hospital", "23 Stone Drive", "Brooklyn", 56987, "NY", 35, 350);

INSERT INTO Department (departmentID, departmentName, departmentDescription)
VALUES
    (1, "Oncology", "Medical oncologists aim to provide the best possible outcome for cancer patients, 
                    whether that is cure, or palliation and prolongation of good quality life. 
                    They also provide counselling for patients and their families."),
    (2, "Internal Medicine", "Internal medicine or general internal medicine (in Commonwealth nations) is the medical specialty dealing with the prevention, 
                            diagnosis, and treatment of internal diseases. Physicians specializing in internal medicine are called internists, 
                            or physicians (without a modifier) in Commonwealth nations."),
    (3, "Anesthesiology", "Anesthesiologists assess patients, make diagnoses, provide support for breathing and circulation, 
                        and help to ensure that infection is prevented. Anesthesiologists are also qualified to contribute to emergency medicine, 
                        providing airway and cardiac resuscitation and support and advanced life support, as well as pain control."),
    (4, "Surgery", "Hospital department which administers all departmental functions and the provision of surgical diagnostic and therapeutic services."),
    (5, "Pediatrics", "Pediatrics is the branch of medicine dealing with the health and medical care of infants, 
                    children, and adolescents from birth up to the age of 18.");

INSERT INTO Position (positionID, departmentID, title)
VALUES
    (1, 2, "General Practitioner"),
    (2, 4, "Surgeon"),
    (3, 5, "Nurse"),
    (4, 3, "Anesthesiologist"),
    (5, 1, "Hematologist");

INSERT INTO Employee (employeeID, personID, positionID)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5),
    (6, 6, 3),
    (7, 7, 1),
    (8, 8, 5),
    (9, 9, 3),
    (10, 10, 1);

INSERT INTO Room (roomID, branchID, roomName)
VALUES
    (1, 1, "Exam Room 1"),
    (2, 1, "Exam Room 2"),
    (3, 1, "Exam Room 3"),
    (4, 1, "Surgery Room 1"),
    (5, 1, "Surgery Room 2"), 
    (6, 2, "Exam Room 1"),
    (7, 2, "Exam Room 2"),
    (8, 2, "Surgery Room 1"),
    (9, 3, "Exam Room 1");

INSERT INTO Insurance (insuranceID, insuranceName)
VALUES
    (1, "Blue Cross Blue Shield"),
    (2, "Humana");

INSERT INTO Patient (patientID, personID, insuranceID, height, patientWeight)
VALUES
    (1, 11, 2, 65, 140),
    (2, 12, 1, 70, 188),
    (3, 13, 2, 68, 155),
    (4, 14, 1, 60, 120);

INSERT INTO Equipment (equipmentID, branchID, equipmentName, equipmentType, equipmentWeight, serialNumber, datePurchased)
VALUES
    (1, 1, "MRI Machine", "Scanner", 80000, "qWfqzGbf", "2020-11-28"),
    (2, 1, "Defibrillators", "CPR Equipement", 5, "fFhBoqiS", "2020-11-28"),
    (3, 1, "Stretcher", "Patient Transport", 140, "qwy8LrEp", "2020-11-28"),
    (4, 2, "MRI Machine", "Scanner", 80000, "XUbdtvkh", "2020-11-28"),
    (5, 2, "Defibrillators", "CPR Equipement", 5, "eRKTcd8D", "2020-11-28"),
    (6, 2, "Stretcher", "Patient Transport", 140, "mTPMhgaQ", "2020-11-28"),
    (7, 3, "MRI Machine", "Scanner", 80000, "UGhLBtUc", "2020-11-28"),
    (8, 3, "Defibrillators", "CPR Equipement", 5, "eBFWHgYp", "2020-11-28"),
    (9, 3, "Stretcher", "Patient Transport", 140, "rdRqvwqZ", "2020-11-28");
    
INSERT INTO Appointment (appointmentID, patientID, branchID, roomID, appointmentDateTime, appointmentPurpose)
VALUES
    (1, 1, 1, 1, "2021-03-21 11:00:00", "Follow-Up"),
    (2, 2, 1, 2, "2020-12-15 12:30:00", "Check-up"),
    (3, 3, 1, 3, "2020-12-13 02:30:00", "Broken Leg"),
    (4, 4, 1, 4, "2020-12-12 03:00:00", "Surgery"),
    (5, 3, 1, 5, "2020-12-16 05:30:00", "Surgery"),
    (6, 1, 1, 1, "2020-12-25 12:00:00", "Check-up"),
    (7, 2, 1, 2, "2021-01-05 01:30:00", "Follow-Up"), 
    (8, 3, 1, 3, "2021-05-16 11:45:00", "Follow-up");

INSERT INTO Branch_Department (branchID, departmentID)
VALUES 
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5);

INSERT INTO Hospital_Insurance (hospitalID, insuranceID)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (3, 1),
    (3, 2);

INSERT INTO Hospital_Department
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5);

INSERT INTO Appointment_Employee
VALUES  
    (1, 1),
    (1, 5),
    (2, 1),
    (3, 5),
    (3, 6),
    (3, 7),
    (3, 8),
    (4, 2),
    (4, 3),
    (4, 4),
    (5, 8),
    (5, 9);
