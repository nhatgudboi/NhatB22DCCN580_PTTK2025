

-- Create database
CREATE DATABASE IF NOT EXISTS userdb;
USE userdb;

-- ============================================
-- DROP TABLES (if exists) - Uncomment to reset database
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tblImportedSpareParts;
DROP TABLE IF EXISTS tblSparePartsInvoice;
DROP TABLE IF EXISTS tblPurchaseInvoice;
DROP TABLE IF EXISTS tblPaymentInvoice;
DROP TABLE IF EXISTS tblServiceInvoice;
DROP TABLE IF EXISTS tblAppointment;
DROP TABLE IF EXISTS tblVehicle;
DROP TABLE IF EXISTS tblCustomer;
DROP TABLE IF EXISTS tblSpareParts;
DROP TABLE IF EXISTS tblService;
DROP TABLE IF EXISTS tblSupplier;
DROP TABLE IF EXISTS tblStaff;
DROP TABLE IF EXISTS tblUser;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- CREATE TABLES
-- ============================================

-- Table: tblUser
CREATE TABLE IF NOT EXISTS tblUser (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    fullName VARCHAR(100),
    dateOfBirth DATE,
    address VARCHAR(255),
    email VARCHAR(100),
    phoneNumber VARCHAR(20),
    role VARCHAR(50) DEFAULT 'customer'
);

-- Table: tblStaff
CREATE TABLE IF NOT EXISTS tblStaff (
    tblUserid INT(10) PRIMARY KEY,
    position VARCHAR(50), -- management, warehouse, technical, sales
    salary DECIMAL(10,2),
    hireDate DATE,
    FOREIGN KEY (tblUserid) REFERENCES tblUser(id) ON DELETE CASCADE
);

-- Table: tblCustomer
CREATE TABLE IF NOT EXISTS tblCustomer (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phoneNumber VARCHAR(20),
    email VARCHAR(100),
    userId INT(10),
    FOREIGN KEY (userId) REFERENCES tblUser(id) ON DELETE SET NULL
);

-- Table: tblSupplier
CREATE TABLE IF NOT EXISTS tblSupplier (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phoneNumber VARCHAR(20),
    email VARCHAR(100),
    contactPerson VARCHAR(100)
);

-- Table: tblVehicle
CREATE TABLE IF NOT EXISTS tblVehicle (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    licensePlate VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT(4),
    color VARCHAR(30),
    description VARCHAR(255),
    customerId INT(10),
    FOREIGN KEY (customerId) REFERENCES tblCustomer(id) ON DELETE CASCADE
);

-- Table: tblService
CREATE TABLE IF NOT EXISTS tblService (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    duration INT(10) DEFAULT 60 -- duration in minutes
);

-- Table: tblSpareParts
CREATE TABLE IF NOT EXISTS tblSpareParts (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    stockQuantity INT(10) DEFAULT 0,
    minStockLevel INT(10) DEFAULT 10
);

-- Table: tblAppointment
CREATE TABLE IF NOT EXISTS tblAppointment (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    creationDate DATE,
    appointmentDate DATETIME NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, confirmed, completed, cancelled
    notes TEXT,
    customerId INT(10),
    vehicleId INT(10),
    FOREIGN KEY (customerId) REFERENCES tblCustomer(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicleId) REFERENCES tblVehicle(id) ON DELETE CASCADE
);

-- Table: tblPaymentInvoice (UPDATED - Main payment invoice)
CREATE TABLE IF NOT EXISTS tblPaymentInvoice (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    time DATE NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'unpaid', -- unpaid, paid, cancelled
    tblVehicleid INT(10),
    tblCustomerid INT(10),
    tblSaleStaffid INT(10),
    FOREIGN KEY (tblVehicleid) REFERENCES tblVehicle(id) ON DELETE SET NULL,
    FOREIGN KEY (tblCustomerid) REFERENCES tblCustomer(id) ON DELETE CASCADE,
    FOREIGN KEY (tblSaleStaffid) REFERENCES tblStaff(tblUserid) ON DELETE SET NULL
);

