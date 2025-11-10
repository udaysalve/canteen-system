# 📱 Table QR Code System - Complete Guide

## Overview
This system generates unique QR codes for each table that automatically set the table number when customers scan them to order.

---

## 🎯 Features

✅ **5 QR Codes Generated** - One for each table (customizable 1-50)
✅ **Auto Table Detection** - Table number automatically filled when scanned
✅ **Mobile & PC Compatible** - Works on all devices
✅ **Print & Download** - Individual or batch printing
✅ **Real-Time Display** - Table badge shows on customer app
✅ **Admin Tracking** - Table numbers visible in all orders

---

## 🚀 How It Works

### Step 1: Generate QR Codes
1. Open **TABLE_QR_CODES.html**
2. Enter number of tables (default: 5)
3. Click "Generate QR Codes"
4. QR codes created instantly!

### Step 2: Print QR Codes
**Option A: Print All**
- Click "🖨️ Print All QR Codes" button
- Print entire sheet with all tables

**Option B: Print Individual**
- Click "🖨️ Print" on specific table card
- Print single QR code

**Option C: Download**
- Click "💾 Download QR" button
- Get PNG file for each table
- Use for custom printing/lamination

### Step 3: Place on Tables
1. Print QR codes on quality paper
2. Laminate for durability (recommended)
3. Place on each table in visible location
4. Test scanning with phone camera

### Step 4: Customer Usage
1. **Customer scans QR code** with phone camera
2. **Browser opens** c3.html?table=X (where X is table number)
3. **Login screen shows** "You're ordering for Table X"
4. **Customer logs in** and orders
5. **Table badge appears** in header showing table number
6. **Order submitted** with table number automatically included

---

## 📊 QR Code URLs

Each QR code links to:
```
http://localhost:8080/c3.html?table=1
http://localhost:8080/c3.html?table=2
http://localhost:8080/c3.html?table=3
http://localhost:8080/c3.html?table=4
http://localhost:8080/c3.html?table=5
```

For production, replace `localhost:8080` with your actual domain.

---

## 🎨 What Customers See

### Login Screen:
```
┌──────────────────────────────────┐
│   🍽️ Shree Gajanan Canteen     │
│                                  │
│  🍽️ You're ordering for Table 3 │
│                                  │
│  Username: [_____________]       │
│  Password: [_____________]       │
│                                  │
│  [ Login to Order ]              │
└──────────────────────────────────┘
```

### After Login (Header):
```
┌──────────────────────────────────────┐
│ Shree Gajanan Canteen                │
│             🍽️ Table 3 | 📜 | 🚪    │
└──────────────────────────────────────┘
```

The table badge pulses with animation to draw attention!

---

## 🔧 Table Number Flow

### URL → Storage → Display → Order

1. **URL Parameter**
   - Customer scans: `c3.html?table=3`
   - JavaScript reads: `?table=3`

2. **Local Storage**
   - Saved to: `localStorage.setItem('currentTable', '3')`
   - Persists across page refreshes

3. **UI Display**
   - Login notice: "You're ordering for Table 3"
   - Header badge: "🍽️ Table 3"

4. **Order Submission**
   - Included in order object:
     ```javascript
     {
       tableNumber: '3',
       table_number: '3',
       // ... other order data
     }
     ```

5. **Admin Visibility**
   - Order Management: Shows table number
   - Transaction Records: Table column populated
   - User Orders: Displays table info

---

## 📱 Mobile vs Desktop

### Mobile (Primary Use Case):
- ✅ Scan QR with phone camera
- ✅ Opens in default browser
- ✅ Touch-optimized interface
- ✅ Table badge visible in header
- ✅ Full ordering functionality

### Desktop:
- ✅ Manual URL entry: `localhost:8080/c3.html?table=1`
- ✅ Or scan with PC webcam + QR app
- ✅ Same functionality as mobile
- ✅ Responsive design adapts

---

## 🎯 Admin Portal Integration

### Order Management Tab:
```
Order #3 - Table 5
Items: 2x Tea, 1x Samosa
Status: NEW
Customer: golu
Table: 5 ← Automatically shown
```

### Transaction Records:
```
Order Number | User | Table | Amount | Status
-------------|------|-------|--------|--------
ORD000001   | golu |   5   | ₹65.00 | COMPLETE
ORD000002   | uday |   3   | ₹75.00 | NEW
```

