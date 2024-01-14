-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS tinder_database;
-- Connect to the database
\c tinder_database;

-- Define the schema for the tables

-- Table for User Information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255),
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    location GEOMETRY(POINT),
    preferences JSONB,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table for User Matches
CREATE TABLE IF NOT EXISTS matches (
    match_id SERIAL PRIMARY KEY,
    user_id1 INT REFERENCES users(user_id) ON DELETE CASCADE,
    user_id2 INT REFERENCES users(user_id) ON DELETE CASCADE,
    matched_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table for Messages
CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    receiver_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    message_text TEXT,
    sent_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table for Blocked Users
CREATE TABLE IF NOT EXISTS blocked_users (
    block_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    blocked_user_id INT REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table for Reported Users
CREATE TABLE IF NOT EXISTS reported_users (
    report_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    reported_user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    report_reason TEXT,
    reported_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table for User Subscriptions (Premium Features)
CREATE TABLE IF NOT EXISTS user_subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    subscription_type VARCHAR(50),
    subscription_start TIMESTAMPTZ,
    subscription_end TIMESTAMPTZ
);

-- Indexes for Improved Query Performance
CREATE INDEX IF NOT EXISTS idx_matches_user_id1 ON matches(user_id1);
CREATE INDEX IF NOT EXISTS idx_matches_user_id2 ON matches(user_id2);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_blocked_users_user_id ON blocked_users(user_id);
CREATE INDEX IF NOT EXISTS idx_reported_users_user_id ON reported_users(user_id);
CREATE INDEX IF NOT EXISTS idx_user_subscriptions_user_id ON user_subscriptions(user_id);
