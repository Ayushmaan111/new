-- 1. Create Database
CREATE DATABASE hospital_db;
USE hospital_db;

-- 2. Create Tables

-- Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    gender ENUM('Male','Female','Other'),
    phone VARCHAR(15),
    address VARCHAR(100),
    blood_group VARCHAR(5),
    emergency_contact VARCHAR(15)
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    department VARCHAR(50)
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Treatments Table
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    diagnosis VARCHAR(100),
    prescription VARCHAR(200),
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Billing Table
CREATE TABLE Billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status ENUM('Paid','Pending','Partial') DEFAULT 'Pending',
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Departments Table
CREATE TABLE Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

-- 3. Insert Sample Data

-- Patients
INSERT INTO Patients (first_name, last_name, dob, gender, phone, address, blood_group, emergency_contact)
VALUES 
('John', 'Doe', '1990-05-14', 'Male', '9876543210', 'New Delhi', 'O+', '9123456789'),
('Sarah', 'Sharma', '1985-11-22', 'Female', '9876501234', 'Mumbai', 'A+', '9988776655'),
('Amit', 'Patel', '2000-01-10', 'Male', '9988771122', 'Ahmedabad', 'B-', '9090909090');

-- Doctors
INSERT INTO Doctors (first_name, last_name, specialization, phone, email, department)
VALUES 
('Dr. Priya', 'Verma', 'Cardiology', '9123456789', 'priya.verma@hospital.com', 'Cardiology'),
('Dr. Ramesh', 'Kumar', 'Neurology', '9345678910', 'ramesh.kumar@hospital.com', 'Neurology'),
('Dr. Anita', 'Singh', 'Orthopedics', '9456781234', 'anita.singh@hospital.com', 'Orthopedics');

-- Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES 
(1, 1, '2025-09-12', '10:00:00', 'Scheduled'),
(2, 2, '2025-09-13', '11:30:00', 'Completed'),
(3, 3, '2025-09-14', '14:00:00', 'Scheduled');

-- Treatments
INSERT INTO Treatments (appointment_id, diagnosis, prescription, notes)
VALUES 
(2, 'Migraine', 'Paracetamol 500mg', 'Advised rest'),
(1, 'Chest Pain', 'Aspirin 75mg', 'Recommended ECG'),
(3, 'Knee Pain', 'Ibuprofen 400mg', 'Physiotherapy advised');

-- Billing
INSERT INTO Billing (patient_id, appointment_id, amount, payment_status, payment_date)
VALUES 
(1, 1, 1500.00, 'Pending', NULL),
(2, 2, 2500.00, 'Paid', '2025-09-09'),
(3, 3, 1800.00, 'Partial', '2025-09-10');

-- Departments
INSERT INTO Departments (dept_name, location)
VALUES 
('Cardiology', 'Block A'),
('Neurology', 'Block B'),
('Orthopedics', 'Block C');

-- 4. Example Queries

-- List all patients with their doctors
SELECT p.first_name AS patient, p.last_name, d.first_name AS doctor, d.specialization
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- Find revenue collected
SELECT SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

-- Doctors workload (number of appointments)
SELECT d.first_name, d.last_name, COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;

-- Patients with unpaid bills
SELECT p.first_name, p.last_name, b.amount, b.payment_status
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status != 'Paid';
