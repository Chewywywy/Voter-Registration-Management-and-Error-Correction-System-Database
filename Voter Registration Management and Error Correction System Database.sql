CREATE TABLE `voters` (
  `voter_id` int PRIMARY KEY AUTO_INCREMENT,
  `national_id` varchar(20) UNIQUE NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100),
  `last_name` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` varchar(10),
  `address_line` varchar(255),
  `contact_number` varchar(20),
  `email` varchar(100),
  `precinct_id` int,
  `registration_status` varchar(20) DEFAULT 'ACTIVE' COMMENT 'ACTIVE, PENDING, FLAGGED, INACTIVE',
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `precincts` (
  `precinct_id` int PRIMARY KEY AUTO_INCREMENT,
  `precinct_code` varchar(20) UNIQUE NOT NULL,
  `precinct_name` varchar(150) NOT NULL,
  `polling_center_name` varchar(150) NOT NULL,
  `address` varchar(255),
  `city` varchar(100),
  `region` varchar(100),
  `capacity` int
);

CREATE TABLE `officers` (
  `officer_id` int PRIMARY KEY AUTO_INCREMENT,
  `employee_code` varchar(20) UNIQUE NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `role` varchar(50) COMMENT 'REGISTRAR, REVIEWER, SUPERVISOR',
  `precinct_id` int,
  `email` varchar(100),
  `active` boolean DEFAULT true
);

CREATE TABLE `correction_requests` (
  `request_id` int PRIMARY KEY AUTO_INCREMENT,
  `voter_id` int,
  `field_to_correct` varchar(50) NOT NULL COMMENT 'NAME, DOB, ADDRESS, GENDER, PRECINCT',
  `old_value` varchar(255),
  `new_value` varchar(255) NOT NULL,
  `reason` varchar(255),
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING, UNDER_REVIEW, APPROVED, REJECTED',
  `submitted_by` int,
  `reviewed_by` int,
  `submitted_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `reviewed_at` timestamp,
  `priority` varchar(10) DEFAULT 'NORMAL' COMMENT 'LOW, NORMAL, URGENT'
);

