-- Create a database
CREATE DATABASE trails;

-- Connect to the database
\c trails;

-- Create tables

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    profile_picture VARCHAR(255),
    bio TEXT,
    registration_date TIMESTAMP DEFAULT NOW()
);

-- Trails table
CREATE TABLE trails (
    trail_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    difficulty VARCHAR(20),
    length_in_miles DECIMAL(5, 2),
    elevation_gain_in_feet INT,
    estimated_time_in_hours DECIMAL(4, 2),
    description TEXT,
    creator_user_id INT REFERENCES users(user_id),
    creation_date TIMESTAMP DEFAULT NOW()
);

-- Trail Reviews table
CREATE TABLE trail_reviews (
    review_id SERIAL PRIMARY KEY,
    trail_id INT REFERENCES trails(trail_id),
    user_id INT REFERENCES users(user_id),
    rating INT,
    review_text TEXT,
    review_date TIMESTAMP DEFAULT NOW()
);

-- Trail Recordings table (for GPS tracking)
CREATE TABLE trail_recordings (
    recording_id SERIAL PRIMARY KEY,
    trail_id INT REFERENCES trails(trail_id),
    user_id INT REFERENCES users(user_id),
    recorded_date TIMESTAMP DEFAULT NOW(),
    distance_in_miles DECIMAL(5, 2),
    time_in_minutes INT,
    elevation_data TEXT
);

-- Friends/Followers table (for social features)
CREATE TABLE friends_followers (
    relationship_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    friend_id INT REFERENCES users(user_id),
    date_connected TIMESTAMP DEFAULT NOW()
);

-- Implement any additional tables or constraints as needed.

-- Create indexes for optimization (if necessary)
CREATE INDEX idx_trails_location ON trails(location);
CREATE INDEX idx_trail_reviews_trail_id ON trail_reviews(trail_id);
CREATE INDEX idx_trail_reviews_user_id ON trail_reviews(user_id);

-- Create sequences for serial columns
CREATE SEQUENCE users_user_id_seq;
CREATE SEQUENCE trails_trail_id_seq;
CREATE SEQUENCE trail_reviews_review_id_seq;
CREATE SEQUENCE trail_recordings_recording_id_seq;
CREATE SEQUENCE friends_followers_relationship_id_seq;