-- Table: tblServiceInvoice (UPDATED - Service details in payment invoice)
CREATE TABLE IF NOT EXISTS tblServiceInvoice (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    totalAmount DECIMAL(10,2) NOT NULL,
    quantity INT(10) DEFAULT 1,
    tblPaymentInvoiceid INT(10),
    tblServiceid INT(10),
    tblStafftblUserid INT(10), -- Technical staff who performed the service
    FOREIGN KEY (tblPaymentInvoiceid) REFERENCES tblPaymentInvoice(id) ON DELETE CASCADE,
    FOREIGN KEY (tblServiceid) REFERENCES tblService(id) ON DELETE CASCADE,
    FOREIGN KEY (tblStafftblUserid) REFERENCES tblStaff(tblUserid) ON DELETE SET NULL
);

-- Table: tblSparePartsInvoice (UPDATED - Spare parts in payment invoice)
CREATE TABLE IF NOT EXISTS tblSparePartsInvoice (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    totalAmount DECIMAL(10,2) NOT NULL,
    quantity INT(10) NOT NULL,
    PaymentInvoiceid INT(10), -- Note: column name as in ERD
    tblSparePartsid INT(10),
    FOREIGN KEY (PaymentInvoiceid) REFERENCES tblPaymentInvoice(id) ON DELETE CASCADE,
    FOREIGN KEY (tblSparePartsid) REFERENCES tblSpareParts(id) ON DELETE CASCADE
);

-- Table: tblPurchaseInvoice (UPDATED - Purchase from supplier)
CREATE TABLE IF NOT EXISTS tblPurchaseInvoice (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    time DATE NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, received, cancelled
    tblSupplierid INT(10),
    tblWarehouseStaffid INT(10),
    FOREIGN KEY (tblSupplierid) REFERENCES tblSupplier(id) ON DELETE SET NULL,
    FOREIGN KEY (tblWarehouseStaffid) REFERENCES tblStaff(tblUserid) ON DELETE SET NULL
);

-- Table: tblImportedSpareParts (UPDATED - Spare parts in purchase invoice)
CREATE TABLE IF NOT EXISTS tblImportedSpareParts (
    id INT(10) PRIMARY KEY AUTO_INCREMENT,
    totalAmount DECIMAL(10,2) NOT NULL,
    quantity INT(10) NOT NULL,
    tblPurchaseInvoiceid INT(10),
    tblSparePartsid INT(10),
    FOREIGN KEY (tblPurchaseInvoiceid) REFERENCES tblPurchaseInvoice(id) ON DELETE CASCADE,
    FOREIGN KEY (tblSparePartsid) REFERENCES tblSpareParts(id) ON DELETE CASCADE
);

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Insert Users (customers and staff)
INSERT INTO tblUser (username, password, fullName, dateOfBirth, address, email, phoneNumber, role) VALUES
-- Customers
('customer1', '1234', 'Nguyen Van A', '1990-05-15', '123 Le Loi St, Ho Chi Minh City', 'nguyenvana@email.com', '0901234567', 'customer'),
('customer2', '1234', 'Tran Thi B', '1985-08-20', '456 Nguyen Hue St, Ho Chi Minh City', 'tranthib@email.com', '0902345678', 'customer'),
('customer3', '1234', 'Le Van C', '1992-03-10', '789 Dong Khoi St, Ho Chi Minh City', 'levanc@email.com', '0903456789', 'customer'),
-- Staff
('admin', '1234', 'Admin User', '1980-01-01', 'Admin Office', 'admin@company.com', '0900000001', 'staff'),
('manager1', '1234', 'Manager One', '1985-06-15', 'Management Office', 'manager1@company.com', '0900000002', 'staff'),
('tech1', '1234', 'Technical Staff One', '1990-09-20', 'Technical Department', 'tech1@company.com', '0900000003', 'staff'),
('warehouse1', '1234', 'Warehouse Staff One', '1988-12-05', 'Warehouse', 'warehouse1@company.com', '0900000004', 'staff'),
('sales1', '1234', 'Sales Staff One', '1991-04-18', 'Sales Department', 'sales1@company.com', '0900000005', 'staff');

