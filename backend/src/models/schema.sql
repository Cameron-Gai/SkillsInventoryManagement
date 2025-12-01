-- schema.sql
-- Database schema for Skills Inventory Management System
-- Run this SQL to create the users table

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'employee' CHECK (role IN ('employee', 'manager', 'admin')),
    department VARCHAR(100),
    position VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Create index on role for filtering
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for testing (optional)
-- Password hash is for 'password123' - CHANGE THIS IN PRODUCTION!
INSERT INTO users (email, password_hash, first_name, last_name, role, department, position, phone)
VALUES 
    ('employee@example.com', '$2b$10$example_hash_here', 'John', 'Doe', 'employee', 'Engineering', 'Software Developer', '555-0100'),
    ('manager@example.com', '$2b$10$example_hash_here', 'Jane', 'Smith', 'manager', 'Engineering', 'Engineering Manager', '555-0101'),
    ('admin@example.com', '$2b$10$example_hash_here', 'Admin', 'User', 'admin', 'IT', 'System Administrator', '555-0102')
ON CONFLICT (email) DO NOTHING;


