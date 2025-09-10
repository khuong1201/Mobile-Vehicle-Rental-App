DROP DATABASE IF EXISTS rental_app;
CREATE DATABASE rental_app;
USE rental_app;

CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    google_id VARCHAR(255),
    name VARCHAR(35),
    email VARCHAR(35) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    gender VARCHAR(12),
    avatar VARCHAR(255),
    national_id VARCHAR(35),
    password_hash VARCHAR(255),
    role ENUM('owner','customer','admin') DEFAULT 'customer',
    verified BOOL DEFAULT FALSE,
    token VARCHAR(255),
    expires_at DATETIME,
    user_agent VARCHAR(255),
	ip_address VARCHAR(45),
    deleted BOOL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE address(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('home','work'),
    address VARCHAR(255) NOT NULL,
    floorOrApartmentNumber VARCHAR(20),
    contactName VARCHAR(35),
    phone VARCHAR(20),
    deleted BOOL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE licenses(
	id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
	typeOfDriverLicense VARCHAR(35),
    classLicense VARCHAR(10),
    licenseNumber VARCHAR(35),
    driverLicenseFront VARCHAR(255),
    driverLicenseBack VARCHAR(255),
    driverLicenseFrontPublicId VARCHAR(255),
    driverLicenseBackPublicId VARCHAR(255),
    deleted BOOL DEFAULT FALSE,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE brands(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(35),
    deleted BOOL DEFAULT FALSE
);

CREATE TABLE vehicles(
	id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT,
    brand_id INT,
    name VARCHAR(35),
    type ENUM('car','motor','coach','bike'),
    licensePlate VARCHAR(255) NOT NULL UNIQUE,
    model VARCHAR(35),
	yearOfManufacture VARCHAR(8),
	description VARCHAR(255),
    price DOUBLE,
    rate DOUBLE DEFAULT 0,
    status ENUM('available', 'rented', 'maintenance') DEFAULT 'available',
    deleted BOOL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE images(
	id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    image VARCHAR(255),
    imagePublicId VARCHAR(255),
    deleted BOOL DEFAULT FALSE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE location(
	id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    address VARCHAR(255),
    lat DOUBLE,
    lng DOUBLE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE bank(
	id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    accountNumber VARCHAR(255) NOT NULL,
    bankName VARCHAR(255) NOT NULL,
    accountHolderName VARCHAR(35) NOT NULL,
	deleted BOOL DEFAULT FALSE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE car_details (
	vehicle_id INT PRIMARY KEY,
	seatCount INT,
	transmissionType ENUM('manual', 'automatic'),
	fuelType ENUM('gasoline', 'diesel', 'electric', 'hybrid'),
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE motor_details (
	vehicle_id INT PRIMARY KEY,
	cc INT,
	fuelType ENUM('gasoline', 'diesel', 'electric', 'hybrid'),
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE coach_details (
	vehicle_id INT PRIMARY KEY,
	seatCount INT,
	transmissionType ENUM('manual', 'automatic'),
	fuelType ENUM('gasoline', 'diesel', 'electric', 'hybrid'),
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE bike_details (
	vehicle_id INT PRIMARY KEY,
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE features (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE vehicle_features (
	vehicle_id INT,
	feature_id INT,
	PRIMARY KEY (vehicle_id, feature_id),
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
	FOREIGN KEY (feature_id) REFERENCES features(id) ON DELETE CASCADE
);

CREATE TABLE booking (
	id INT AUTO_INCREMENT PRIMARY KEY,
	vehicle_id INT NOT NULL,
	owner_id INT NOT NULL,
	renter_id INT NOT NULL,
	pickup_at DATETIME NOT NULL,
	dropoff_at DATETIME NOT NULL,
	pickupLocation VARCHAR(255) NOT NULL,
	dropoffLocation VARCHAR(255) NOT NULL,
	totalRentalDays INT,
	basePrice DOUBLE,
	taxRate DOUBLE,
	taxAmount DOUBLE,
	totalPrice DOUBLE,
	isTaxDeducted BOOL DEFAULT FALSE,
	deleted BOOL DEFAULT FALSE,
	status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
	FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
	FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
	FOREIGN KEY (renter_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE reviews(
	id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    user_id INT,
    comment VARCHAR(255),
    rate INT,
    deleted BOOL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE review_report(
	id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT,
    reason VARCHAR(255),
    status ENUM('pending','rejected','reviewed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	title VARCHAR(100),
	message TEXT,
	is_read BOOL DEFAULT FALSE,
	type ENUM('system', 'promotion', 'booking', 'license') DEFAULT 'system',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE audit_logs (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT,
	action VARCHAR(255), 
	description TEXT,
	ip_address VARCHAR(45),
	user_agent VARCHAR(255),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
