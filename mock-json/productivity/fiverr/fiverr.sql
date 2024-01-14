-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS fiverr;

-- Connect to the database
\c fiverr;

-- Define the schema for the tables

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (email)
);

-- Services table
CREATE TABLE IF NOT EXISTS services (
    service_id SERIAL PRIMARY KEY,
    seller_id INT REFERENCES users(user_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    availability BOOLEAN DEFAULT TRUE,
    INDEX (category)
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    buyer_id INT REFERENCES users(user_id),
    service_id INT REFERENCES services(service_id),
    order_status VARCHAR(20) NOT NULL,
    order_date TIMESTAMP DEFAULT NOW(),
    requirements TEXT,
    total_amount DECIMAL(10, 2) NOT NULL,
    INDEX (buyer_id),
    INDEX (service_id)
);

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
    review_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    rating INT NOT NULL,
    comment TEXT,
    review_date TIMESTAMP DEFAULT NOW(),
    INDEX (order_id)
);

-- Messages table for communication
CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users(user_id),
    receiver_id INT REFERENCES users(user_id),
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT NOW(),
    INDEX (sender_id),
    INDEX (receiver_id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE,
    INDEX (user_id)
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    UNIQUE (category_name)
);

-- Tags table for service tags
CREATE TABLE IF NOT EXISTS tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL,
    UNIQUE (tag_name)
);

-- ServiceTags table for linking services and tags
CREATE TABLE IF NOT EXISTS service_tags (
    service_id INT REFERENCES services(service_id),
    tag_id INT REFERENCES tags(tag_id),
    PRIMARY KEY (service_id, tag_id)
);

-- Admins table for platform administrators
CREATE TABLE IF NOT EXISTS admins (
    admin_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    UNIQUE (email)
);

-- Payment Transactions table
CREATE TABLE IF NOT EXISTS payment_transactions (
    transaction_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT NOW(),
    INDEX (order_id)
);

-- Implement Foreign Key Constraints
ALTER TABLE services
    ADD CONSTRAINT fk_seller FOREIGN KEY (seller_id) REFERENCES users(user_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_buyer FOREIGN KEY (buyer_id) REFERENCES users(user_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_service FOREIGN KEY (service_id) REFERENCES services(service_id);

ALTER TABLE reviews
    ADD CONSTRAINT fk_review_order FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE messages
    ADD CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users(user_id);

ALTER TABLE messages
    ADD CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(user_id);

ALTER TABLE notifications
    ADD CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE service_tags
    ADD CONSTRAINT fk_service FOREIGN KEY (service_id) REFERENCES services(service_id);

ALTER TABLE service_tags
    ADD CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES tags(tag_id);

ALTER TABLE payment_transactions
    ADD CONSTRAINT fk_transaction_order FOREIGN KEY (order_id) REFERENCES orders(order_id);