-- Insert Staff details
INSERT INTO tblStaff (tblUserid, position, salary, hireDate) VALUES
(4, 'management', 15000.00, '2020-01-15'),
(5, 'management', 12000.00, '2021-03-20'),
(6, 'technical', 8000.00, '2022-05-10'),
(7, 'warehouse', 7000.00, '2022-07-15'),
(8, 'sales', 7500.00, '2023-01-20');

-- Insert Customers
INSERT INTO tblCustomer (fullName, address, phoneNumber, email, userId) VALUES
('Nguyen Van A', '123 Le Loi St, Ho Chi Minh City', '0901234567', 'nguyenvana@email.com', 1),
('Tran Thi B', '456 Nguyen Hue St, Ho Chi Minh City', '0902345678', 'tranthib@email.com', 2),
('Le Van C', '789 Dong Khoi St, Ho Chi Minh City', '0903456789', 'levanc@email.com', 3);

-- Insert Suppliers
INSERT INTO tblSupplier (name, address, phoneNumber, email, contactPerson) VALUES
('Auto Parts Supplier A', '100 Industrial Zone, Binh Duong', '0281234567', 'suppliera@email.com', 'Mr. X'),
('Car Parts Co.', '200 Manufacturing St, Dong Nai', '0282345678', 'carparts@email.com', 'Ms. Y'),
('Vehicle Components Ltd.', '300 Trade Center, Ho Chi Minh City', '0283456789', 'components@email.com', 'Mr. Z');

-- Insert Vehicles
INSERT INTO tblVehicle (licensePlate, brand, model, year, color, description, customerId) VALUES
('51A-12345', 'Toyota', 'Camry', 2020, 'White', 'Toyota Camry 2020', 1),
('51B-67890', 'Honda', 'Civic', 2019, 'Black', 'Honda Civic 2019', 1),
('51C-11111', 'Ford', 'Ranger', 2021, 'Blue', 'Ford Ranger 2021', 2),
('51D-22222', 'Mazda', 'CX-5', 2022, 'Red', 'Mazda CX-5 2022', 3);

-- Insert Services
INSERT INTO tblService (name, price, description, duration) VALUES
('Oil Change', 50.00, 'Complete oil change service including filter replacement', 30),
('Brake Service', 120.00, 'Brake pad replacement and brake fluid check', 60),
('Tire Rotation', 30.00, 'Rotate all four tires for even wear', 20),
('Engine Tune-up', 200.00, 'Complete engine inspection and tune-up', 90),
('AC Service', 80.00, 'Air conditioning system service and recharge', 45),
('Battery Replacement', 150.00, 'Replace car battery with new one', 30),
('Transmission Service', 180.00, 'Transmission fluid change and inspection', 60),
('Wheel Alignment', 70.00, 'Four-wheel alignment service', 40),
('Car Wash', 25.00, 'Complete car wash and interior cleaning', 30),
('Diagnostic Check', 50.00, 'Complete vehicle diagnostic check', 45);

-- Insert Spare Parts
INSERT INTO tblSpareParts (name, price, description, stockQuantity, minStockLevel) VALUES
('Engine Oil Filter', 15.99, 'High-quality engine oil filter', 50, 10),
('Brake Pads Set', 89.99, 'Premium brake pads for front wheels', 25, 5),
('Air Filter', 12.99, 'Replacement air filter', 100, 20),
('Spark Plugs Set', 45.99, 'Set of 4 spark plugs', 30, 10),
('Battery', 120.00, '12V car battery', 15, 5),
('Windshield Wipers', 25.99, 'Pair of windshield wipers', 40, 10),
('Headlight Bulb', 18.99, 'H4 headlight bulb', 60, 15),
('Radiator Cap', 8.99, 'Replacement radiator cap', 35, 10),
('Timing Belt', 75.99, 'Engine timing belt', 20, 5),
('Fuel Filter', 22.99, 'Fuel filter replacement', 45, 10),
('Transmission Fluid', 35.99, 'Automatic transmission fluid 1L', 80, 20),
('Brake Fluid', 12.99, 'Brake fluid DOT 4 500ml', 70, 15),
('Coolant', 15.99, 'Engine coolant 1L', 90, 25),
('Power Steering Fluid', 18.99, 'Power steering fluid 1L', 50, 12);

