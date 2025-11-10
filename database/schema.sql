-- ================================================
-- Shree Gajanan Canteen Database Schema
-- PostgreSQL Database
-- ================================================

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS receipts CASCADE;
DROP TABLE IF EXISTS payment_history CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ================================================
-- 1. USERS TABLE
-- ================================================
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    role VARCHAR(20) DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'staff')),
    balance DECIMAL(10, 2) DEFAULT 0.00,
    loyalty_points INTEGER DEFAULT 0,
    has_unclaimed_reward BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create index for faster lookups
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ================================================
-- 2. MENU ITEMS TABLE
-- ================================================
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    is_vegetarian BOOLEAN DEFAULT TRUE,
    preparation_time INTEGER DEFAULT 10, -- in minutes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for category filtering
CREATE INDEX idx_menu_category ON menu_items(category);
CREATE INDEX idx_menu_available ON menu_items(is_available);

-- ================================================
-- 3. ORDERS TABLE
-- ================================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    table_number INTEGER,
    order_status VARCHAR(20) DEFAULT 'pending' CHECK (order_status IN ('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled')),
    subtotal DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    tax DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(20) CHECK (payment_method IN ('cash', 'upi', 'card', 'wallet')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    order_type VARCHAR(20) DEFAULT 'dine-in' CHECK (order_type IN ('dine-in', 'takeaway', 'delivery')),
    special_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Create indexes for faster queries
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_number ON orders(order_number);

-- ================================================
-- 4. ORDER ITEMS TABLE
-- ================================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INTEGER REFERENCES menu_items(item_id) ON DELETE SET NULL,
    item_name VARCHAR(150) NOT NULL, -- Store name in case item is deleted
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    special_request TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for order lookup
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_item ON order_items(item_id);

-- ================================================
-- 5. PAYMENT HISTORY TABLE
-- ================================================
CREATE TABLE payment_history (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    payment_method VARCHAR(20) NOT NULL,
    payment_gateway VARCHAR(50), -- e.g., 'razorpay', 'stripe'
    transaction_id VARCHAR(100) UNIQUE,
    razorpay_payment_id VARCHAR(100),
    razorpay_order_id VARCHAR(100),
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'INR',
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'success', 'failed', 'refunded')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    refund_amount DECIMAL(10, 2) DEFAULT 0.00,
    refund_date TIMESTAMP,
    failure_reason TEXT,
    metadata JSONB, -- Store additional payment gateway data
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for payment tracking
CREATE INDEX idx_payment_order ON payment_history(order_id);
CREATE INDEX idx_payment_user ON payment_history(user_id);
CREATE INDEX idx_payment_status ON payment_history(payment_status);
CREATE INDEX idx_payment_transaction ON payment_history(transaction_id);
CREATE INDEX idx_payment_date ON payment_history(payment_date);

-- ================================================
-- 6. LOYALTY VISITS TABLE (for reward tracking)
-- ================================================
CREATE TABLE loyalty_visits (
    visit_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE SET NULL,
    points_earned INTEGER DEFAULT 1
);

CREATE INDEX idx_loyalty_user ON loyalty_visits(user_id);
CREATE INDEX idx_loyalty_date ON loyalty_visits(visit_date);

-- ================================================
-- 7. RECEIPTS TABLE
-- ================================================
CREATE TABLE receipts (
    receipt_id SERIAL PRIMARY KEY,
    receipt_number VARCHAR(20) UNIQUE NOT NULL,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE SET NULL,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    payment_id VARCHAR(100), -- Reference to payment transaction
    payment_method VARCHAR(20) NOT NULL,
    items_json JSONB NOT NULL, -- Store receipt items as JSON
    subtotal DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    tax DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    receipt_data JSONB, -- Store complete receipt HTML/data
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for receipt tracking
CREATE INDEX idx_receipts_order ON receipts(order_id);
CREATE INDEX idx_receipts_user ON receipts(user_id);
CREATE INDEX idx_receipts_number ON receipts(receipt_number);
CREATE INDEX idx_receipts_payment ON receipts(payment_id);
CREATE INDEX idx_receipts_created_at ON receipts(created_at);

-- ================================================
-- FUNCTIONS AND TRIGGERS
-- ================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_receipts_updated_at BEFORE UPDATE ON receipts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_number = 'ORD' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD') || LPAD(NEW.order_id::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate order number
CREATE TRIGGER set_order_number BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- ================================================
-- SAMPLE DATA (Optional - for testing)
-- ================================================

-- Insert admin user (password: admin123 - should be hashed in production)
INSERT INTO users (username, password_hash, full_name, email, phone, role, balance) VALUES
('admin', '$2b$10$rKvVLZ5Z5Z5Z5Z5Z5Z5Z5uXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxX', 'Admin User', 'admin@canteen.com', '9999999999', 'admin', 0.00);

-- Insert sample customers
INSERT INTO users (username, password_hash, full_name, email, phone, role, balance, loyalty_points) VALUES
('john_doe', '$2b$10$hashedpassword1', 'John Doe', 'john@example.com', '9876543210', 'customer', 500.00, 5),
('jane_smith', '$2b$10$hashedpassword2', 'Jane Smith', 'jane@example.com', '9876543211', 'customer', 300.00, 3),
('raj_kumar', '$2b$10$hashedpassword3', 'Raj Kumar', 'raj@example.com', '9876543212', 'customer', 750.00, 8);

-- Insert sample menu items
INSERT INTO menu_items (category, item_name, description, price, image_url, is_vegetarian) VALUES
('Tea, Coffee & Milk', 'Tea', 'Classic Indian chai', 10.00, 'chai.jpg', TRUE),
('Tea, Coffee & Milk', 'Special Tea', 'Premium masala chai', 15.00, 'special_chai.jpg', TRUE),
('Tea, Coffee & Milk', 'Coffee', 'Fresh brewed coffee', 15.00, 'coffee.jpg', TRUE),
('Tea, Coffee & Milk', 'Cold Chocolate Milk', 'Chilled chocolate milk', 25.00, 'cold_chocolate_milk.jpg', TRUE),
('Breakfast', 'Pohe', 'Traditional flattened rice', 25.00, 'pohe.jpg', TRUE),
('Breakfast', 'Vada Pav', 'Mumbai street food special', 15.00, 'vada_pav.jpg', TRUE),
('Breakfast', 'Idli Sambar', 'South Indian steamed rice cakes', 40.00, 'idli_sambar.jpg', TRUE),
('Specials & Main Course', 'Paneer Masala', 'Cottage cheese in rich gravy', 120.00, 'paneer_masala.jpg', TRUE),
('Specials & Main Course', 'Dal Fry', 'Tempered lentils', 50.00, 'dal_fry.jpg', TRUE),
('Specials & Main Course', 'Paneer Pulao', 'Fragrant rice with cottage cheese', 120.00, 'paneer_pulao.jpg', TRUE);

-- ================================================
-- VIEWS FOR REPORTING
-- ================================================

-- View for daily sales report
CREATE OR REPLACE VIEW daily_sales_report AS
SELECT 
    DATE(created_at) as sale_date,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as average_order_value,
    COUNT(CASE WHEN payment_status = 'completed' THEN 1 END) as completed_orders,
    COUNT(CASE WHEN payment_status = 'pending' THEN 1 END) as pending_orders
FROM orders
GROUP BY DATE(created_at)
ORDER BY sale_date DESC;

-- View for popular menu items
CREATE OR REPLACE VIEW popular_menu_items AS
SELECT 
    mi.item_id,
    mi.item_name,
    mi.category,
    mi.price,
    COUNT(oi.order_item_id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.subtotal) as total_revenue
FROM menu_items mi
LEFT JOIN order_items oi ON mi.item_id = oi.item_id
GROUP BY mi.item_id, mi.item_name, mi.category, mi.price
ORDER BY times_ordered DESC;

-- View for customer order history
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    MAX(o.created_at) as last_order_date,
    u.loyalty_points
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.role = 'customer'
GROUP BY u.user_id, u.username, u.full_name, u.loyalty_points
ORDER BY total_spent DESC;

-- ================================================
-- GRANT PERMISSIONS (adjust as needed)
-- ================================================

-- Grant permissions to application user
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO canteen_app_user;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO canteen_app_user;

-- ================================================
-- COMMENTS
-- ================================================

COMMENT ON TABLE users IS 'Stores customer and admin user information';
COMMENT ON TABLE menu_items IS 'Stores all menu items available in the canteen';
COMMENT ON TABLE orders IS 'Stores all order information';
COMMENT ON TABLE order_items IS 'Stores individual items in each order';
COMMENT ON TABLE payment_history IS 'Tracks all payment transactions';
COMMENT ON TABLE loyalty_visits IS 'Tracks customer visits for loyalty rewards';
COMMENT ON TABLE receipts IS 'Stores generated receipts for orders and payments';

-- ================================================
-- END OF SCHEMA
-- ================================================
