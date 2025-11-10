// ================================================
// Shree Gajanan Canteen - Backend API Server
// Node.js + Express + PostgreSQL
// ================================================

const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// ================================================
// MIDDLEWARE
// ================================================
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (images) from the cms directory
app.use('/images', express.static(path.join(__dirname, '../')));
app.use('/api/images', express.static(path.join(__dirname, '../')));

// ================================================
// DATABASE CONNECTION
// ================================================
const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'canteen_db',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'your_password',
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Test database connection
pool.connect((err, client, release) => {
    if (err) {
        console.error('❌ Error connecting to database:', err.stack);
    } else {
        console.log('✅ Connected to PostgreSQL database');
        release();
    }
});

// ================================================
// AUTHENTICATION MIDDLEWARE
// ================================================
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid or expired token' });
        }
        req.user = user;
        next();
    });
};

const isAdmin = (req, res, next) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Admin access required' });
    }
    next();
};

// ================================================
// AUTHENTICATION ROUTES
// ================================================

// User Registration
app.post('/api/auth/register', async (req, res) => {
    try {
        const { username, password, full_name, email, phone } = req.body;

        // Validate input
        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }

        // Check if user exists
        const userExists = await pool.query(
            'SELECT user_id FROM users WHERE username = $1 OR email = $2',
            [username, email]
        );

        if (userExists.rows.length > 0) {
            return res.status(409).json({ error: 'Username or email already exists' });
        }

        // Hash password
        const password_hash = await bcrypt.hash(password, 10);

        // Insert user
        const result = await pool.query(
            `INSERT INTO users (username, password_hash, full_name, email, phone, role) 
             VALUES ($1, $2, $3, $4, $5, 'customer') 
             RETURNING user_id, username, full_name, email, role, created_at`,
            [username, password_hash, full_name, email, phone]
        );

        const user = result.rows[0];

        // Generate JWT token
        const token = jwt.sign(
            { user_id: user.user_id, username: user.username, role: user.role },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.status(201).json({
            message: 'User registered successfully',
            user: {
                user_id: user.user_id,
                username: user.username,
                full_name: user.full_name,
                email: user.email,
                role: user.role
            },
            token
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Server error during registration' });
    }
});

// User Login
app.post('/api/auth/login', async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }

        // Get user from database
        const result = await pool.query(
            'SELECT * FROM users WHERE username = $1 AND is_active = true',
            [username]
        );

        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const user = result.rows[0];

        // Verify password
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        // Update last login
        await pool.query(
            'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = $1',
            [user.user_id]
        );

        // Generate JWT token
        const token = jwt.sign(
            { user_id: user.user_id, username: user.username, role: user.role },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.json({
            message: 'Login successful',
            user: {
                user_id: user.user_id,
                username: user.username,
                full_name: user.full_name,
                email: user.email,
                role: user.role,
                balance: parseFloat(user.balance),
                loyalty_points: user.loyalty_points
            },
            token
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Server error during login' });
    }
});

// ================================================
// USER ROUTES
// ================================================

// Get current user profile
app.get('/api/users/me', authenticateToken, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT user_id, username, full_name, email, phone, role, balance, 
                    loyalty_points, has_unclaimed_reward, created_at, last_login 
             FROM users WHERE user_id = $1`,
            [req.user.user_id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Update user profile
app.put('/api/users/me', authenticateToken, async (req, res) => {
    try {
        const { full_name, email, phone } = req.body;

        const result = await pool.query(
            `UPDATE users 
             SET full_name = COALESCE($1, full_name),
                 email = COALESCE($2, email),
                 phone = COALESCE($3, phone)
             WHERE user_id = $4
             RETURNING user_id, username, full_name, email, phone`,
            [full_name, email, phone, req.user.user_id]
        );

        res.json({
            message: 'Profile updated successfully',
            user: result.rows[0]
        });
    } catch (error) {
        console.error('Update user error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// MENU ROUTES
// ================================================

// Get all menu items
app.get('/api/menu', async (req, res) => {
    try {
        const { category, available } = req.query;
        
        let query = 'SELECT * FROM menu_items WHERE 1=1';
        const params = [];
        let paramCount = 1;

        if (category) {
            query += ` AND category = $${paramCount}`;
            params.push(category);
            paramCount++;
        }

        if (available !== undefined) {
            query += ` AND is_available = $${paramCount}`;
            params.push(available === 'true');
            paramCount++;
        }

        query += ' ORDER BY category, item_name';

        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (error) {
        console.error('Get menu error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get menu categories
app.get('/api/menu/categories', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT DISTINCT category FROM menu_items ORDER BY category'
        );
        res.json(result.rows.map(row => row.category));
    } catch (error) {
        console.error('Get categories error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Add menu item (Admin only)
app.post('/api/menu', authenticateToken, isAdmin, async (req, res) => {
    try {
        const { category, item_name, description, price, image_url, is_vegetarian } = req.body;

        const result = await pool.query(
            `INSERT INTO menu_items (category, item_name, description, price, image_url, is_vegetarian)
             VALUES ($1, $2, $3, $4, $5, $6)
             RETURNING *`,
            [category, item_name, description, price, image_url, is_vegetarian]
        );

        res.status(201).json({
            message: 'Menu item added successfully',
            item: result.rows[0]
        });
    } catch (error) {
        console.error('Add menu item error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Update menu item (Admin only)
app.put('/api/menu/:id', authenticateToken, isAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { category, item_name, description, price, image_url, is_available, is_vegetarian } = req.body;

        const result = await pool.query(
            `UPDATE menu_items 
             SET category = COALESCE($1, category),
                 item_name = COALESCE($2, item_name),
                 description = COALESCE($3, description),
                 price = COALESCE($4, price),
                 image_url = COALESCE($5, image_url),
                 is_available = COALESCE($6, is_available),
                 is_vegetarian = COALESCE($7, is_vegetarian)
             WHERE item_id = $8
             RETURNING *`,
            [category, item_name, description, price, image_url, is_available, is_vegetarian, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Menu item not found' });
        }

        res.json({
            message: 'Menu item updated successfully',
            item: result.rows[0]
        });
    } catch (error) {
        console.error('Update menu item error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Delete menu item (Admin only)
app.delete('/api/menu/:id', authenticateToken, isAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const result = await pool.query(
            'DELETE FROM menu_items WHERE item_id = $1 RETURNING item_id',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Menu item not found' });
        }

        res.json({ message: 'Menu item deleted successfully' });
    } catch (error) {
        console.error('Delete menu item error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// ORDER ROUTES
// ================================================

// Create new order
app.post('/api/orders', authenticateToken, async (req, res) => {
    const client = await pool.connect();
    
    try {
        await client.query('BEGIN');

        const { items, table_number, payment_method, special_instructions } = req.body;
        const user_id = req.user.user_id;

        if (!items || items.length === 0) {
            return res.status(400).json({ error: 'Order must contain at least one item' });
        }

        // Calculate totals
        let subtotal = 0;
        for (const item of items) {
            const menuItem = await client.query(
                'SELECT price FROM menu_items WHERE item_id = $1',
                [item.item_id]
            );
            if (menuItem.rows.length === 0) {
                throw new Error(`Item ${item.item_id} not found`);
            }
            subtotal += menuItem.rows[0].price * item.quantity;
        }

        const discount = subtotal > 500 ? subtotal * 0.05 : 0;
        const tax = 0; // Add tax calculation if needed
        const total_amount = subtotal - discount + tax;

        // Create order
        const orderResult = await client.query(
            `INSERT INTO orders (user_id, table_number, order_status, subtotal, discount, tax, total_amount, payment_method, payment_status, special_instructions)
             VALUES ($1, $2, 'pending', $3, $4, $5, $6, $7, 'pending', $8)
             RETURNING *`,
            [user_id, table_number, subtotal, discount, tax, total_amount, payment_method, special_instructions]
        );

        const order = orderResult.rows[0];

        // Insert order items
        for (const item of items) {
            const menuItem = await client.query(
                'SELECT item_name, price FROM menu_items WHERE item_id = $1',
                [item.item_id]
            );

            await client.query(
                `INSERT INTO order_items (order_id, item_id, item_name, quantity, unit_price, subtotal, special_request)
                 VALUES ($1, $2, $3, $4, $5, $6, $7)`,
                [
                    order.order_id,
                    item.item_id,
                    menuItem.rows[0].item_name,
                    item.quantity,
                    menuItem.rows[0].price,
                    menuItem.rows[0].price * item.quantity,
                    item.special_request
                ]
            );
        }

        await client.query('COMMIT');

        res.status(201).json({
            message: 'Order created successfully',
            order: {
                order_id: order.order_id,
                order_number: order.order_number,
                total_amount: parseFloat(order.total_amount),
                order_status: order.order_status
            }
        });
    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Create order error:', error);
        res.status(500).json({ error: 'Server error creating order' });
    } finally {
        client.release();
    }
});

// Get user's orders
app.get('/api/orders/my-orders', authenticateToken, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT o.*, 
                    json_agg(json_build_object(
                        'item_name', oi.item_name,
                        'quantity', oi.quantity,
                        'unit_price', oi.unit_price,
                        'subtotal', oi.subtotal
                    )) as items
             FROM orders o
             LEFT JOIN order_items oi ON o.order_id = oi.order_id
             WHERE o.user_id = $1
             GROUP BY o.order_id
             ORDER BY o.created_at DESC`,
            [req.user.user_id]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Get orders error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get all orders (Admin only)
app.get('/api/orders', authenticateToken, isAdmin, async (req, res) => {
    try {
        const { status, date } = req.query;
        
        let query = `
            SELECT o.*, u.username, u.full_name,
                   json_agg(json_build_object(
                       'item_name', oi.item_name,
                       'quantity', oi.quantity,
                       'unit_price', oi.unit_price
                   )) as items
            FROM orders o
            LEFT JOIN users u ON o.user_id = u.user_id
            LEFT JOIN order_items oi ON o.order_id = oi.order_id
            WHERE 1=1
        `;
        
        const params = [];
        let paramCount = 1;

        if (status) {
            query += ` AND o.order_status = $${paramCount}`;
            params.push(status);
            paramCount++;
        }

        if (date) {
            query += ` AND DATE(o.created_at) = $${paramCount}`;
            params.push(date);
            paramCount++;
        }

        query += ' GROUP BY o.order_id, u.username, u.full_name ORDER BY o.created_at DESC';

        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (error) {
        console.error('Get all orders error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Update order status (Admin only)
app.put('/api/orders/:id/status', authenticateToken, isAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { order_status } = req.body;

        const result = await pool.query(
            `UPDATE orders 
             SET order_status = $1,
                 completed_at = CASE WHEN $1 = 'completed' THEN CURRENT_TIMESTAMP ELSE completed_at END
             WHERE order_id = $2
             RETURNING *`,
            [order_status, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Order not found' });
        }

        res.json({
            message: 'Order status updated successfully',
            order: result.rows[0]
        });
    } catch (error) {
        console.error('Update order status error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// PAYMENT ROUTES
// ================================================

// Record payment
app.post('/api/payments', authenticateToken, async (req, res) => {
    try {
        const {
            order_id,
            payment_method,
            payment_gateway,
            transaction_id,
            razorpay_payment_id,
            razorpay_order_id,
            amount,
            payment_status
        } = req.body;

        const result = await pool.query(
            `INSERT INTO payment_history 
             (order_id, user_id, payment_method, payment_gateway, transaction_id, 
              razorpay_payment_id, razorpay_order_id, amount, payment_status)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
             RETURNING *`,
            [
                order_id,
                req.user.user_id,
                payment_method,
                payment_gateway,
                transaction_id,
                razorpay_payment_id,
                razorpay_order_id,
                amount,
                payment_status
            ]
        );

        // Update order payment status
        if (payment_status === 'success') {
            await pool.query(
                'UPDATE orders SET payment_status = $1 WHERE order_id = $2',
                ['completed', order_id]
            );
        }

        res.status(201).json({
            message: 'Payment recorded successfully',
            payment: result.rows[0]
        });
    } catch (error) {
        console.error('Record payment error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get payment history
app.get('/api/payments/history', authenticateToken, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT ph.*, o.order_number, o.total_amount as order_amount
             FROM payment_history ph
             LEFT JOIN orders o ON ph.order_id = o.order_id
             WHERE ph.user_id = $1
             ORDER BY ph.payment_date DESC`,
            [req.user.user_id]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Get payment history error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// REPORTS & ANALYTICS (Admin only)
// ================================================

// Daily sales report
app.get('/api/reports/daily-sales', authenticateToken, isAdmin, async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM daily_sales_report LIMIT 30');
        res.json(result.rows);
    } catch (error) {
        console.error('Daily sales report error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Popular menu items
app.get('/api/reports/popular-items', authenticateToken, isAdmin, async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM popular_menu_items LIMIT 20');
        res.json(result.rows);
    } catch (error) {
        console.error('Popular items report error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Customer summary
app.get('/api/reports/customers', authenticateToken, isAdmin, async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM customer_order_summary');
        res.json(result.rows);
    } catch (error) {
        console.error('Customer summary error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// RECEIPT ROUTES
// ================================================

// Generate and store receipt
app.post('/api/receipts', authenticateToken, async (req, res) => {
    try {
        const {
            order_id,
            payment_id,
            payment_method,
            items,
            subtotal,
            discount,
            tax,
            total_amount
        } = req.body;

        const receiptNumber = `RCP${Date.now().toString().slice(-8)}`;
        
        const result = await pool.query(
            `INSERT INTO receipts 
             (receipt_number, order_id, user_id, payment_id, payment_method, 
              items_json, subtotal, discount, tax, total_amount)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
             RETURNING *`,
            [
                receiptNumber,
                order_id,
                req.user.user_id,
                payment_id,
                payment_method,
                JSON.stringify(items),
                subtotal,
                discount,
                tax,
                total_amount
            ]
        );

        res.status(201).json({
            message: 'Receipt generated successfully',
            receipt: result.rows[0]
        });
    } catch (error) {
        console.error('Generate receipt error:', error);
        res.status(500).json({ error: 'Server error generating receipt' });
    }
});

// Get receipt by ID
app.get('/api/receipts/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            `SELECT r.*, o.order_number, u.username, u.full_name
             FROM receipts r
             LEFT JOIN orders o ON r.order_id = o.order_id
             LEFT JOIN users u ON r.user_id = u.user_id
             WHERE r.receipt_id = $1 AND r.user_id = $2`,
            [id, req.user.user_id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Receipt not found' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Get receipt error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get user's receipts
app.get('/api/receipts', authenticateToken, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT r.*, o.order_number
             FROM receipts r
             LEFT JOIN orders o ON r.order_id = o.order_id
             WHERE r.user_id = $1
             ORDER BY r.created_at DESC`,
            [req.user.user_id]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Get receipts error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ================================================
// HEALTH CHECK
// ================================================
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', message: 'Canteen API is running' });
});

// ================================================
// ERROR HANDLING
// ================================================
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// ================================================
// START SERVER
// ================================================
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`📊 API documentation: http://localhost:${PORT}/api/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server');
    pool.end(() => {
        console.log('Database pool closed');
        process.exit(0);
    });
});
