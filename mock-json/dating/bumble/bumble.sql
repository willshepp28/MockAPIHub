-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS bumble_database;

-- Connect to the database
\c bumble_database;

-- Define the schema for the tables

-- Users table to store user profiles
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(128) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    profile_picture_url TEXT,
    bio TEXT,
    registration_date TIMESTAMP DEFAULT NOW()
);

-- User preferences table to store user preferences and settings
CREATE TABLE IF NOT EXISTS user_preferences (
    user_id INT PRIMARY KEY,
    min_age INT,
    max_age INT,
    preferred_gender VARCHAR(20)[] -- Array to store multiple preferred genders
);

-- User location table to store user location data
CREATE TABLE IF NOT EXISTS user_location (
    user_id INT PRIMARY KEY,
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6),
    last_updated TIMESTAMP DEFAULT NOW()
);

-- User connections table to store matches and connections
CREATE TABLE IF NOT EXISTS user_connections (
    connection_id SERIAL PRIMARY KEY,
    user_id1 INT,
    user_id2 INT,
    matched_date TIMESTAMP,
    FOREIGN KEY (user_id1) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id2) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Messages table to store user messages
CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    message_text TEXT,
    sent_timestamp TIMESTAMP DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Reports table to store user reports
CREATE TABLE IF NOT EXISTS reports (
    report_id SERIAL PRIMARY KEY,
    reporting_user_id INT,
    reported_user_id INT,
    report_reason TEXT,
    report_timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (reporting_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reported_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Blocked users table to store blocked user relationships
CREATE TABLE IF NOT EXISTS blocked_users (
    block_id SERIAL PRIMARY KEY,
    blocking_user_id INT,
    blocked_user_id INT,
    block_timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (blocking_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (blocked_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Notifications table to store user notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT,
    notification_text TEXT,
    notification_timestamp TIMESTAMP DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Likes and Super Likes table
CREATE TABLE IF NOT EXISTS likes (
    like_id SERIAL PRIMARY KEY,
    user_id INT,
    liked_user_id INT,
    is_super_like BOOLEAN DEFAULT FALSE,
    like_timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (liked_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Premium subscription table
CREATE TABLE IF NOT EXISTS premium_subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Gifted items table
CREATE TABLE IF NOT EXISTS gifted_items (
    gift_id SERIAL PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    gift_type VARCHAR(50),
    gift_timestamp TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_user_connections_match_date ON user_connections (matched_date);
CREATE INDEX IF NOT EXISTS idx_messages_sent_timestamp ON messages (sent_timestamp);
CREATE INDEX IF NOT EXISTS idx_reports_report_timestamp ON reports (report_timestamp);
CREATE INDEX IF NOT EXISTS idx_blocked_users_block_timestamp ON blocked_users (block_timestamp);
CREATE INDEX IF NOT EXISTS idx_notifications_notification_timestamp ON notifications (notification_timestamp);
CREATE INDEX IF NOT EXISTS idx_likes_like_timestamp ON likes (like_timestamp);
CREATE INDEX IF NOT EXISTS idx_premium_subscriptions_end_date ON premium_subscriptions (end_date);
CREATE INDEX IF NOT EXISTS idx_gifted_items_gift_timestamp ON gifted_items (gift_timestamp);
