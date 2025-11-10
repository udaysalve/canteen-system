# 🧪 Testing Guide - Canteen Management System

## Quick Test Checklist

### **✅ Admin Portal Testing**

1. **Access Admin Portal**
   - Open `c3.html` in browser
   - Click "Access Admin Portal" button
   - Use credentials: `admin` / `admin123`

2. **Dashboard Functionality**
   - Click "Initialize Sample Data" button to create test data
   - Verify dashboard shows: Total Orders, Users, Peak Hour Analysis
   - Click "Refresh Dashboard" to update data
   - Check that all numbers display correctly (not showing errors)

3. **Menu Management**
   - Go to "Menu & Pricing" tab
   - Add new menu items
   - Edit existing items
   - Save changes and verify they appear in main app

4. **User Management**
   - Go to "User Management" tab
   - View user statistics
   - Add new users if needed

### **✅ Receipt Generation Testing**

#### **Cash Payment Receipt**
1. **Place Order**
   - Open `c3.html`
   - Login/signup as customer
   - Add items to cart (e.g., Tea, Coffee, Samosa)
   - Click "Place Order"

2. **Pay with Cash**
   - Select "Pay with Cash" option
   - Confirm order
   - **Expected**: Success message with "View Receipt" button appears

3. **Test Receipt**
   - Click "View Receipt" button
   - **Expected**: Receipt modal opens with complete order details
   - Test "Print Receipt" button
   - Test "Download Receipt" button
   - Test "Close" button

#### **Card/UPI Payment Receipt**
1. **Place Order**
   - Add items to cart
   - Click "Place Order"

2. **Pay with Card/UPI**
   - Select "Pay with Card/Wallet" or "Pay with UPI"
   - **Note**: This will open Razorpay test mode
   - Use test card: `4111 1111 1111 1111`, CVV: `123`, Expiry: any future date
   - Complete payment

3. **Test Receipt**
   - **Expected**: Success message with "View Receipt" button
   - Click "View Receipt" button
   - Verify receipt shows payment ID and method
   - Test all receipt actions (Print, Download, Close)

### **🔧 Troubleshooting**

#### **Admin Portal Issues**
- **Dashboard shows "0" or errors**: Click "Initialize Sample Data" button
- **Menu not loading**: Refresh page and try "Refresh Dashboard"
- **Can't access admin**: Clear browser cache and try again

#### **Receipt Issues**
- **"View Receipt" button not appearing**: Check browser console for errors
- **Receipt modal not opening**: Ensure you're using a modern browser
- **Print not working**: Check browser print permissions
- **Download not working**: Check browser download permissions

#### **Payment Issues**
- **Razorpay not loading**: Check internet connection
- **Test payments failing**: Use the test card numbers provided above
- **Cart not clearing**: Refresh page after successful payment

### **📱 Browser Compatibility**
- **Chrome**: Full support ✅
- **Firefox**: Full support ✅
- **Safari**: Full support ✅
- **Edge**: Full support ✅

### **🚀 Expected Behavior**

#### **Successful Cash Payment Flow**
```
Add Items → Place Order → Pay with Cash → Confirm → 
Success Message + View Receipt Button → Receipt Modal → 
Print/Download Options → Cart Cleared
```

#### **Successful Card Payment Flow**
```
Add Items → Place Order → Pay with Card → Razorpay → 
Complete Payment → Success Message + View Receipt Button → 
Receipt Modal → Print/Download Options → Cart Cleared
```

#### **Admin Portal Flow**
```
Login → Dashboard (Initialize Data if needed) → 
View Statistics → Manage Menu → Manage Users → 
All sections functional
```

### **🐛 Common Issues & Solutions**

1. **Receipt not generating**
   - **Solution**: Check browser console, refresh page, try again

2. **Admin dashboard empty**
   - **Solution**: Click "Initialize Sample Data" button

3. **Images not loading**
   - **Solution**: Ensure backend server is running on port 3000

4. **Payment not processing**
   - **Solution**: Use test credentials, check internet connection

5. **Cart not updating**
   - **Solution**: Refresh page, clear browser cache

### **📊 Test Data**

#### **Sample Menu Items**
- Tea (₹10)
- Coffee (₹15)
- Samosa (₹12)
- Vada Pav (₹15)

#### **Test Payment Cards**
- **Visa**: 4111 1111 1111 1111
- **Mastercard**: 5555 5555 5555 4444
- **CVV**: 123
- **Expiry**: Any future date

#### **Admin Credentials**
- **Username**: admin
- **Password**: admin123

### **✨ Success Indicators**

- ✅ Dashboard shows real numbers (not 0 or errors)
- ✅ Receipt modal opens with complete details
- ✅ Print functionality works
- ✅ Download creates HTML file
- ✅ Cart clears after successful payment
- ✅ All admin sections are functional
- ✅ Menu management works
- ✅ User management works

---

**If you encounter any issues not covered here, check the browser console for error messages and ensure all files are in the correct locations.**
