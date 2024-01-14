-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS duolingo_database;

-- Connect to the database
\c duolingo_database;

-- Define the schema for the tables

-- Table: Users
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    profile_picture VARCHAR(255),
    bio TEXT,
    registration_date TIMESTAMP DEFAULT NOW()
);

-- Table: Languages
CREATE TABLE IF NOT EXISTS languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);

-- Table: User_Languages (Many-to-Many Relationship between Users and Languages)
CREATE TABLE IF NOT EXISTS user_languages (
    user_language_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    language_id INT REFERENCES languages(language_id)
);

-- Table: Courses
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    language_id INT REFERENCES languages(language_id),
    skill_level VARCHAR(20),
    description TEXT,
    creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: Lessons
CREATE TABLE IF NOT EXISTS lessons (
    lesson_id SERIAL PRIMARY KEY,
    lesson_name VARCHAR(100) NOT NULL,
    course_id INT REFERENCES courses(course_id),
    module_number INT,
    lesson_number INT,
    lesson_content TEXT,
    completion_date TIMESTAMP,
    FOREIGN KEY (course_id, module_number) REFERENCES modules(course_id, module_number)
);

-- Table: Modules
CREATE TABLE IF NOT EXISTS modules (
    module_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(course_id),
    module_number INT,
    module_name VARCHAR(100) NOT NULL,
    module_description TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Table: User_Progress (Many-to-Many Relationship between Users and Lessons)
CREATE TABLE IF NOT EXISTS user_progress (
    user_progress_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    lesson_id INT REFERENCES lessons(lesson_id),
    completion_status BOOLEAN,
    progress_date TIMESTAMP DEFAULT NOW()
);

-- Implement any additional tables or constraints as needed.

-- Create indexes for optimization (if necessary)
CREATE INDEX IF NOT EXISTS idx_courses_language_id ON courses(language_id);
CREATE INDEX IF NOT EXISTS idx_lessons_course_id ON lessons(course_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_lesson_id ON user_progress(lesson_id);

-- Create sequences for serial columns
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq;
CREATE SEQUENCE IF NOT EXISTS languages_language_id_seq;
CREATE SEQUENCE IF NOT EXISTS courses_course_id_seq;
CREATE SEQUENCE IF NOT EXISTS modules_module_id_seq;
CREATE SEQUENCE IF NOT EXISTS lessons_lesson_id_seq;
CREATE SEQUENCE IF NOT EXISTS user_progress_user_progress_id_seq;
