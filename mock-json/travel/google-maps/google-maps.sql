-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS your_database_name;

-- Connect to the database
\c your_database_name;

-- Define the schema for the tables

-- Table for storing user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL
);

-- Table for storing location data
CREATE TABLE IF NOT EXISTS locations (
    location_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    address TEXT,
    description TEXT,
    user_id INT REFERENCES users(user_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster location searches
CREATE INDEX idx_location_coordinates ON locations (latitude, longitude);

-- Table for storing map markers
CREATE TABLE IF NOT EXISTS markers (
    marker_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    label TEXT,
    info_window TEXT,
    location_id INT REFERENCES locations(location_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster marker searches
CREATE INDEX idx_marker_coordinates ON markers (latitude, longitude);

-- Table for storing user preferences
CREATE TABLE IF NOT EXISTS user_preferences (
    user_id INT PRIMARY KEY REFERENCES users(user_id),
    map_type VARCHAR(20),
    language VARCHAR(20),
    units VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table for storing user sessions (for scalability)
CREATE TABLE IF NOT EXISTS user_sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id INT REFERENCES users(user_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table for storing user feedback and reports
CREATE TABLE IF NOT EXISTS feedback (
    feedback_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
