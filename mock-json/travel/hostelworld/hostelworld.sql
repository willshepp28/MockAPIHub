-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS hostelworld;

-- Connect to the database
\c hostelworld;

-- Define the schema for the tables

-- Table for User Authentication
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Hostels
CREATE TABLE IF NOT EXISTS hostels (
    hostel_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    rating DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    owner_id INT REFERENCES users(user_id)
);

-- Table for Reservations
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    hostel_id INT REFERENCES hostels(hostel_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Reviews
CREATE TABLE IF NOT EXISTS reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    hostel_id INT REFERENCES hostels(hostel_id),
    rating DECIMAL(3, 2) NOT NULL,
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for User Profile
CREATE TABLE IF NOT EXISTS user_profile (
    user_id INT PRIMARY KEY REFERENCES users(user_id),
    profile_picture_url VARCHAR(255),
    contact_information TEXT,
    preferences JSONB
);

-- Table for Notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Hostel Owners/Managers
CREATE TABLE IF NOT EXISTS hostel_owners (
    owner_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id)
);

-- Table for Payment Transactions (Integration with Payment Gateway)
CREATE TABLE IF NOT EXISTS payment_transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    reservation_id INT REFERENCES reservations(reservation_id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Improved Performance
CREATE INDEX IF NOT EXISTS idx_hostel_owner_id ON hostels(owner_id);
CREATE INDEX IF NOT EXISTS idx_reservation_user_id ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_review_hostel_id ON reviews(hostel_id);
CREATE INDEX IF NOT EXISTS idx_notification_user_id ON notifications(user_id);

-- Ensure Foreign Key Constraints
ALTER TABLE reservations ADD CONSTRAINT fk_reservations_hostel_id FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id);
ALTER TABLE reservations ADD CONSTRAINT fk_reservations_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_hostel_id FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE user_profile ADD CONSTRAINT fk_user_profile_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE hostel_owners ADD CONSTRAINT fk_hostel_owners_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE payment_transactions ADD CONSTRAINT fk_payment_transactions_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE payment_transactions ADD CONSTRAINT fk_payment_transactions_reservation_id FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id);

-- Optional: Create Triggers, Functions, and Procedures for Additional Logic

