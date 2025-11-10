# 🗄️ Database Setup Guide
## PostgreSQL Database for Shree Gajanan Canteen

---

## 📋 Prerequisites

- PostgreSQL 12 or higher installed
- pgAdmin 4 (optional, for GUI management)
- Command line access (psql or pgAdmin)

---

## 🚀 Installation Steps

### 1. Install PostgreSQL

#### Windows:
```bash
# Download from: https://www.postgresql.org/download/windows/
# Run the installer and follow the wizard
# Remember the password you set for the postgres user
```

#### Mac (using Homebrew):
```bash
brew install postgresql@15
brew services start postgresql@15
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

---

### 2. Create Database

#### Option A: Using psql (Command Line)

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE canteen_db;

# Connect to the database
\c canteen_db

# Run the schema file
\i D:/cms/database/schema.sql

# Verify tables were created
\dt

# Exit
\q
```

#### Option B: Using pgAdmin 4

1. Open pgAdmin 4
2. Right-click on "Databases" → "Create" → "Database"
3. Name: `canteen_db`
4. Click "Save"
5. Right-click on `canteen_db` → "Query Tool"
6. Open file: `D:\cms\database\schema.sql`
7. Click "Execute" (F5)

---

### 3. Verify Installation

```sql
-- Check if all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Should show:
-- users
-- menu_items
-- orders
-- order_items
-- payment_history
-- loyalty_visits

-- Check sample data
SELECT * FROM users;
SELECT * FROM menu_items;
```

---

### 4. Create Application User (Optional but Recommended)

```sql
-- Create a dedicated user for the application
CREATE USER canteen_app_user WITH PASSWORD 'secure_password_here';

-- Grant permissions
GRANT CONNECT ON DATABASE canteen_db TO canteen_app_user;
GRANT USAGE ON SCHEMA public TO canteen_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO canteen_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO canteen_app_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO canteen_app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT USAGE, SELECT ON SEQUENCES TO canteen_app_user;
```

---

## 📊 Database Structure

### Tables Overview

| Table | Description | Key Fields |
|-------|-------------|------------|
| **users** | Customer and admin accounts | user_id, username, role, balance |
| **menu_items** | Food items available | item_id, category, price |
| **orders** | Customer orders | order_id, order_number, total_amount |
| **order_items** | Items in each order | order_item_id, order_id, item_id |
| **payment_history** | Payment transactions | payment_id, transaction_id, amount |
| **loyalty_visits** | Customer visit tracking | visit_id, user_id, visit_date |

### Views

- `daily_sales_report` - Daily revenue and order statistics
- `popular_menu_items` - Most ordered items
- `customer_order_summary` - Customer spending summary

---

## 🔧 Configuration

### Update Backend .env File

```bash
cd D:\cms\backend
cp .env.example .env
```

Edit `.env` file:
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=canteen_db
DB_USER=postgres
DB_PASSWORD=your_postgres_password
```

---

## 🧪 Testing the Database

### Test Queries

```sql
-- 1. Get all menu items
SELECT * FROM menu_items WHERE is_available = true;

-- 2. Get user with orders
SELECT u.username, COUNT(o.order_id) as total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.username;

-- 3. Get today's orders
SELECT * FROM orders 
WHERE DATE(created_at) = CURRENT_DATE;

-- 4. Get payment summary
SELECT 
    payment_method,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM payment_history
WHERE payment_status = 'success'
GROUP BY payment_method;

-- 5. Popular items today
SELECT 
    oi.item_name,
    SUM(oi.quantity) as total_sold
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE DATE(o.created_at) = CURRENT_DATE
GROUP BY oi.item_name
ORDER BY total_sold DESC
LIMIT 10;
```

---

## 🔐 Security Best Practices

### 1. Change Default Passwords
```sql
-- Change postgres user password
ALTER USER postgres WITH PASSWORD 'new_secure_password';
```

### 2. Enable SSL (Production)
```sql
-- Edit postgresql.conf
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
```

### 3. Restrict Access
```bash
# Edit pg_hba.conf
# Allow only local connections
host    canteen_db    canteen_app_user    127.0.0.1/32    md5
```

---

## 📦 Backup and Restore

### Backup Database

```bash
# Full database backup
pg_dump -U postgres -d canteen_db -F c -f canteen_backup.dump

# SQL format backup
pg_dump -U postgres -d canteen_db -f canteen_backup.sql

# Backup specific tables
pg_dump -U postgres -d canteen_db -t users -t orders -f users_orders_backup.sql
```

### Restore Database

```bash
# Restore from custom format
pg_restore -U postgres -d canteen_db canteen_backup.dump

# Restore from SQL file
psql -U postgres -d canteen_db -f canteen_backup.sql
```

### Automated Backup Script (Windows)

```batch
@echo off
set PGPASSWORD=your_password
set BACKUP_DIR=D:\cms\backups
set DATE=%date:~-4,4%%date:~-10,2%%date:~-7,2%

pg_dump -U postgres -d canteen_db -F c -f %BACKUP_DIR%\canteen_backup_%DATE%.dump

echo Backup completed: canteen_backup_%DATE%.dump
```

---

## 🔍 Monitoring and Maintenance

### Check Database Size
```sql
SELECT 
    pg_size_pretty(pg_database_size('canteen_db')) as database_size;
```

### Check Table Sizes
```sql
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Vacuum and Analyze (Maintenance)
```sql
-- Optimize database
VACUUM ANALYZE;

-- For specific table
VACUUM ANALYZE orders;
```

### Check Active Connections
```sql
SELECT 
    datname,
    usename,
    application_name,
    client_addr,
    state,
    query
FROM pg_stat_activity
WHERE datname = 'canteen_db';
```

---

## ❗ Troubleshooting

### Issue: Cannot connect to database
```bash
# Check if PostgreSQL is running
# Windows:
services.msc  # Look for "postgresql-x64-15"

# Linux:
sudo systemctl status postgresql

# Check connection
psql -U postgres -h localhost -p 5432
```

### Issue: Permission denied
```sql
-- Grant all permissions to user
GRANT ALL PRIVILEGES ON DATABASE canteen_db TO your_user;
```

### Issue: Port already in use
```bash
# Check what's using port 5432
netstat -ano | findstr :5432

# Change PostgreSQL port in postgresql.conf
port = 5433
```

---

## 📚 Additional Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

---

## 🆘 Support

For issues or questions:
1. Check PostgreSQL logs: `C:\Program Files\PostgreSQL\15\data\log\`
2. Review error messages carefully
3. Verify connection parameters in `.env` file
4. Ensure PostgreSQL service is running

---

**Last Updated:** November 2025  
**Database Version:** PostgreSQL 15+  
**Status:** Production Ready ✅