-- Insert Appointments
INSERT INTO tblAppointment (creationDate, appointmentDate, status, notes, customerId, vehicleId) VALUES
('2024-01-10', '2024-01-15 09:00:00', 'completed', 'Regular maintenance', 1, 1),
('2024-01-15', '2024-01-20 10:30:00', 'completed', 'Brake service needed', 2, 3),
('2024-01-25', '2024-02-01 14:00:00', 'confirmed', 'Oil change and inspection', 1, 2),
('2024-01-28', '2024-02-05 11:00:00', 'pending', 'AC service', 3, 4),
('2024-02-01', '2024-02-10 08:30:00', 'pending', 'Engine tune-up', 2, 3);

-- Insert Payment Invoices (Main invoices)
INSERT INTO tblPaymentInvoice (time, totalAmount, status, tblVehicleid, tblCustomerid, tblSaleStaffid) VALUES
('2024-01-15', 50.00, 'paid', 1, 1, 8),
('2024-01-20', 120.00, 'paid', 3, 2, 8),
('2024-02-01', 50.00, 'unpaid', 2, 1, 8),
('2024-02-05', 80.00, 'unpaid', 4, 3, 8),
('2024-02-10', 200.00, 'unpaid', 3, 2, 8);

-- Insert Service Invoices (Service details in payment invoices)
INSERT INTO tblServiceInvoice (totalAmount, quantity, tblPaymentInvoiceid, tblServiceid, tblStafftblUserid) VALUES
(50.00, 1, 1, 1, 6), -- Oil Change for invoice 1
(120.00, 1, 2, 2, 6), -- Brake Service for invoice 2
(50.00, 1, 3, 1, 6), -- Oil Change for invoice 3
(80.00, 1, 4, 5, 6), -- AC Service for invoice 4
(200.00, 1, 5, 4, 6); -- Engine Tune-up for invoice 5

-- Insert Spare Parts Invoices (Spare parts in payment invoices)
INSERT INTO tblSparePartsInvoice (totalAmount, quantity, PaymentInvoiceid, tblSparePartsid) VALUES
(15.99, 1, 1, 1), -- Engine Oil Filter for invoice 1
(89.99, 1, 2, 2), -- Brake Pads Set for invoice 2
(12.99, 1, 3, 3), -- Air Filter for invoice 3
(120.00, 1, 4, 5), -- Battery for invoice 4
(45.99, 1, 5, 4); -- Spark Plugs Set for invoice 5

-- Insert Purchase Invoices (Purchase from suppliers)
INSERT INTO tblPurchaseInvoice (time, totalAmount, status, tblSupplierid, tblWarehouseStaffid) VALUES
('2024-01-10', 5000.00, 'received', 1, 7),
('2024-01-25', 3500.00, 'received', 2, 7),
('2024-02-01', 2800.00, 'pending', 3, 7);

-- Insert Imported Spare Parts (Spare parts in purchase invoices)
INSERT INTO tblImportedSpareParts (totalAmount, quantity, tblPurchaseInvoiceid, tblSparePartsid) VALUES
(799.50, 50, 1, 1), -- 50 x Engine Oil Filter
(2249.75, 25, 1, 2), -- 25 x Brake Pads Set
(1299.00, 100, 1, 3), -- 100 x Air Filter
(1379.70, 30, 2, 4), -- 30 x Spark Plugs Set
(1800.00, 15, 2, 5), -- 15 x Battery
(1039.60, 40, 2, 6), -- 40 x Windshield Wipers
(1139.40, 60, 3, 7), -- 60 x Headlight Bulb
(314.65, 35, 3, 8); -- 35 x Radiator Cap

-- ============================================
-- VERIFY DATA
-- ============================================
SELECT 'Database setup completed!' AS Status;
SELECT COUNT(*) AS TotalUsers FROM tblUser;
SELECT COUNT(*) AS TotalCustomers FROM tblCustomer;
SELECT COUNT(*) AS TotalServices FROM tblService;
SELECT COUNT(*) AS TotalSpareParts FROM tblSpareParts;
SELECT COUNT(*) AS TotalPaymentInvoices FROM tblPaymentInvoice;
SELECT COUNT(*) AS TotalServiceInvoices FROM tblServiceInvoice;
SELECT COUNT(*) AS TotalSparePartsInvoices FROM tblSparePartsInvoice;

