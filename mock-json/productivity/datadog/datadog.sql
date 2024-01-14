-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS datadog;

-- Connect to the database
\c datadog;

-- Define the schema for the tables

-- Table to store monitored hosts or servers
CREATE TABLE IF NOT EXISTS hosts (
    host_id SERIAL PRIMARY KEY,
    host_name VARCHAR(255) NOT NULL,
    ip_address VARCHAR(15) NOT NULL,
    location VARCHAR(100),
    operating_system VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store metrics data
CREATE TABLE IF NOT EXISTS metrics (
    metric_id SERIAL PRIMARY KEY,
    host_id INT REFERENCES hosts(host_id),
    metric_name VARCHAR(255) NOT NULL,
    metric_value NUMERIC,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store log data
CREATE TABLE IF NOT EXISTS logs (
    log_id SERIAL PRIMARY KEY,
    host_id INT REFERENCES hosts(host_id),
    log_message TEXT,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store alert definitions
CREATE TABLE IF NOT EXISTS alerts (
    alert_id SERIAL PRIMARY KEY,
    metric_id INT REFERENCES metrics(metric_id),
    alert_name VARCHAR(255) NOT NULL,
    threshold NUMERIC NOT NULL,
    notification_channel VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store users and their access permissions
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store user roles and permissions
CREATE TABLE IF NOT EXISTS user_roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to associate users with roles
CREATE TABLE IF NOT EXISTS user_roles_mapping (
    user_id INT REFERENCES users(user_id),
    role_id INT REFERENCES user_roles(role_id),
    PRIMARY KEY (user_id, role_id)
);

-- Table to store historical data for metrics and logs (optional)
CREATE TABLE IF NOT EXISTS historical_data (
    data_id SERIAL PRIMARY KEY,
    host_id INT REFERENCES hosts(host_id),
    metric_name VARCHAR(255) NOT NULL,
    metric_value NUMERIC,
    log_message TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance optimization
CREATE INDEX IF NOT EXISTS host_metrics_index ON metrics(host_id);
CREATE INDEX IF NOT EXISTS host_logs_index ON logs(host_id);
CREATE INDEX IF NOT EXISTS metric_timestamp_index ON metrics(timestamp);
CREATE INDEX IF NOT EXISTS log_timestamp_index ON logs(log_timestamp);
CREATE INDEX IF NOT EXISTS alert_metric_index ON alerts(metric_id);
CREATE INDEX IF NOT EXISTS user_roles_mapping_index ON user_roles_mapping(user_id, role_id);
