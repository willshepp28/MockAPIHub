-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS your_database_name;

-- Connect to the database
\c your_database_name;

-- Define the schema for the tables

-- Users table to store user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Files table to store information about uploaded files
CREATE TABLE IF NOT EXISTS files (
    file_id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    upload_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Shared files table to store information about shared files
CREATE TABLE IF NOT EXISTS shared_files (
    share_id SERIAL PRIMARY KEY,
    file_id INT NOT NULL,
    shared_with_user_id INT NOT NULL,
    FOREIGN KEY (file_id) REFERENCES files(file_id),
    FOREIGN KEY (shared_with_user_id) REFERENCES users(user_id)
);

-- Permissions table to manage access control
CREATE TABLE IF NOT EXISTS permissions (
    permission_id SERIAL PRIMARY KEY,
    file_id INT NOT NULL,
    user_id INT NOT NULL,
    permission_type VARCHAR(10) NOT NULL,
    FOREIGN KEY (file_id) REFERENCES files(file_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Activity log table to track user actions
CREATE TABLE IF NOT EXISTS activity_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    file_id INT,
    action_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (file_id) REFERENCES files(file_id)
);
