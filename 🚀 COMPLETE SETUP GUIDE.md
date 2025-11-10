# 🏪 Shree Gajanan Canteen Management System
## Complete Setup & User Guide

---

## 🎯 ONE-CLICK STARTUP

### **Quick Start (Recommended)**

1. **Double-click:** `START_ALL.bat`
2. **Wait 5 seconds** for servers to start
3. **Browser opens automatically** with user portal
4. **Done!** ✅

---

## 📋 What Gets Started

When you run `START_ALL.bat`, it automatically:

1. ✅ **Checks Node.js** installation
2. ✅ **Installs dependencies** (if needed)
3. ✅ **Starts Backend Server** (Port 3000)
4. ✅ **Starts Frontend Server** (Port 8080)
5. ✅ **Opens User Portal** in browser
6. ✅ **Ready to use!**

---

## 🌐 Access URLs

| Portal | URL | Credentials |
|--------|-----|-------------|
| **User Portal** | http://localhost:8080/c3.html | Sign up or use existing account |
| **Admin Portal** | http://localhost:8080/admin.html | admin / admin123 |
| **Backend API** | http://localhost:3000 | API endpoints |

---

## 🛠️ Available Scripts

| Script | Purpose |
|--------|---------|
| `START_ALL.bat` | **Start everything** (Backend + Frontend) |
| `STOP_ALL.bat` | **Stop all services** |
| `START_BACKEND.bat` | Start only backend |
| `START_FRONTEND.bat` | Start only frontend |
| `FIX_AND_START.bat` | Diagnose and fix issues |

---

## 📊 System Features

### **User Portal (c3.html)**
- ✅ User registration and login
- ✅ Browse menu with categories
- ✅ Search items
- ✅ Add items to cart
- ✅ Multiple payment methods:
  - 💵 Cash payment
  - 💳 Card payment (Razorpay)
  - 📱 UPI payment (Razorpay)
- ✅ **Automatic receipt generation**
- ✅ Print receipts
- ✅ Download receipts
- ✅ Order history
- ✅ Loyalty rewards

### **Admin Portal (admin.html)**
- ✅ Dashboard with analytics
- ✅ Manage menu items
- ✅ View all orders
- ✅ User management
- ✅ Sales reports
- ✅ Real-time updates

---

## 🗄️ Database Options

### **Option 1: localStorage (Current - No Setup Needed)**
- ✅ **Already working!**
- ✅ No installation required
- ✅ Data stored in browser
- ⚠️ Data cleared if browser cache cleared
- 👍 **Perfect for development and testing**

### **Option 2: PostgreSQL (Production)**

#### **Install PostgreSQL:**

1. **Download PostgreSQL:**
   - Visit: https://www.postgresql.org/download/windows/
   - Download and install PostgreSQL 15 or later

2. **During Installation:**
   - Set password for `postgres` user (remember this!)
   - Port: `5432` (default)
   - Install pgAdmin 4 (included)

3. **Create Database:**
   ```sql
   -- Open pgAdmin or psql
   CREATE DATABASE canteen_db;
   ```

