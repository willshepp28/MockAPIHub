-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS garageband_db;

-- Connect to the database
\c garageband_db;

-- Define the schema for the tables

-- Table for Users
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Users table
CREATE INDEX idx_users_email ON users(email);

-- Table for Projects
CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    user_id INT REFERENCES users(user_id),
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Projects table
CREATE INDEX idx_projects_user_id ON projects(user_id);

-- Table for Audio Tracks
CREATE TABLE IF NOT EXISTS audio_tracks (
    track_id SERIAL PRIMARY KEY,
    track_name VARCHAR(100) NOT NULL,
    project_id INT REFERENCES projects(project_id),
    file_path VARCHAR(255) NOT NULL,
    duration INT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Audio Tracks table
CREATE INDEX idx_audio_tracks_project_id ON audio_tracks(project_id);

-- Table for Virtual Instruments
CREATE TABLE IF NOT EXISTS virtual_instruments (
    instrument_id SERIAL PRIMARY KEY,
    instrument_name VARCHAR(100) NOT NULL,
    user_id INT REFERENCES users(user_id),
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Virtual Instruments table
CREATE INDEX idx_virtual_instruments_user_id ON virtual_instruments(user_id);

-- Table for Mixer Settings
CREATE TABLE IF NOT EXISTS mixer_settings (
    mixer_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    audio_track_id INT REFERENCES audio_tracks(track_id),
    volume FLOAT,
    effects VARCHAR(255),
    eq_settings VARCHAR(255),
    last_modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Mixer Settings table
CREATE INDEX idx_mixer_settings_project_id ON mixer_settings(project_id);
CREATE INDEX idx_mixer_settings_audio_track_id ON mixer_settings(audio_track_id);

-- Table for Collaborators (for collaboration feature)
CREATE TABLE IF NOT EXISTS collaborators (
    collaboration_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    user_id INT REFERENCES users(user_id),
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for Collaborators table
CREATE INDEX idx_collaborators_project_id ON collaborators(project_id);
CREATE INDEX idx_collaborators_user_id ON collaborators(user_id);

-- Table for Tutorials
CREATE TABLE IF NOT EXISTS tutorials (
    tutorial_id SERIAL PRIMARY KEY,
    tutorial_title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL
);

-- Index for Tutorials table
CREATE INDEX idx_tutorials_title ON tutorials(tutorial_title);
