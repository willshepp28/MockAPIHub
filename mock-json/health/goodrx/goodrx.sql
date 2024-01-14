-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS your_database_name;

-- Connect to the database
\c your_database_name;

-- Define the schema for the tables

-- User Table: Stores user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    last_login TIMESTAMPTZ,
);

-- Medication Table: Stores medication information
CREATE TABLE IF NOT EXISTS medications (
    medication_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dosage VARCHAR(50),
    description TEXT,
    -- Add more medication-related fields as needed
);

-- Pharmacy Table: Stores pharmacy information
CREATE TABLE IF NOT EXISTS pharmacies (
    pharmacy_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    business_hours VARCHAR(255),
    -- Add more pharmacy-related fields as needed
);

-- Medication_Price Table: Stores prices for medications at different pharmacies
CREATE TABLE IF NOT EXISTS medication_prices (
    price_id SERIAL PRIMARY KEY,
    medication_id INT REFERENCES medications(medication_id) NOT NULL,
    pharmacy_id INT REFERENCES pharmacies(pharmacy_id) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    -- Add more price-related fields as needed
);

-- Coupons Table: Stores coupon offers for medications
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id SERIAL PRIMARY KEY,
    medication_id INT REFERENCES medications(medication_id) NOT NULL,
    coupon_code VARCHAR(20) NOT NULL,
    discount_amount NUMERIC(5, 2) NOT NULL,
    expiry_date DATE,
);

-- User_Medication Table: Stores user's saved medications
CREATE TABLE IF NOT EXISTS user_medications (
    user_medication_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) NOT NULL,
    medication_id INT REFERENCES medications(medication_id) NOT NULL,
);

-- Orders Table: Stores medication orders
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) NOT NULL,
    pharmacy_id INT REFERENCES pharmacies(pharmacy_id) NOT NULL,
    medication_id INT REFERENCES medications(medication_id) NOT NULL,
    quantity INT NOT NULL,
    order_date TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(50) NOT NULL,
);

-- Prescription Table: Stores prescription information
CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) NOT NULL,
    medication_id INT REFERENCES medications(medication_id) NOT NULL,
    prescription_file BYTEA, -- Store prescription file as binary data
    upload_date TIMESTAMPTZ DEFAULT NOW(),
    expiry_date DATE,
);

-- Notifications Table: Stores user notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) NOT NULL,
    message TEXT NOT NULL,
    sent_date TIMESTAMPTZ DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE,
    -- Add more notification-related fields as needed
);

-- Admins Table: Stores administrator accounts
CREATE TABLE IF NOT EXISTS admins (
    admin_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    registration_date TIMESTAMPTZ DEFAULT NOW(),
);