-- ============================================
-- ADDITIONAL SAMPLE DATA (Starting from line 317)
-- Using existing customers (1, 2, 3) and staff (4-8)
-- ============================================

-- Insert More Suppliers (continuing from existing suppliers 1, 2, 3)
INSERT INTO tblSupplier (name, address, phoneNumber, email, contactPerson) VALUES
('Premium Auto Parts', '400 Business Park, Ho Chi Minh City', '0284567890', 'premium@email.com', 'Mr. A'),
('Global Car Components', '500 Export Zone, Can Tho', '0285678901', 'global@email.com', 'Ms. B'),
('Vietnam Auto Supply', '600 Industrial Area, Hai Phong', '0286789012', 'vietnam@email.com', 'Mr. C'),
('Fast Parts Delivery', '700 Logistics Center, Da Nang', '0287890123', 'fastparts@email.com', 'Ms. D'),
('Quality Components Co.', '800 Manufacturing Hub, Vung Tau', '0288901234', 'quality@email.com', 'Mr. E');

-- Insert More Vehicles (for existing customers 1, 2, 3)
INSERT INTO tblVehicle (licensePlate, brand, model, year, color, description, customerId) VALUES
('51E-33333', 'Hyundai', 'Tucson', 2020, 'Silver', 'Hyundai Tucson 2020', 1),
('51F-44444', 'Kia', 'Sorento', 2021, 'White', 'Kia Sorento 2021', 1),
('51G-55555', 'Nissan', 'X-Trail', 2019, 'Black', 'Nissan X-Trail 2019', 2),
('51H-66666', 'Suzuki', 'Swift', 2022, 'Red', 'Suzuki Swift 2022', 2),
('51I-77777', 'Mitsubishi', 'Outlander', 2020, 'Blue', 'Mitsubishi Outlander 2020', 3),
('51J-88888', 'Chevrolet', 'Trailblazer', 2021, 'Gray', 'Chevrolet Trailblazer 2021', 3),
('51K-99999', 'Volkswagen', 'Tiguan', 2022, 'White', 'Volkswagen Tiguan 2022', 1),
('51L-10101', 'BMW', 'X3', 2021, 'Black', 'BMW X3 2021', 2),
('51M-20202', 'Mercedes', 'GLC', 2020, 'Silver', 'Mercedes GLC 2020', 3),
('51N-30303', 'Audi', 'Q5', 2022, 'Blue', 'Audi Q5 2022', 1),
('51O-40404', 'Lexus', 'NX', 2021, 'White', 'Lexus NX 2021', 2),
('51P-50505', 'Volvo', 'XC60', 2020, 'Black', 'Volvo XC60 2020', 3),
('51Q-60606', 'Subaru', 'Forester', 2022, 'Green', 'Subaru Forester 2022', 1),
('51R-70707', 'Peugeot', '3008', 2021, 'Red', 'Peugeot 3008 2021', 2);

-- Insert More Services
INSERT INTO tblService (name, price, description, duration) VALUES
('Full Service', 350.00, 'Complete vehicle service including all checks', 120),
('Battery Test', 20.00, 'Battery health and voltage test', 15),
('Tire Balancing', 40.00, 'Balance all four tires', 30),
('Exhaust System Check', 60.00, 'Complete exhaust system inspection', 45),
('Suspension Service', 150.00, 'Suspension system check and adjustment', 60),
('Radiator Flush', 90.00, 'Radiator flush and coolant replacement', 45),
('Fuel System Clean', 100.00, 'Fuel system cleaning service', 50),
('Headlight Restoration', 80.00, 'Headlight cleaning and restoration', 40),
('Interior Deep Clean', 120.00, 'Complete interior deep cleaning', 90),
('Paint Protection', 200.00, 'Paint protection and waxing service', 120),
('Window Tinting', 300.00, 'Professional window tinting service', 180),
('Sound System Installation', 400.00, 'Car audio system installation', 240);

