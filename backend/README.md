# 🚀 Canteen Backend API
## Node.js + Express + PostgreSQL

Complete REST API for Shree Gajanan Canteen Management System

---

## 📋 Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Server](#running-the-server)
- [API Endpoints](#api-endpoints)
- [Authentication](#authentication)
- [Error Handling](#error-handling)
- [Testing](#testing)

---

## 🛠️ Installation

### Prerequisites

- Node.js 14+ installed
- PostgreSQL database setup (see database/SETUP_GUIDE.md)
- npm or yarn package manager

### Step 1: Install Dependencies

```bash
cd D:\cms\backend
npm install
```

This will install:
- `express` - Web framework
- `pg` - PostgreSQL client
- `cors` - Cross-origin resource sharing
- `bcrypt` - Password hashing
- `jsonwebtoken` - JWT authentication
- `dotenv` - Environment variables
- `nodemon` - Development auto-reload

---

## ⚙️ Configuration

### Step 2: Create Environment File

```bash
# Copy example environment file
cp .env.example .env
```

### Step 3: Edit .env File

```env
# Server Configuration
PORT=3000
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=canteen_db
DB_USER=postgres
DB_PASSWORD=your_database_password

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this

# CORS Configuration
CORS_ORIGIN=http://localhost:8080
```

**⚠️ Important:** Change `JWT_SECRET` to a strong random string in production!

---

## 🚀 Running the Server

### Development Mode (with auto-reload)

```bash
npm run dev
```

### Production Mode

```bash
npm start
```

### Expected Output

```
✅ Connected to PostgreSQL database
🚀 Server running on http://localhost:3000
📊 API documentation: http://localhost:3000/api/health
```

---

## 📡 API Endpoints

### Base URL
```
http://localhost:3000/api
```

---

### 🔐 Authentication Endpoints

#### 1. Register New User

**POST** `/api/auth/register`

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "password123",
  "full_name": "John Doe",
  "email": "john@example.com",
  "phone": "9876543210"
}
```

**Response:** `201 Created`
```json
{
  "message": "User registered successfully",
  "user": {
    "user_id": 1,
    "username": "john_doe",
    "full_name": "John Doe",
    "email": "john@example.com",
    "role": "customer"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 2. Login

**POST** `/api/auth/login`

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "password123"
}
```

**Response:** `200 OK`
```json
{
  "message": "Login successful",
  "user": {
    "user_id": 1,
    "username": "john_doe",
    "full_name": "John Doe",
    "role": "customer",
    "balance": 500.00,
    "loyalty_points": 5
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 👤 User Endpoints

#### 3. Get Current User Profile

**GET** `/api/users/me`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "user_id": 1,
  "username": "john_doe",
  "full_name": "John Doe",
  "email": "john@example.com",
  "phone": "9876543210",
  "role": "customer",
  "balance": 500.00,
  "loyalty_points": 5,
  "has_unclaimed_reward": false
}
```

#### 4. Update User Profile

**PUT** `/api/users/me`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "full_name": "John Updated Doe",
  "email": "newemail@example.com",
  "phone": "9999999999"
}
```

---

### 🍔 Menu Endpoints

#### 5. Get All Menu Items

**GET** `/api/menu`

**Query Parameters:**
- `category` (optional) - Filter by category
- `available` (optional) - Filter by availability (true/false)

**Example:**
```
GET /api/menu?category=Breakfast&available=true
```

**Response:** `200 OK`
```json
[
  {
    "item_id": 1,
    "category": "Breakfast",
    "item_name": "Pohe",
    "description": "Traditional flattened rice",
    "price": 25.00,
    "image_url": "pohe.jpg",
    "is_available": true,
    "is_vegetarian": true
  }
]
```

#### 6. Get Menu Categories

**GET** `/api/menu/categories`

**Response:** `200 OK`
```json
[
  "Tea, Coffee & Milk",
  "Breakfast",
  "Specials & Main Course"
]
```

#### 7. Add Menu Item (Admin Only)

**POST** `/api/menu`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Request Body:**
```json
{
  "category": "Breakfast",
  "item_name": "Masala Dosa",
  "description": "Crispy rice crepe with potato filling",
  "price": 50.00,
  "image_url": "masala_dosa.jpg",
  "is_vegetarian": true
}
```

#### 8. Update Menu Item (Admin Only)

**PUT** `/api/menu/:id`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Request Body:**
```json
{
  "price": 55.00,
  "is_available": false
}
```

#### 9. Delete Menu Item (Admin Only)

**DELETE** `/api/menu/:id`

**Headers:**
```
Authorization: Bearer <admin_token>
```

---

### 🛒 Order Endpoints

#### 10. Create New Order

**POST** `/api/orders`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "items": [
    {
      "item_id": 1,
      "quantity": 2,
      "special_request": "Less spicy"
    },
    {
      "item_id": 5,
      "quantity": 1
    }
  ],
  "table_number": 5,
  "payment_method": "upi",
  "special_instructions": "Please serve hot"
}
```

**Response:** `201 Created`
```json
{
  "message": "Order created successfully",
  "order": {
    "order_id": 1,
    "order_number": "ORD20251105000001",
    "total_amount": 75.00,
    "order_status": "pending"
  }
}
```

#### 11. Get My Orders

**GET** `/api/orders/my-orders`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
[
  {
    "order_id": 1,
    "order_number": "ORD20251105000001",
    "table_number": 5,
    "order_status": "completed",
    "subtotal": 75.00,
    "discount": 0.00,
    "total_amount": 75.00,
    "payment_method": "upi",
    "payment_status": "completed",
    "created_at": "2025-11-05T00:30:00.000Z",
    "items": [
      {
        "item_name": "Pohe",
        "quantity": 2,
        "unit_price": 25.00,
        "subtotal": 50.00
      }
    ]
  }
]
```

#### 12. Get All Orders (Admin Only)

**GET** `/api/orders`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Query Parameters:**
- `status` (optional) - Filter by order status
- `date` (optional) - Filter by date (YYYY-MM-DD)

**Example:**
```
GET /api/orders?status=pending&date=2025-11-05
```

#### 13. Update Order Status (Admin Only)

**PUT** `/api/orders/:id/status`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Request Body:**
```json
{
  "order_status": "completed"
}
```

**Valid Status Values:**
- `pending`
- `confirmed`
- `preparing`
- `ready`
- `completed`
- `cancelled`

---

### 💳 Payment Endpoints

#### 14. Record Payment

**POST** `/api/payments`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "order_id": 1,
  "payment_method": "upi",
  "payment_gateway": "razorpay",
  "transaction_id": "txn_123456789",
  "razorpay_payment_id": "pay_123456789",
  "razorpay_order_id": "order_123456789",
  "amount": 75.00,
  "payment_status": "success"
}
```

**Response:** `201 Created`
```json
{
  "message": "Payment recorded successfully",
  "payment": {
    "payment_id": 1,
    "order_id": 1,
    "transaction_id": "txn_123456789",
    "amount": 75.00,
    "payment_status": "success",
    "payment_date": "2025-11-05T00:35:00.000Z"
  }
}
```

#### 15. Get Payment History

**GET** `/api/payments/history`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
[
  {
    "payment_id": 1,
    "order_number": "ORD20251105000001",
    "payment_method": "upi",
    "transaction_id": "txn_123456789",
    "amount": 75.00,
    "payment_status": "success",
    "payment_date": "2025-11-05T00:35:00.000Z"
  }
]
```

---

### 📊 Reports Endpoints (Admin Only)

#### 16. Daily Sales Report

**GET** `/api/reports/daily-sales`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Response:** `200 OK`
```json
[
  {
    "sale_date": "2025-11-05",
    "total_orders": 25,
    "total_revenue": 3500.00,
    "average_order_value": 140.00,
    "completed_orders": 23,
    "pending_orders": 2
  }
]
```

#### 17. Popular Menu Items

**GET** `/api/reports/popular-items`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Response:** `200 OK`
```json
[
  {
    "item_id": 1,
    "item_name": "Pohe",
    "category": "Breakfast",
    "price": 25.00,
    "times_ordered": 150,
    "total_quantity_sold": 200,
    "total_revenue": 5000.00
  }
]
```

#### 18. Customer Summary

**GET** `/api/reports/customers`

**Headers:**
```
Authorization: Bearer <admin_token>
```

**Response:** `200 OK`
```json
[
  {
    "user_id": 1,
    "username": "john_doe",
    "full_name": "John Doe",
    "total_orders": 15,
    "total_spent": 2500.00,
    "last_order_date": "2025-11-05T00:30:00.000Z",
    "loyalty_points": 15
  }
]
```

---

### 🏥 Health Check

#### 19. API Health Check

**GET** `/api/health`

**Response:** `200 OK`
```json
{
  "status": "OK",
  "message": "Canteen API is running"
}
```

---

## 🔒 Authentication

### JWT Token

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Token Expiry

Tokens expire after 7 days. Client should handle token refresh or re-login.

### Role-Based Access

- **Customer**: Can access own orders, menu, payments
- **Admin**: Can access all endpoints including reports and management

---

## ❌ Error Handling

### Error Response Format

```json
{
  "error": "Error message description"
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 500 | Server Error |

---

## 🧪 Testing

### Using cURL

```bash
# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123","full_name":"Test User"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}'

# Get menu (with token)
curl -X GET http://localhost:3000/api/menu \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Using Postman

1. Import collection (create one with all endpoints)
2. Set environment variable for `token`
3. Test each endpoint

---

## 📦 Deployment

### Production Checklist

- [ ] Change `JWT_SECRET` to strong random string
- [ ] Update database credentials
- [ ] Enable SSL for PostgreSQL
- [ ] Set `NODE_ENV=production`
- [ ] Configure CORS for production domain
- [ ] Set up process manager (PM2)
- [ ] Configure reverse proxy (Nginx)
- [ ] Enable logging
- [ ] Set up monitoring

### Using PM2

```bash
npm install -g pm2
pm2 start server.js --name canteen-api
pm2 save
pm2 startup
```

---

## 🔧 Troubleshooting

### Cannot connect to database

```bash
# Check PostgreSQL is running
# Check .env database credentials
# Verify database exists: psql -U postgres -l
```

### Port already in use

```bash
# Change PORT in .env file
# Or kill process using port 3000
```

### JWT token errors

```bash
# Ensure JWT_SECRET matches between requests
# Check token expiry
# Verify Authorization header format
```

---

## 📚 Additional Resources

- [Express.js Documentation](https://expressjs.com/)
- [PostgreSQL Node.js Tutorial](https://node-postgres.com/)
- [JWT.io](https://jwt.io/)
- [Bcrypt Documentation](https://www.npmjs.com/package/bcrypt)

---

**Version:** 1.0.0  
**Last Updated:** November 2025  
**Status:** Production Ready ✅