4. **Configure Backend:**
   - Open: `backend\.env` (create if doesn't exist)
   - Add:
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=canteen_db
   DB_USER=postgres
   DB_PASSWORD=your_password_here
   JWT_SECRET=your-secret-key-here
   ```

5. **Run Database Setup:**
   ```bash
   cd backend
   node setup-database.js
   ```

6. **Restart Backend:**
   - Close backend window
   - Run `START_ALL.bat` again

---

## 🔧 Troubleshooting

### **Issue: "Node.js not found"**
**Solution:**
1. Install Node.js from: https://nodejs.org/
2. Or run: `ADD_NODEJS_TO_PATH.bat`
3. Restart computer
4. Run `START_ALL.bat` again

### **Issue: "Port already in use"**
**Solution:**
1. Run `STOP_ALL.bat`
2. Wait 5 seconds
3. Run `START_ALL.bat` again

### **Issue: "Cannot find module"**
**Solution:**
1. Delete `backend\node_modules` folder
2. Run `START_ALL.bat` (will reinstall)

### **Issue: "Receipt shows empty order"**
**Solution:**
- ✅ **Already fixed!**
- Receipt now generates automatically
- Works for all payment methods

### **Issue: Images not loading**
**Solution:**
- Images are optional
- System works without them
- To add images: Place in `cms` folder with correct names

---

## 📱 How to Use

### **For Customers:**

1. **Open User Portal:**
   - Click `START_ALL.bat`
   - Browser opens automatically
   - Or visit: http://localhost:8080/c3.html

2. **Sign Up / Login:**
   - Create new account
   - Or login with existing credentials

3. **Browse & Order:**
   - Browse menu by categories
   - Search for items
   - Click "Add" to add items to cart
   - Click "Place Order"

4. **Payment:**
   - Choose payment method:
     - **Cash:** Confirm and pay at counter
     - **Card/UPI:** Complete online payment
   - **Receipt generates automatically!** ✅

5. **Receipt:**
   - Receipt appears immediately
   - Print or download
   - View order history anytime

### **For Admin:**

1. **Open Admin Portal:**
   - Visit: http://localhost:8080/admin.html
   - Login: admin / admin123

2. **Manage System:**
   - View dashboard
   - Add/edit menu items
   - View orders
   - Manage users
   - Generate reports

---

## 🎨 Customization

### **Change Admin Password:**
1. Open `admin.html`
2. Find line with `password: 'admin123'`
3. Change to your password
4. Save file

### **Add Menu Items:**
1. Login to admin portal
2. Go to "Menu Management"
3. Click "Add Item"
4. Fill details and save

### **Change Colors:**
1. Open `c3.html` or `admin.html`
2. Find CSS section (near top)
3. Modify `--primary-color`, `--secondary-color`, etc.
4. Save and refresh

---

## 🔐 Security Notes

### **For Development:**
- ✅ Current setup is fine
- Uses localStorage
- No sensitive data exposed

### **For Production:**
1. **Change default passwords**
2. **Use PostgreSQL database**
3. **Enable HTTPS**
4. **Use real Razorpay keys**
5. **Add authentication tokens**
6. **Enable CORS properly**

---

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    USER'S BROWSER                       │
│  ┌──────────────────┐      ┌──────────────────┐       │
│  │  User Portal     │      │  Admin Portal    │       │
│  │  (c3.html)       │      │  (admin.html)    │       │
│  │  Port 8080       │      │  Port 8080       │       │
│  └────────┬─────────┘      └────────┬─────────┘       │
└───────────┼────────────────────────┼─────────────────┘
            │                        │
            │    HTTP Requests       │
            └────────┬───────────────┘
                     │
            ┌────────▼────────┐
            │  Backend Server │
            │  (Node.js)      │
            │  Port 3000      │
            └────────┬────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
   ┌────▼─────┐          ┌───────▼────────┐
   │localStorage│         │  PostgreSQL    │
   │ (Current) │          │  (Optional)    │
   └───────────┘          └────────────────┘
```

---

## 📞 Support

### **Common Questions:**

**Q: Do I need PostgreSQL?**
A: No! System works with localStorage (browser storage). PostgreSQL is optional for production.

**Q: Can I use this offline?**
A: Yes! Once started, works on localhost without internet (except Razorpay payments).

**Q: How to backup data?**
A: With localStorage: Export from browser. With PostgreSQL: Use pgAdmin backup.

**Q: Receipt not working?**
A: ✅ Already fixed! Receipt generates automatically after payment.

**Q: Can multiple users access simultaneously?**
A: Yes! Each user has their own session and cart.

---

## 🎉 You're All Set!

### **Next Steps:**

1. ✅ Run `START_ALL.bat`
2. ✅ System starts automatically
3. ✅ Browser opens with user portal
4. ✅ Start using the system!

### **Quick Links:**

- 👤 User Portal: http://localhost:8080/c3.html
- 🔧 Admin Portal: http://localhost:8080/admin.html
- 📚 This Guide: `🚀 COMPLETE SETUP GUIDE.md`

---

## 🌟 Features Summary

| Feature | Status |
|---------|--------|
| User Registration/Login | ✅ Working |
| Menu Display | ✅ Working |
| Categories & Search | ✅ Working |
| Shopping Cart | ✅ Working |
| Cash Payment | ✅ Working |
| Card Payment | ✅ Working |
| UPI Payment | ✅ Working |
| **Receipt Generation** | ✅ **WORKING!** |
| Print Receipt | ✅ Working |
| Download Receipt | ✅ Working |
| Order History | ✅ Working |
| Admin Dashboard | ✅ Working |
| Menu Management | ✅ Working |
| User Management | ✅ Working |

---

## 🚀 **ENJOY YOUR CANTEEN MANAGEMENT SYSTEM!** 🎊

**Everything is integrated and ready to use!**

Just run `START_ALL.bat` and you're good to go! 🎉
