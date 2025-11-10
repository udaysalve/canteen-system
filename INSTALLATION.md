# 🚀 Complete Installation Guide
## Shree Gajanan Canteen Management System with PostgreSQL Database

---

## 📋 Overview

This guide will help you set up the complete canteen management system with:
- ✅ PostgreSQL Database
- ✅ Node.js Backend API
- ✅ Frontend Application
- ✅ Payment Gateway Integration

---

## 🛠️ Prerequisites

### Required Software

1. **PostgreSQL** (v12 or higher)
   - Download: https://www.postgresql.org/download/

2. **Node.js** (v14 or higher)
   - Download: https://nodejs.org/

3. **Python** (for running frontend)
   - Download: https://www.python.org/downloads/

4. **Git** (optional)
   - Download: https://git-scm.com/downloads

---

## 📦 Step-by-Step Installation

### STEP 1: Install PostgreSQL Database

#### 1.1 Install PostgreSQL

```bash
# Windows: Run the installer from postgresql.org
# During installation, remember the password for 'postgres' user

# Verify installation
psql --version
```

#### 1.2 Create Database

```bash
# Open Command Prompt or PowerShell
cd D:\cms\database

# Connect to PostgreSQL
psql -U postgres

# In psql prompt:
CREATE DATABASE canteen_db;
\c canteen_db
\i schema.sql
\q
```

**✅ Database Created!**

---

### STEP 2: Setup Backend API

#### 2.1 Install Node.js Dependencies

```bash
# Navigate to backend folder
cd D:\cms\backend

# Install packages
npm install

# This will install:
# - express
# - pg (PostgreSQL client)
# - bcrypt
# - jsonwebtoken
# - cors
# - dotenv
```

#### 2.2 Configure Environment

```bash
# Copy environment template
copy .env.example .env

# Edit .env file with your settings
notepad .env
```

**Update these values in .env:**
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=canteen_db
DB_USER=postgres
DB_PASSWORD=YOUR_POSTGRES_PASSWORD
JWT_SECRET=change-this-to-random-string
```

#### 2.3 Start Backend Server

```bash
# Development mode (with auto-reload)
npm run dev

# OR Production mode
npm start
```

**Expected Output:**
```
✅ Connected to PostgreSQL database
🚀 Server running on http://localhost:3000
```

**✅ Backend API Running!**

---

### STEP 3: Run Frontend Application

#### 3.1 Start Web Server

```bash
# Open new terminal/command prompt
cd D:\cms

# Start Python HTTP server
python -m http.server 8080
```

#### 3.2 Access Application

Open browser and go to:
- **Customer Interface**: http://localhost:8080/c3.html
- **Admin Portal**: http://localhost:8080/admin_portal.html

**✅ Frontend Running!**

---

## 🔗 Connect Frontend to Backend

### Update Frontend to Use Database API

The frontend currently uses localStorage. To connect to the PostgreSQL database:

#### Option 1: Update c3.html to use API

Add this to the beginning of the script section in `c3.html`:

```javascript
// API Configuration
const API_BASE_URL = 'http://localhost:3000/api';
let authToken = localStorage.getItem('authToken');

// API Helper Functions
async function apiCall(endpoint, method = 'GET', data = null) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json',
        }
    };
    
    if (authToken) {
        options.headers['Authorization'] = `Bearer ${authToken}`;
    }
    
    if (data) {
        options.body = JSON.stringify(data);
    }
    
    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    return response.json();
}

// Replace localStorage login with API call
async function handleLogin(username, password) {
    const result = await apiCall('/auth/login', 'POST', { username, password });
    if (result.token) {
        authToken = result.token;
        localStorage.setItem('authToken', authToken);
        localStorage.setItem('currentUser', username);
        // Continue with existing login flow
    }
}
```

---

## 🧪 Testing the Installation

### Test 1: Database Connection

```bash
# Connect to database
psql -U postgres -d canteen_db

# Run test query
SELECT * FROM users;
SELECT * FROM menu_items;

# Exit
\q
```

### Test 2: Backend API

```bash
# Test health endpoint
curl http://localhost:3000/api/health

