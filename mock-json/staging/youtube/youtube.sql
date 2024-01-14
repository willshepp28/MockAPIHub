-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS youtube_database;

-- Connect to the database
\c youtube_database;

-- Define the schema for the tables

-- Users table to store user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Videos table to store video information
CREATE TABLE IF NOT EXISTS videos (
    video_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    url VARCHAR(255) UNIQUE NOT NULL,
    user_id INT REFERENCES users(user_id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comments table to store user comments on videos
CREATE TABLE IF NOT EXISTS comments (
    comment_id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    video_id INT REFERENCES videos(video_id) NOT NULL,
    user_id INT REFERENCES users(user_id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Likes table to store user likes on videos
CREATE TABLE IF NOT EXISTS likes (
    like_id SERIAL PRIMARY KEY,
    video_id INT REFERENCES videos(video_id) NOT NULL,
    user_id INT REFERENCES users(user_id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscriptions table to store user subscriptions to channels
CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    channel_id INT REFERENCES users(user_id) NOT NULL,
    subscriber_id INT REFERENCES users(user_id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tags table to store video tags for better discoverability
CREATE TABLE IF NOT EXISTS tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);

-- VideoTags table to associate videos with tags
CREATE TABLE IF NOT EXISTS video_tags (
    video_id INT REFERENCES videos(video_id) NOT NULL,
    tag_id INT REFERENCES tags(tag_id) NOT NULL
);

-- Views table to track video views
CREATE TABLE IF NOT EXISTS views (
    view_id SERIAL PRIMARY KEY,
    video_id INT REFERENCES videos(video_id) NOT NULL,
    user_id INT REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