CREATE TABLE `verification_documents` (
  `document_id` int PRIMARY KEY AUTO_INCREMENT,
  `request_id` int,
  `document_type` varchar(50) COMMENT 'BIRTH_CERT, GOV_ID, UTILITY_BILL, AFFIDAVIT',
  `document_reference` varchar(150),
  `uploaded_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `verified` boolean DEFAULT false
);

CREATE TABLE `correction_history` (
  `history_id` int PRIMARY KEY AUTO_INCREMENT,
  `request_id` int,
  `voter_id` int,
  `field_changed` varchar(50),
  `old_value` varchar(255),
  `new_value` varchar(255),
  `changed_by` int,
  `changed_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE `voters` ADD FOREIGN KEY (`precinct_id`) REFERENCES `precincts` (`precinct_id`);

ALTER TABLE `officers` ADD FOREIGN KEY (`precinct_id`) REFERENCES `precincts` (`precinct_id`);

ALTER TABLE `correction_requests` ADD FOREIGN KEY (`voter_id`) REFERENCES `voters` (`voter_id`);

ALTER TABLE `correction_requests` ADD FOREIGN KEY (`submitted_by`) REFERENCES `voters` (`voter_id`);

ALTER TABLE `correction_requests` ADD FOREIGN KEY (`reviewed_by`) REFERENCES `officers` (`officer_id`);

ALTER TABLE `verification_documents` ADD FOREIGN KEY (`request_id`) REFERENCES `correction_requests` (`request_id`);

ALTER TABLE `correction_history` ADD FOREIGN KEY (`request_id`) REFERENCES `correction_requests` (`request_id`);

ALTER TABLE `correction_history` ADD FOREIGN KEY (`voter_id`) REFERENCES `voters` (`voter_id`);

ALTER TABLE `correction_history` ADD FOREIGN KEY (`changed_by`) REFERENCES `officers` (`officer_id`);

-- Disable foreign key checks for INSERT
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `precincts` (`precinct_id`, `precinct_code`, `precinct_name`, `polling_center_name`, `address`, `city`, `region`, `capacity`)
VALUES
  (5, 'PRC-005', 'District 5 - Central', 'Central Public Library', '15 Mabini St', 'Springfield', 'Region A', 450),
  (6, 'PRC-006', 'District 6 - Northgate', 'Northgate Barangay Hall', '3 Del Pilar St', 'Rivertown', 'Region B', 300),
  (7, 'PRC-007', 'District 7 - Lakeside', 'Lakeside National High School', '221 Magsaysay Ave', 'Lakeview', 'Region C', 700),
  (8, 'PRC-008', 'District 8 - Hilltop', 'Hilltop Multipurpose Gym', '9 Katipunan Rd', 'Lakeview', 'Region C', 380);
INSERT INTO `officers` (`officer_id`, `employee_code`, `full_name`, `role`, `precinct_id`, `email`, `active`)
VALUES
  (5, 'EMP-1005', 'Diana Fernandez', 'REVIEWER', 5, 'dfernandez@electoral.gov', TRUE),
  (6, 'EMP-1006', 'Roberto Aquino', 'REGISTRAR', 6, 'raquino@electoral.gov', TRUE),
  (7, 'EMP-1007', 'Sophia Tan', 'REVIEWER', 7, 'stan@electoral.gov', TRUE),
  (8, 'EMP-1008', 'Leo Mendoza', 'SUPERVISOR', 8, 'lmendoza@electoral.gov', TRUE),
  (9, 'EMP-1009', 'Grace Villareal', 'REVIEWER', 5, 'gvillareal@electoral.gov', FALSE);
INSERT INTO `voters` (`voter_id`, `national_id`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `gender`, `address_line`, `contact_number`, `email`, `precinct_id`, `registration_status`, `created_at`)
VALUES
  (106, 'NID-00006', 'Kristine', 'D', 'Bautistaa', '1995-03-11', 'F', '10 Rizal Ext, Lakeview', '09181234501', 'kbautista@mail.com', 7, 'FLAGGED', '2026-09-14T12:26:10'),
  (107, 'NID-00007', 'Marc', NULL, 'Salazar', '1988-09-25', 'M', '22 Bonifacio Rd, Lakeview', '09181234502', 'msalazar@mail.com', 8, 'ACTIVE', '2026-09-14T12:26:10'),
  (108, 'NID-00008', 'Patricai', 'E', 'Gomez', '1999-12-05', 'F', '5 Luna St, Springfield', '09181234503', 'pgomez@mail.com', 5, 'FLAGGED', '2026-09-14T12:26:10'),
  (109, 'NID-00009', 'Andres', NULL, 'Villanueva', '1975-06-17', 'M', '81 Mabini St, Rivertown', '09181234504', 'avillanueva@mail.com', 6, 'ACTIVE', '2026-09-14T12:26:10'),
  (110, 'NID-00010', 'Bianca', 'F', 'Ocampoo', '1992-04-29', 'F', '14 Aguinaldo St, Springfield', '09181234505', 'bocampo@mail.com', 5, 'FLAGGED', '2026-09-14T12:26:10'),
  (111, 'NID-00011', 'Rafael', NULL, 'Navarro', '1983-08-02', 'M', '67 Quezon Ave, Rivertown', '09181234506', 'rnavarro@mail.com', 6, 'ACTIVE', '2026-09-14T12:26:10'),
  (112, 'NID-00012', 'Camille', 'G', 'Ramoss', '1997-01-19', 'F', '9 Del Pilar St, Lakeview', '09181234507', 'cramos@mail.com', 8, 'FLAGGED', '2026-09-14T12:26:10'),
  (113, 'NID-00013', 'Diego', NULL, 'Castillo', '1991-10-10', 'M', '33 Pine Rd, Rivertown', '09181234508', 'dcastillo@mail.com', 6, 'ACTIVE', '2026-09-14T12:26:10'),
  (114, 'NID-00014', 'Isabel', 'H', 'Marquez', '1986-02-14', 'F', '48 Oak Ave, Springfield', '09181234509', 'imarquez@mail.com', 5, 'ACTIVE', '2026-09-14T12:26:10'),
  (115, 'NID-00015', 'Gabriel', NULL, 'Pascuall', '2001-07-22', 'M', '19 Katipunan Rd, Lakeview', '09181234510', 'gpascual@mail.com', 8, 'FLAGGED', '2026-09-14T12:26:10'),
  (116, 'NID-00016', 'Louisa', 'I', 'Domingo', '1994-11-30', 'F', '27 Magsaysay Ave, Lakeview', '09181234511', 'ldomingo@mail.com', 7, 'ACTIVE', '2026-09-14T12:26:10'),
  (117, 'NID-00017', 'Emilio', NULL, 'Fajardoo', '1980-05-08', 'M', '52 Rizal St, Springfield', '09181234512', 'efajardo@mail.com', 5, 'FLAGGED', '2026-09-14T12:26:10'),
  (118, 'NID-00018', 'Teresa', 'J', 'Valdez', '1989-03-27', 'F', '71 Bonifacio St, Springfield', '09181234513', 'tvaldez@mail.com', 5, 'ACTIVE', '2026-09-14T12:26:10'),
  (119, 'NID-00019', 'Vicente', NULL, 'Herrera', '1996-09-15', 'M', '13 Elm St, Rivertown', '09181234514', 'vherrera@mail.com', 6, 'ACTIVE', '2026-09-14T12:26:10'),
  (120, 'NID-00020', 'Natalia', 'K', 'Cruzz', '1998-12-21', 'F', '60 Luna St, Springfield', '09181234515', 'ncruz@mail.com', 5, 'FLAGGED', '2026-09-14T12:26:10'),
  (121, 'NID-00021', 'Fernando', NULL, 'Aban', '1979-01-04', 'M', '25 Main St, Springfield', '09181234516', 'faban@mail.com', 5, 'ACTIVE', '2026-09-14T12:26:10'),
  (122, 'NID-00022', 'Rosario', 'L', 'Del Rosario', '1984-06-30', 'F', '38 Pine Rd, Rivertown', '09181234517', 'rdelrosario@mail.com', 6, 'ACTIVE', '2026-09-14T12:26:10'),
  (123, 'NID-00023', 'Hector', NULL, 'Espinozaa', '1993-04-18', 'M', '44 Katipunan Rd, Lakeview', '09181234518', 'hespinoza@mail.com', 8, 'FLAGGED', '2026-09-14T12:26:10'),
  (124, 'NID-00024', 'Veronica', 'M', 'Lim', '1990-08-09', 'F', '17 Magsaysay Ave, Lakeview', '09181234519', 'vlim@mail.com', 7, 'ACTIVE', '2026-09-14T12:26:10'),
  (125, 'NID-00025', 'Alfonso', NULL, 'Guerrero', '1987-10-23', 'M', '8 Mabini St, Springfield', '09181234520', 'aguerrero@mail.com', 5, 'ACTIVE', '2026-09-14T12:26:10');
INSERT INTO `correction_requests` (`request_id`, `voter_id`, `field_to_correct`, `old_value`, `new_value`, `reason`, `status`, `submitted_by`, `reviewed_by`, `submitted_at`, `reviewed_at`, `priority`)
VALUES
  (1006, 106, 'NAME', 'Kristine D Bautistaa', 'Kristine D Bautista', 'Extra letter in surname from registration clerk error', 'PENDING', 106, NULL, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1007, 108, 'NAME', 'Patricai E Gomez', 'Patricia E Gomez', 'Transposed letters in first name', 'PENDING', 108, NULL, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1008, 110, 'NAME', 'Bianca F Ocampoo', 'Bianca F Ocampo', 'Extra letter in surname', 'UNDER_REVIEW', 110, 5, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1009, 112, 'NAME', 'Camille G Ramoss', 'Camille G Ramos', 'Duplicate letter typo', 'PENDING', 112, NULL, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1010, 115, 'NAME', 'Gabriel Pascuall', 'Gabriel Pascual', 'Double L typo from online form', 'UNDER_REVIEW', 115, 7, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1011, 117, 'NAME', 'Emilio Fajardoo', 'Emilio Fajardo', 'Extra vowel typo', 'PENDING', 117, NULL, '2026-09-14T12:26:10', NULL, 'NORMAL'),
  (1012, 120, 'NAME', 'Natalia K Cruzz', 'Natalia K Cruz', 'Extra letter typo in surname', 'APPROVED', 120, 5, '2026-09-14T12:26:10', '2026-09-14T12:26:10', 'URGENT'),
  (1013, 123, 'NAME', 'Hector Espinozaa', 'Hector Espinoza', 'Extra letter typo', 'PENDING', 123, NULL, '2026-09-14T12:26:10', NULL, 'URGENT'),
  (1014, 114, 'ADDRESS', '48 Oak Ave, Springfield', '48-B Oak Ave, Springfield', 'Unit number missing on original form', 'APPROVED', 114, 5, '2026-09-14T12:26:10', '2026-09-14T12:26:10', 'NORMAL'),
  (1015, 119, 'GENDER', 'F', 'M', 'Gender field incorrectly encoded at registration', 'REJECTED', 119, 6, '2026-09-14T12:26:10', '2026-09-14T12:26:10', 'LOW'),
  (1016, 122, 'DOB', '1984-06-30', '1984-06-13', 'Day/month swapped during data entry', 'APPROVED', 122, 6, '2026-09-14T12:26:10', '2026-09-14T12:26:10', 'NORMAL'),
  (1017, 111, 'PRECINCT', '6', '7', 'Voter relocated within district before deadline', 'PENDING', 111, NULL, '2026-09-14T12:26:10', NULL, 'NORMAL');
INSERT INTO `verification_documents` (`document_id`, `request_id`, `document_type`, `document_reference`, `uploaded_at`, `verified`)
VALUES
  (6, 1006, 'GOV_ID', 'ID-2024-0201', '2026-09-14T12:26:10', TRUE),
  (7, 1007, 'BIRTH_CERT', 'BC-2024-0455', '2026-09-14T12:26:10', FALSE),
  (8, 1008, 'GOV_ID', 'ID-2024-0287', '2026-09-14T12:26:10', TRUE),
  (9, 1009, 'AFFIDAVIT', 'AFF-2024-0119', '2026-09-14T12:26:10', FALSE),
  (10, 1010, 'GOV_ID', 'ID-2024-0333', '2026-09-14T12:26:10', TRUE),
  (11, 1011, 'BIRTH_CERT', 'BC-2024-0512', '2026-09-14T12:26:10', FALSE),
  (12, 1012, 'GOV_ID', 'ID-2024-0398', '2026-09-14T12:26:10', TRUE),
  (13, 1013, 'AFFIDAVIT', 'AFF-2024-0147', '2026-09-14T12:26:10', FALSE),
  (14, 1014, 'UTILITY_BILL', 'UB-2024-0076', '2026-09-14T12:26:10', TRUE),
  (15, 1016, 'BIRTH_CERT', 'BC-2024-0609', '2026-09-14T12:26:10', TRUE);
INSERT INTO `correction_history` (`history_id`, `request_id`, `voter_id`, `field_changed`, `old_value`, `new_value`, `changed_by`, `changed_at`)
VALUES
  (3, 1012, 120, 'NAME', 'Natalia K Cruzz', 'Natalia K Cruz', 5, '2026-09-14T12:26:10'),
  (4, 1014, 114, 'ADDRESS', '48 Oak Ave, Springfield', '48-B Oak Ave, Springfield', 5, '2026-09-14T12:26:10'),
  (5, 1016, 122, 'DOB', '1984-06-30', '1984-06-13', 6, '2026-09-14T12:26:10');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;