-- Insert More Spare Parts
INSERT INTO tblSpareParts (name, price, description, stockQuantity, minStockLevel) VALUES
('Oil Pan Gasket', 28.99, 'Engine oil pan gasket', 25, 5),
('Water Pump', 95.99, 'Engine water pump', 15, 3),
('Alternator', 250.00, 'Car alternator 12V', 10, 2),
('Starter Motor', 280.00, 'Engine starter motor', 8, 2),
('Radiator', 180.99, 'Car radiator', 12, 3),
('Thermostat', 22.99, 'Engine thermostat', 30, 8),
('Serpentine Belt', 45.99, 'Engine serpentine belt', 35, 10),
('Power Steering Pump', 195.99, 'Power steering pump', 10, 2),
('Shock Absorber', 120.99, 'Front shock absorber', 20, 5),
('Strut Assembly', 180.99, 'Front strut assembly', 15, 4),
('CV Joint', 85.99, 'CV joint replacement', 18, 5),
('Wheel Bearing', 65.99, 'Wheel bearing set', 25, 6),
('Brake Rotor', 75.99, 'Front brake rotor', 30, 8),
('Brake Caliper', 150.99, 'Front brake caliper', 12, 3),
('Master Cylinder', 125.99, 'Brake master cylinder', 10, 2),
('Clutch Kit', 220.99, 'Complete clutch kit', 8, 2),
('Flywheel', 180.99, 'Engine flywheel', 6, 2),
('Catalytic Converter', 350.99, 'Catalytic converter', 5, 1),
('Muffler', 120.99, 'Exhaust muffler', 15, 4),
('Oxygen Sensor', 95.99, 'O2 oxygen sensor', 20, 5);

-- Insert More Appointments (for existing customers 1, 2, 3)
INSERT INTO tblAppointment (creationDate, appointmentDate, status, notes, customerId, vehicleId) VALUES
('2024-02-12', '2024-02-18 09:30:00', 'confirmed', 'Full service check', 1, 5),
('2024-02-15', '2024-02-22 10:00:00', 'pending', 'Brake inspection', 2, 7),
('2024-02-18', '2024-02-25 14:30:00', 'pending', 'AC repair', 3, 9),
('2024-02-20', '2024-02-28 08:00:00', 'confirmed', 'Transmission service', 1, 11),
('2024-02-22', '2024-03-01 11:00:00', 'pending', 'Engine diagnostic', 2, 13),
('2024-02-25', '2024-03-05 13:00:00', 'pending', 'Tire replacement', 3, 15),
('2024-02-28', '2024-03-08 09:00:00', 'confirmed', 'Battery replacement', 1, 7),
('2024-03-01', '2024-03-10 10:30:00', 'pending', 'Suspension check', 2, 8),
('2024-03-03', '2024-03-12 15:00:00', 'pending', 'Paint protection', 3, 10),
('2024-03-05', '2024-03-15 08:30:00', 'confirmed', 'Window tinting', 1, 12),
('2024-03-08', '2024-03-18 14:00:00', 'pending', 'Oil change', 2, 9),
('2024-03-10', '2024-03-20 09:00:00', 'confirmed', 'Wheel alignment', 3, 11),
('2024-03-12', '2024-03-22 11:30:00', 'pending', 'AC service', 1, 13),
('2024-03-15', '2024-03-25 08:00:00', 'pending', 'Brake service', 2, 14),
('2024-03-18', '2024-03-28 13:00:00', 'confirmed', 'Engine tune-up', 3, 15);