### User Management:
When clicking "View Orders" for a user:
```
Table | Order Number | Items | Amount
------|--------------|-------|--------
  5   | ORD000001   | Tea   | ₹65.00
  3   | ORD000002   | Coffee| ₹75.00
```

---

## 🖨️ Printing Tips

### Best Practices:
1. **Paper Quality**
   - Use thick paper (200gsm+)
   - Glossy or matte finish works
   - White background for best scanning

2. **Size**
   - Minimum: 2x2 inches (5x5 cm)
   - Recommended: 4x4 inches (10x10 cm)
   - Larger = easier to scan

3. **Protection**
   - Laminate with clear plastic
   - Use waterproof coating
   - Place in plastic stand/holder
   - Protects from spills & wear

4. **Placement**
   - Center of table
   - Near condiments
   - In table tent/stand
   - Easy to see and reach

5. **Testing**
   - Test each QR after printing
   - Scan with multiple phones
   - Check iOS and Android
   - Verify correct table number

---

## 🔧 Customization

### Change Number of Tables:
1. Open TABLE_QR_CODES.html
2. Change input field (1-50 tables)
3. Click "Generate QR Codes"
4. Print new set

### Change Base URL:
Edit TABLE_QR_CODES.html:
```javascript
// Line ~202
const BASE_URL = window.location.origin;

// Change to:
const BASE_URL = 'https://yourcanteen.com';
```

### Custom Styling:
Modify QR card design in TABLE_QR_CODES.html CSS section.

---

## ✅ Testing Checklist

### Before Deployment:
- [ ] Generated all table QR codes
- [ ] Printed and laminated
- [ ] Scanned each QR code
- [ ] Verified table number appears on login
- [ ] Checked table badge in header
- [ ] Placed test order
- [ ] Confirmed table shown in admin portal
- [ ] Tested on multiple devices
- [ ] Checked both iOS and Android
- [ ] Verified mobile and desktop work

### During Service:
- [ ] QR codes clearly visible
- [ ] No damaged/torn codes
- [ ] Easy customer access
- [ ] Staff knows system
- [ ] Backup codes available

---

## 🆘 Troubleshooting

### QR Code Doesn't Scan
- ✅ Check printing quality
- ✅ Ensure good lighting
- ✅ Clean QR code surface
- ✅ Try different camera app
- ✅ Regenerate if damaged

### Table Number Not Showing
- ✅ Check browser console (F12)
- ✅ Verify URL has ?table= parameter
- ✅ Clear browser cache
- ✅ Check localStorage in DevTools
- ✅ Rescan QR code

### Wrong Table Number
- ✅ Ensure correct QR on table
- ✅ Clear localStorage
- ✅ Rescan correct QR
- ✅ Check admin portal shows correct number

### Orders Missing Table Number
- ✅ Customer must scan QR
- ✅ Don't manually type URL
- ✅ Verify ?table= in URL
- ✅ Check order object in console

---

## 📞 Support

### Files Involved:
- `TABLE_QR_CODES.html` - QR generator
- `c3.html` - Customer app (reads table param)
- `admin_portal.html` - Shows table in orders
- `admin_transactions.html` - Table column in records

### How to Get Help:
1. Check browser console for errors
2. Verify QR code URL is correct
3. Test with simple table URL
4. Check localStorage values
5. Review order objects in admin

---

## 📊 Statistics & Benefits

### Benefits:
✅ **Faster Service** - No verbal table number needed
✅ **Error Reduction** - No wrong table assignments
✅ **Better Tracking** - Know which tables order most
✅ **Customer Experience** - Seamless ordering process
✅ **Staff Efficiency** - Easy order delivery to correct table
✅ **Data Insights** - Table-based analytics possible

### Usage Stats (Track in Admin):
- Orders per table
- Popular table locations
- Peak table times
- Revenue by table
- Customer preferences by seating

---

## 🎯 Summary

### Quick Setup (5 Minutes):
1. ✅ Open TABLE_QR_CODES.html
2. ✅ Click "Print All QR Codes"
3. ✅ Laminate printouts
4. ✅ Place on tables 1-5
5. ✅ Done! System ready to use

### Customer Flow (30 Seconds):
1. Scan QR → 2. Login → 3. Order → 4. Pay → Done!

### Admin Visibility:
- Real-time table number in all orders
- Transaction records show table column
- User order history includes table
- Full tracking and reporting

**Your table-based ordering system is ready! 🚀**
