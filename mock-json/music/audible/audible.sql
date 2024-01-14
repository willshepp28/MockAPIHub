-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS audible_database;

-- Connect to the database
\c audible_database;

-- Define the schema for the tables

-- Table: Users
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    profile_picture VARCHAR(255),
    bio TEXT,
    registration_date TIMESTAMP DEFAULT NOW()
);

-- Table: Audiobooks
CREATE TABLE IF NOT EXISTS audiobooks (
    audiobook_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    narrator VARCHAR(255),
    length_in_hours DECIMAL(5, 2),
    genre VARCHAR(50),
    description TEXT,
    release_date DATE,
    publisher VARCHAR(100),
    cover_image_url VARCHAR(255),
    audio_file_url VARCHAR(255) NOT NULL,
    creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: User Audiobook Library
CREATE TABLE IF NOT EXISTS user_audiobook_library (
    library_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    audiobook_id INT REFERENCES audiobooks(audiobook_id),
    purchase_date DATE,
    is_favorite BOOLEAN DEFAULT FALSE,
    last_played TIMESTAMP,
    progress DECIMAL(5, 2) DEFAULT 0,
    CONSTRAINT user_audiobook_unique UNIQUE (user_id, audiobook_id)
);

-- Table: Audiobook Reviews
CREATE TABLE IF NOT EXISTS audiobook_reviews (
    review_id SERIAL PRIMARY KEY,
    audiobook_id INT REFERENCES audiobooks(audiobook_id),
    user_id INT REFERENCES users(user_id),
    rating INT,
    review_text TEXT,
    review_date TIMESTAMP DEFAULT NOW()
);

-- Table: Audiobook Recordings (for user bookmarks)
CREATE TABLE IF NOT EXISTS audiobook_recordings (
    recording_id SERIAL PRIMARY KEY,
    audiobook_id INT REFERENCES audiobooks(audiobook_id),
    user_id INT REFERENCES users(user_id),
    recorded_time TIMESTAMP DEFAULT NOW(),
    bookmark_position DECIMAL(5, 2)
);

-- Implement any additional tables or constraints as needed.

-- Create indexes for optimization (if necessary)
CREATE INDEX IF NOT EXISTS idx_audiobooks_genre ON audiobooks(genre);
CREATE INDEX IF NOT EXISTS idx_audiobook_reviews_audiobook_id ON audiobook_reviews(audiobook_id);
CREATE INDEX IF NOT EXISTS idx_audiobook_reviews_user_id ON audiobook_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_audiobook_recordings_audiobook_id ON audiobook_recordings(audiobook_id);
CREATE INDEX IF NOT EXISTS idx_audiobook_recordings_user_id ON audiobook_recordings(user_id);

-- Create sequences for serial columns
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq;
CREATE SEQUENCE IF NOT EXISTS audiobooks_audiobook_id_seq;
CREATE SEQUENCE IF NOT EXISTS user_audiobook_library_library_id_seq;
CREATE SEQUENCE IF NOT EXISTS audiobook_reviews_review_id_seq;
CREATE SEQUENCE IF NOT EXISTS audiobook_recordings_recording_id_seq;