-- Insert More Payment Invoices (for existing customers 1, 2, 3, using existing staff 8=sales1)
INSERT INTO tblPaymentInvoice (time, totalAmount, status, tblVehicleid, tblCustomerid, tblSaleStaffid) VALUES
('2024-02-18', 350.00, 'paid', 5, 1, 8),
('2024-02-22', 180.00, 'paid', 7, 2, 8),
('2024-02-25', 200.00, 'unpaid', 9, 3, 8),
('2024-02-28', 250.00, 'unpaid', 11, 1, 8),
('2024-03-01', 150.00, 'unpaid', 13, 2, 8),
('2024-03-05', 400.00, 'paid', 15, 3, 8),
('2024-03-08', 150.00, 'paid', 7, 1, 8),
('2024-03-10', 120.00, 'unpaid', 8, 2, 8),
('2024-03-12', 200.00, 'unpaid', 10, 3, 8),
('2024-03-15', 300.00, 'unpaid', 12, 1, 8),
('2024-03-18', 80.00, 'paid', 9, 2, 8),
('2024-03-20', 120.00, 'paid', 11, 3, 8),
('2024-03-22', 70.00, 'unpaid', 13, 1, 8),
('2024-03-25', 90.00, 'unpaid', 14, 2, 8),
('2024-03-28', 400.00, 'paid', 15, 3, 8),
('2024-04-01', 180.00, 'paid', 5, 1, 8),
('2024-04-05', 120.00, 'unpaid', 7, 2, 8),
('2024-04-08', 200.00, 'paid', 9, 3, 8),
('2024-04-10', 80.00, 'unpaid', 11, 1, 8),
('2024-04-12', 150.00, 'paid', 13, 2, 8),
('2024-04-15', 250.00, 'unpaid', 15, 3, 8);

-- Insert More Service Invoices (using existing staff 6=tech1)
INSERT INTO tblServiceInvoice (totalAmount, quantity, tblPaymentInvoiceid, tblServiceid, tblStafftblUserid) VALUES
(350.00, 1, 6, 11, 6), -- Full Service for invoice 6
(180.00, 1, 7, 4, 6), -- Engine Tune-up for invoice 7
(200.00, 1, 8, 4, 6), -- Engine Tune-up for invoice 8
(180.00, 1, 9, 7, 6), -- Transmission Service for invoice 9
(150.00, 1, 10, 12, 6), -- Suspension Service for invoice 10
(400.00, 1, 11, 4, 6), -- Engine Tune-up for invoice 11
(150.00, 1, 12, 5, 6), -- Battery Replacement for invoice 12
(120.00, 1, 13, 12, 6), -- Suspension Service for invoice 13
(200.00, 1, 14, 11, 6), -- Paint Protection for invoice 14
(300.00, 1, 15, 11, 6), -- Window Tinting for invoice 15
(80.00, 1, 16, 5, 6), -- AC Service for invoice 16
(120.00, 1, 17, 2, 6), -- Brake Service for invoice 17
(70.00, 1, 18, 8, 6), -- Wheel Alignment for invoice 18
(90.00, 1, 19, 6, 6), -- Radiator Flush for invoice 19
(400.00, 1, 20, 12, 6), -- Sound System Installation for invoice 20
(50.00, 1, 6, 10, 6), -- Additional: Diagnostic Check for invoice 6
(30.00, 1, 7, 3, 6), -- Additional: Tire Rotation for invoice 7
(25.00, 1, 8, 9, 6), -- Additional: Car Wash for invoice 8
(120.00, 1, 21, 2, 6), -- Brake Service for invoice 21
(50.00, 1, 22, 1, 6), -- Oil Change for invoice 22
(200.00, 1, 23, 4, 6), -- Engine Tune-up for invoice 23
(80.00, 1, 24, 5, 6), -- AC Service for invoice 24
(150.00, 1, 25, 5, 6); -- Battery Replacement for invoice 25

-- Insert More Spare Parts Invoices
INSERT INTO tblSparePartsInvoice (totalAmount, quantity, PaymentInvoiceid, tblSparePartsid) VALUES
(28.99, 1, 6, 15), -- Oil Pan Gasket for invoice 6
(95.99, 1, 7, 16), -- Water Pump for invoice 7
(250.00, 1, 8, 17), -- Alternator for invoice 8
(180.99, 1, 9, 19), -- Radiator for invoice 9
(120.99, 1, 10, 23), -- Shock Absorber for invoice 10
(120.00, 1, 11, 5), -- Battery for invoice 11
(45.99, 1, 12, 4), -- Spark Plugs Set for invoice 12
(75.99, 1, 13, 27), -- Brake Rotor for invoice 13
(150.99, 1, 14, 28), -- Brake Caliper for invoice 14
(220.99, 1, 15, 30), -- Clutch Kit for invoice 15
(22.99, 1, 16, 20), -- Thermostat for invoice 16
(89.99, 1, 17, 2), -- Brake Pads Set for invoice 17
(65.99, 1, 18, 26), -- Wheel Bearing for invoice 18
(35.99, 2, 19, 11), -- Transmission Fluid (2L) for invoice 19
(15.99, 1, 20, 1), -- Engine Oil Filter for invoice 20
(12.99, 1, 6, 3), -- Additional: Air Filter for invoice 6
(25.99, 1, 7, 6), -- Additional: Windshield Wipers for invoice 7
(18.99, 1, 8, 7); -- Additional: Headlight Bulb for invoice 8

