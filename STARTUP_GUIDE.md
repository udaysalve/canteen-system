# 🚀 Startup Guide - Full System with Node.js

## ✅ **YOU HAVE NODE.JS INSTALLED!**

Now let's get everything running with full features.

---

## 🎯 **QUICK START (Recommended)**

### **Step 1: Restart Your Computer**
After installing Node.js, **restart your computer** so Windows recognizes it properly.

### **Step 2: Run the Quick Start Script**
1. Double-click `QUICK_START.bat`
2. Wait for both servers to start
3. Browser will automatically open with both apps

**That's it!** Your system will be running with all features.

---

## 📋 **WHAT HAPPENS WHEN YOU RUN QUICK_START.bat**

### **Automatic Setup:**
1. ✅ Detects Node.js installation
2. ✅ Installs http-server for frontend
3. ✅ Installs backend dependencies
4. ✅ Starts frontend server on port 8080
5. ✅ Starts backend server on port 3000
6. ✅ Opens both apps in your browser

### **Two Windows Will Open:**
- **Frontend Server** - Port 8080 (serves HTML files)
- **Backend Server** - Port 3000 (API and image serving)

⚠️ **Keep both windows open while using the system!**

---

## 🌐 **ACCESS YOUR APPLICATIONS**

### **Customer App:**
```
http://localhost:8080/c3.html
```
- Login/Signup as customer
- Browse menu with images
- Add items to cart
- Place orders
- Generate receipts

### **Admin Portal:**
```
http://localhost:8080/admin_portal.html
```
- Login: `admin` / `admin123`
- Click "Initialize Sample Data"
- Manage menu items
- Manage users
- View analytics

### **Backend API:**
```
http://localhost:3000
```
- Health check: `http://localhost:3000/api/health`
- Serves images: `http://localhost:3000/images/`

---

## 🧪 **TESTING CHECKLIST**

### **Test Customer App:**
- [ ] Open http://localhost:8080/c3.html
- [ ] Create account and login
- [ ] Browse menu (images should load)
- [ ] Add Tea, Coffee to cart
- [ ] Click "Place Order"
- [ ] Select "Pay with Cash"
- [ ] Click "View Receipt" button
- [ ] Test print receipt
- [ ] Test download receipt

### **Test Admin Portal:**
- [ ] Open http://localhost:8080/admin_portal.html
- [ ] Login with admin/admin123
- [ ] Click "Initialize Sample Data"
- [ ] Verify dashboard shows numbers
- [ ] Go to "Menu & Pricing" tab
- [ ] Add/edit menu items
- [ ] Go to "User Management" tab
- [ ] View user list

### **Test Backend:**
- [ ] Open http://localhost:3000/api/health
- [ ] Should see: `{"status":"OK","message":"Canteen API is running"}`
- [ ] Open http://localhost:3000/images/chai.jpg
- [ ] Should see the chai image

---

## 🔧 **MANUAL STARTUP (If Script Doesn't Work)**

### **Terminal 1 - Frontend Server:**
```bash
cd c:\Users\hp\OneDrive\Desktop\newgj\cms
npx http-server -p 8080 -c-1
```

### **Terminal 2 - Backend Server:**
```bash
cd c:\Users\hp\OneDrive\Desktop\newgj\cms\backend
npm install
npm start
```

### **Then Open:**
- http://localhost:8080/c3.html
- http://localhost:8080/admin_portal.html

---

## ⚠️ **TROUBLESHOOTING**

### **Issue: "node is not recognized"**
**Solution:**
1. Close all command windows
2. **Restart your computer**
3. Run QUICK_START.bat again

### **Issue: Port already in use**
**Solution:**
```bash
# Kill processes on port 8080
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F

# Kill processes on port 3000
netstat -ano | findstr :3000
taskkill /PID <PID_NUMBER> /F
```

### **Issue: Backend won't start**
**Solution:**
```bash
cd backend
npm install
npm start
```

### **Issue: Images not loading**
**Solution:**
- Ensure backend is running on port 3000
- Check: http://localhost:3000/images/chai.jpg
- If not working, restart backend server

### **Issue: Receipt not generating**
**Solution:**
- Check browser console (F12)
- Ensure you completed the order
- Try refreshing the page

---

## 🎯 **FEATURES THAT NOW WORK**

### **With Full Server Setup:**
- ✅ **All Images Load** - Product images from backend
- ✅ **Receipt Generation** - For all payment methods
- ✅ **Receipt Print** - Browser print functionality
- ✅ **Receipt Download** - Save as HTML file
- ✅ **Admin Portal** - Full functionality
- ✅ **Menu Management** - Add/edit/delete items
- ✅ **User Management** - Manage customers
- ✅ **Order Tracking** - Real-time updates
- ✅ **Payment Integration** - Razorpay for card/UPI
- ✅ **Cash Payments** - Counter payment workflow
- ✅ **Cart Management** - Add/remove items
- ✅ **Order History** - View past orders
- ✅ **Loyalty Rewards** - Monthly rewards system

---

## 📊 **SYSTEM ARCHITECTURE**

```
┌─────────────────────────────────────────┐
│         Frontend (Port 8080)            │
│  ┌─────────────┐  ┌─────────────────┐  │
│  │  c3.html    │  │ admin_portal    │  │
│  │ (Customer)  │  │    (Admin)      │  │
│  └─────────────┘  └─────────────────┘  │
└──────────────┬──────────────────────────┘
               │
               │ HTTP Requests
               │
┌──────────────▼──────────────────────────┐
│         Backend (Port 3000)             │
│  ┌─────────────────────────────────┐   │
│  │  Express.js API Server          │   │
│  │  - Authentication               │   │
│  │  - Order Management             │   │
│  │  - Receipt Generation           │   │
│  │  - Image Serving                │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## 🎉 **SUCCESS INDICATORS**

### **You'll know it's working when:**
1. ✅ Two command windows are open (Frontend & Backend)
2. ✅ Browser opens automatically with both apps
3. ✅ Customer app loads with menu items
4. ✅ Product images display (not placeholders)
5. ✅ Admin portal shows dashboard
6. ✅ Receipt generates after payment
7. ✅ Print and download buttons work

---

## 🔄 **STOPPING THE SERVERS**

### **To Stop:**
1. Close the "Frontend - Port 8080" window
2. Close the "Backend - Port 3000" window

### **Or press Ctrl+C in each window**

---

## 🚀 **NEXT STEPS**

### **After Testing:**
1. **Configure Database** (Optional for production):
   - Install PostgreSQL
   - Run `database/schema.sql`
   - Update `backend/.env` with credentials

2. **Customize Settings:**
   - Update Razorpay keys in `c3.html`
   - Modify menu items in admin portal
   - Add your branding/logo

3. **Deploy to Production:**
   - Follow `DEPLOYMENT_CHECKLIST.md`
   - Set up proper hosting
   - Configure SSL/HTTPS

---

## 📞 **NEED HELP?**

### **Check These Files:**
- `TROUBLESHOOTING.md` - Common issues and solutions
- `TESTING_GUIDE.md` - Detailed testing instructions
- `SYSTEM_STATUS.md` - Current system status

### **Quick Checks:**
1. Are both server windows open?
2. Is Node.js installed and restarted computer?
3. Are ports 8080 and 3000 free?
4. Is browser console showing errors? (F12)

---

## ✅ **YOU'RE READY!**

**Just run `QUICK_START.bat` and start testing your fully functional Canteen Management System!** 🎉
