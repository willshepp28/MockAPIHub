-- Create the User table to store user information
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    profile_picture_url TEXT,
    registration_date TIMESTAMP DEFAULT NOW(),
);

-- Create the ExpenseCategory table to store expense categories
CREATE TABLE expense_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
);

-- Create the Expense table to store user expenses
CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    date DATE NOT NULL,
    description TEXT,
    amount DECIMAL(10, 2) NOT NULL,
    category_id INT REFERENCES expense_categories(category_id),
);

-- Create the Budget table to store user budgets
CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    category_id INT REFERENCES expense_categories(category_id),
    budget_amount DECIMAL(10, 2) NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
);

-- Create the FinancialOverview table to store user's financial data
CREATE TABLE financial_overview (
    overview_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50),
    balance DECIMAL(10, 2) NOT NULL,
);

-- Create the Notifications table to store user notifications
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT NOW(),
);

-- Create the Feedback table to store user feedback
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    feedback_text TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT NOW(),
);