-- Insert More Purchase Invoices (using existing staff 7=warehouse1)
INSERT INTO tblPurchaseInvoice (time, totalAmount, status, tblSupplierid, tblWarehouseStaffid) VALUES
('2024-02-10', 4500.00, 'received', 4, 7),
('2024-02-20', 5200.00, 'received', 5, 7),
('2024-03-01', 3800.00, 'pending', 6, 7),
('2024-03-10', 6100.00, 'received', 7, 7),
('2024-03-15', 2900.00, 'pending', 8, 7),
('2024-03-20', 4800.00, 'received', 4, 7),
('2024-03-25', 5500.00, 'pending', 5, 7),
('2024-04-01', 4200.00, 'received', 6, 7),
('2024-04-10', 3800.00, 'pending', 7, 7),
('2024-04-15', 5100.00, 'received', 8, 7);

-- Insert More Imported Spare Parts
INSERT INTO tblImportedSpareParts (totalAmount, quantity, tblPurchaseInvoiceid, tblSparePartsid) VALUES
(724.75, 25, 4, 15), -- 25 x Oil Pan Gasket
(1439.85, 15, 4, 16), -- 15 x Water Pump
(3750.00, 15, 4, 17), -- 15 x Alternator
(2714.85, 15, 5, 19), -- 15 x Radiator
(1814.85, 15, 5, 23), -- 15 x Shock Absorber
(1289.70, 20, 5, 24), -- 20 x Strut Assembly
(1547.70, 18, 6, 25), -- 18 x CV Joint
(1649.75, 25, 6, 26), -- 25 x Wheel Bearing
(2279.70, 30, 6, 27), -- 30 x Brake Rotor
(1811.88, 12, 7, 28), -- 12 x Brake Caliper
(1259.90, 10, 7, 29), -- 10 x Master Cylinder
(1767.92, 8, 7, 30), -- 8 x Clutch Kit
(1085.94, 6, 8, 31), -- 6 x Flywheel
(1754.95, 5, 8, 32), -- 5 x Catalytic Converter
(1814.85, 15, 8, 33), -- 15 x Muffler
(1919.80, 20, 9, 34), -- 20 x Oxygen Sensor
(289.90, 10, 9, 20), -- 10 x Thermostat
(259.90, 10, 9, 21); -- 10 x Serpentine Belt

-- ============================================
-- FINAL DATA VERIFICATION
-- ============================================
SELECT 'Additional sample data inserted successfully!' AS Status;
SELECT COUNT(*) AS TotalUsers FROM tblUser;
SELECT COUNT(*) AS TotalCustomers FROM tblCustomer;
SELECT COUNT(*) AS TotalStaff FROM tblStaff;
SELECT COUNT(*) AS TotalVehicles FROM tblVehicle;
SELECT COUNT(*) AS TotalServices FROM tblService;
SELECT COUNT(*) AS TotalSpareParts FROM tblSpareParts;
SELECT COUNT(*) AS TotalSuppliers FROM tblSupplier;
SELECT COUNT(*) AS TotalAppointments FROM tblAppointment;
SELECT COUNT(*) AS TotalPaymentInvoices FROM tblPaymentInvoice;
SELECT COUNT(*) AS TotalServiceInvoices FROM tblServiceInvoice;
SELECT COUNT(*) AS TotalSparePartsInvoices FROM tblSparePartsInvoice;
SELECT COUNT(*) AS TotalPurchaseInvoices FROM tblPurchaseInvoice;
SELECT COUNT(*) AS TotalImportedSpareParts FROM tblImportedSpareParts;
