-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS evernote;

-- Connect to the database
\c evernote;

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

-- Table: Notes
CREATE TABLE IF NOT EXISTS notes (
    note_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_by_user_id INT REFERENCES users(user_id),
    creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: Tags
CREATE TABLE IF NOT EXISTS tags (
    tag_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Table: NoteTags (Many-to-Many relationship between Notes and Tags)
CREATE TABLE IF NOT EXISTS note_tags (
    note_id INT REFERENCES notes(note_id),
    tag_id INT REFERENCES tags(tag_id),
    PRIMARY KEY (note_id, tag_id)
);

-- Table: Notebooks
CREATE TABLE IF NOT EXISTS notebooks (
    notebook_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_by_user_id INT REFERENCES users(user_id),
    creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: NotebookNotes (Many-to-Many relationship between Notebooks and Notes)
CREATE TABLE IF NOT EXISTS notebook_notes (
    notebook_id INT REFERENCES notebooks(notebook_id),
    note_id INT REFERENCES notes(note_id),
    PRIMARY KEY (notebook_id, note_id)
);

-- Implement any additional tables or constraints as needed.

-- Create indexes for optimization (if necessary)
CREATE INDEX IF NOT EXISTS idx_notes_created_by_user_id ON notes(created_by_user_id);
CREATE INDEX IF NOT EXISTS idx_note_tags_tag_id ON note_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_notebooks_created_by_user_id ON notebooks(created_by_user_id);
CREATE INDEX IF NOT EXISTS idx_notebook_notes_note_id ON notebook_notes(note_id);

-- Create sequences for serial columns
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq;
CREATE SEQUENCE IF NOT EXISTS notes_note_id_seq;
CREATE SEQUENCE IF NOT EXISTS tags_tag_id_seq;
CREATE SEQUENCE IF NOT EXISTS notebooks_notebook_id_seq;