# Expected response:
# {"status":"OK","message":"Canteen API is running"}
```

### Test 3: Register User via API

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"testuser\",\"password\":\"test123\",\"full_name\":\"Test User\"}"
```

### Test 4: Frontend Access

1. Open http://localhost:8080/c3.html
2. Sign up with new account
3. Browse menu
4. Add items to cart
5. Test payment

---

## 📊 Verify Installation

### Check All Services Running

| Service | URL | Status Check |
|---------|-----|--------------|
| PostgreSQL | localhost:5432 | `psql -U postgres -l` |
| Backend API | http://localhost:3000 | http://localhost:3000/api/health |
| Frontend | http://localhost:8080 | http://localhost:8080/c3.html |

---

## 🔧 Troubleshooting

### Issue 1: PostgreSQL not starting

```bash
# Windows: Check services
services.msc

# Look for "postgresql-x64-15" and start it
```

### Issue 2: Backend cannot connect to database

```bash
# Check .env file has correct credentials
# Verify PostgreSQL is running
# Check database exists: psql -U postgres -l
```

### Issue 3: Port already in use

```bash
# Backend (port 3000)
# Change PORT in .env file

# Frontend (port 8080)
python -m http.server 8000  # Use different port
```

### Issue 4: npm install fails

```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and try again
rmdir /s node_modules
npm install
```

---

## 🔐 Default Credentials

### Database
- **Username**: postgres
- **Password**: (set during PostgreSQL installation)
- **Database**: canteen_db

### Admin Portal
- **Username**: admin
- **Password**: admin123

### Sample Customer (from schema.sql)
- **Username**: john_doe
- **Password**: (hashed - use registration to create new)

---

## 📁 Project Structure

```
D:\cms\
├── c3.html                    # Main customer interface
├── admin_portal.html          # Admin management portal
├── README.md                  # Project documentation
├── INSTALLATION.md            # This file
│
├── backend\                   # Node.js API Server
│   ├── server.js             # Main server file
│   ├── package.json          # Dependencies
│   ├── .env                  # Configuration (create this)
│   ├── .env.example          # Environment template
│   └── README.md             # API documentation
│
├── database\                  # PostgreSQL Database
│   ├── schema.sql            # Database schema
│   └── SETUP_GUIDE.md        # Database setup guide
│
└── [food images]             # Menu item images
```

---

## 🚀 Next Steps

### 1. Customize the System
- Add your own menu items
- Update branding and colors
- Configure payment gateway keys

### 2. Security Enhancements
- Change default admin password
- Update JWT_SECRET in .env
- Enable HTTPS for production
- Set up database backups

### 3. Deploy to Production
- Choose hosting provider (AWS, Heroku, DigitalOcean)
- Set up domain name
- Configure SSL certificates
- Set up monitoring

---

## 📚 Documentation Links

- [Database Setup Guide](database/SETUP_GUIDE.md)
- [Backend API Documentation](backend/README.md)
- [Main README](README.md)

---

## 🆘 Getting Help

### Common Commands Reference

```bash
# Start PostgreSQL
# Windows: services.msc → postgresql-x64-15 → Start

# Start Backend
cd D:\cms\backend
npm run dev

# Start Frontend
cd D:\cms
python -m http.server 8080

# Check Database
psql -U postgres -d canteen_db

# View Backend Logs
# Check terminal where npm run dev is running

# Backup Database
pg_dump -U postgres -d canteen_db -f backup.sql
```

---

## ✅ Installation Complete!

You should now have:
- ✅ PostgreSQL database running with all tables
- ✅ Backend API server running on port 3000
- ✅ Frontend application running on port 8080
- ✅ Admin portal accessible
- ✅ Payment gateway integrated

**Access your application:**
- Customer App: http://localhost:8080/c3.html
- Admin Portal: http://localhost:8080/admin_portal.html (login via customer page)
- API Health: http://localhost:3000/api/health

---

**Installation Date:** November 2025  
**Version:** 1.0.0  
**Status:** Ready to Use! 🎉
