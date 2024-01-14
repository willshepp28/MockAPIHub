-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS discord_database;

-- Connect to the database
\c discord_database;

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

-- Table: Servers
CREATE TABLE IF NOT EXISTS servers (
  server_id SERIAL PRIMARY KEY,
  server_name VARCHAR(255) NOT NULL,
  server_description TEXT,
  owner_user_id INT REFERENCES users(user_id),
  creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: Channels
CREATE TABLE IF NOT EXISTS channels (
  channel_id SERIAL PRIMARY KEY,
  channel_name VARCHAR(255) NOT NULL,
  channel_description TEXT,
  server_id INT REFERENCES servers(server_id),
  creation_date TIMESTAMP DEFAULT NOW()
);

-- Table: Messages
CREATE TABLE IF NOT EXISTS messages (
  message_id SERIAL PRIMARY KEY,
  message_text TEXT,
  sender_user_id INT REFERENCES users(user_id),
  channel_id INT REFERENCES channels(channel_id),
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Table: Friends (for social features)
CREATE TABLE IF NOT EXISTS friends (
  friendship_id SERIAL PRIMARY KEY,
  user_id1 INT REFERENCES users(user_id),
  user_id2 INT REFERENCES users(user_id),
  date_connected TIMESTAMP DEFAULT NOW()
);

-- Create indexes for optimization (if necessary)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_servers_owner_user_id ON servers(owner_user_id);
CREATE INDEX IF NOT EXISTS idx_channels_server_id ON channels(server_id);
CREATE INDEX IF NOT EXISTS idx_messages_channel_id ON messages(channel_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_user_id ON messages(sender_user_id);
CREATE INDEX IF NOT EXISTS idx_friends_user_id1 ON friends(user_id1);
CREATE INDEX IF NOT EXISTS idx_friends_user_id2 ON friends(user_id2);

-- Create sequences for serial columns
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq;
CREATE SEQUENCE IF NOT EXISTS servers_server_id_seq;
CREATE SEQUENCE IF NOT EXISTS channels_channel_id_seq;
CREATE SEQUENCE IF NOT EXISTS messages_message_id_seq;
CREATE SEQUENCE IF NOT EXISTS friends_friendship_id_seq;
