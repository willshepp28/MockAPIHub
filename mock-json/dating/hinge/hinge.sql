-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS hinge_db;

-- Connect to the database
\c hinge_db;

-- Define the schema for the tables

-- Users table to store user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    full_name VARCHAR(100),
    birthdate DATE,
    gender VARCHAR(10),
    profile_picture_url VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Matches table to track user connections
CREATE TABLE IF NOT EXISTS user_matches (
    match_id SERIAL PRIMARY KEY,
    user_id1 INT NOT NULL,
    user_id2 INT NOT NULL,
    matched_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id1) REFERENCES users(user_id),
    FOREIGN KEY (user_id2) REFERENCES users(user_id)
);

-- Messages table to store user messages
CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_text TEXT,
    sent_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);

-- User Location table to store user locations
CREATE TABLE IF NOT EXISTS user_location (
    location_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location_timestamp TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Premium Users table for premium subscription features (if applicable)
CREATE TABLE IF NOT EXISTS premium_users (
    user_id INT PRIMARY KEY,
    subscription_start_date TIMESTAMPTZ,
    subscription_end_date TIMESTAMPTZ,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User Interests table to store user preferences and interests
CREATE TABLE IF NOT EXISTS user_interests (
    interest_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    interest_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User Blocks table to handle user blocking functionality
CREATE TABLE IF NOT EXISTS user_blocks (
    block_id SERIAL PRIMARY KEY,
    blocking_user_id INT NOT NULL,
    blocked_user_id INT NOT NULL,
    block_timestamp TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (blocking_user_id) REFERENCES users(user_id),
    FOREIGN KEY (blocked_user_id) REFERENCES users(user_id)
);

-- Reported Users table to track reported users and violations
CREATE TABLE IF NOT EXISTS reported_users (
    report_id SERIAL PRIMARY KEY,
    reporting_user_id INT NOT NULL,
    reported_user_id INT NOT NULL,
    report_reason TEXT,
    report_timestamp TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (reporting_user_id) REFERENCES users(user_id),
    FOREIGN KEY (reported_user_id) REFERENCES users(user_id)
);

-- Indexes for performance optimization (add more as needed)
CREATE INDEX idx_user_matches_user_id1 ON user_matches (user_id1);
CREATE INDEX idx_user_matches_user_id2 ON user_matches (user_id2);
CREATE INDEX idx_messages_sender_id ON messages (sender_id);
CREATE INDEX idx_messages_receiver_id ON messages (receiver_id);
CREATE INDEX idx_user_location_user_id ON user_location (user_id);

-- Additional tables and constraints as needed for your specific requirements

-- Example: User Photos table to store user photo albums
CREATE TABLE IF NOT EXISTS user_photos (
    photo_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    photo_url VARCHAR(255),
    upload_timestamp TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
