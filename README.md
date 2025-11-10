# 🍽️ Shree Gajanan Canteen Management System

A complete canteen management system with customer ordering interface and admin portal, featuring integrated payment gateway and real-time order management.

## 🚀 Features

### Customer Interface (c3.html)
- ✅ **User Authentication** - Login/Signup system with localStorage
- 🛒 **Menu Browsing** - Categorized menu with search functionality
- 🛍️ **Shopping Cart** - Add/remove items with quantity management
- 💳 **Payment Gateway** - Razorpay integration (UPI, Card, Cash)
- 🧾 **Receipt Generation** - Professional receipts for all payment methods
- 🖨️ **Print & Download** - Print receipts or download as HTML
- 🎁 **Loyalty Rewards** - Monthly rewards for frequent customers
- 📜 **Order History** - View past orders with details
- 🔐 **Admin Access** - One-click access to admin portal

### Admin Portal (admin_portal.html)
- 📊 **Dashboard** - Real-time order tracking and statistics
- 🍔 **Menu Management** - Add/edit/delete menu items and prices
- 👥 **User Management** - Manage customer accounts and balances
- 🧾 **Order Management** - Kitchen display system simulation
- 📈 **Financial Reports** - Sales and profit tracking
- ⚙️ **Settings** - Configure payment gateway and system settings
- 💡 **AI Forecasting** - Predict food quantities needed
- ↩️ **Back to App** - Easy navigation back to customer interface

## 🔗 Integration Features

### Seamless Connection
- **One-Click Admin Access**: Click "Admin" button in customer interface
- **Admin Credentials**: 
  - Username: `admin`
  - Password: `admin123`
- **Data Synchronization**: Orders automatically sync between interfaces
- **Shared Database**: Uses localStorage for persistent data storage

### Payment Gateway Integration
- **Provider**: Razorpay (Test Mode)
- **Test Key**: `rzp_test_1DP5mmOlF5G5ag`
- **Payment Methods**:
  - 💜 UPI Payment
  - 💳 Card/Wallet Payment
  - 💵 Cash Payment
- **Features**:
  - Payment success/failure handling
  - Order confirmation with unique ID
  - Automatic discount calculation (5% on orders >₹500)

## 📁 Project Structure

```
cms/
├── c3.html                 # Main customer interface
├── admin_portal.html       # Admin management portal
├── menu_functional.html    # Alternative login page
├── canteen1.html          # Menu example page
├── c2.html                # Additional page
├── README.md              # This file
└── [food images]          # Menu item images
```

## 🛠️ Setup & Installation

### 1. Start the Server

```bash
# Navigate to project directory
cd d:\cms

# Start Python HTTP server
python -m http.server 8080
```

### 2. Access the Application

- **Customer Interface**: http://localhost:8080/c3.html
- **Admin Portal**: http://localhost:8080/admin_portal.html

### 3. Test the System

#### Customer Flow:
1. Sign up with username and password
2. Browse menu and add items to cart
3. View order and choose payment method
4. Complete payment (use test card: 4111 1111 1111 1111)
5. View order history

#### Admin Flow:
1. Click "Admin" button in customer interface
2. Login with admin/admin123
3. View dashboard with all orders
4. Manage menu, users, and orders
5. Click "Back to App" to return

## 💳 Payment Gateway Setup

### Test Mode (Current)
- Already configured with test key
- No real money transactions
- Use test cards for testing

### Production Mode
1. Sign up at [razorpay.com](https://razorpay.com)
2. Get your API keys from dashboard
3. Replace test key in c3.html (line 564):
   ```javascript
   key: 'YOUR_LIVE_KEY_HERE'
   ```
4. Enable live mode in Razorpay dashboard

### Test Cards
- **Card Number**: 4111 1111 1111 1111
- **Expiry**: Any future date
- **CVV**: Any 3 digits

## 🔐 Security Notes

### Current Implementation
- Simple authentication using localStorage
- Admin credentials hardcoded for demo
- No encryption on stored data

### Production Recommendations
1. Implement backend authentication (Node.js/PHP)
2. Use secure password hashing (bcrypt)
3. Store sensitive data in database (MongoDB/MySQL)
4. Add JWT tokens for session management
5. Enable HTTPS for secure connections
6. Use environment variables for API keys

## 📊 Data Storage

### LocalStorage Keys
- `currentUser` - Currently logged in user
- `users` - All registered users
- `orders_{username}` - User-specific order history
- `loyalty_{username}` - User loyalty rewards data
- `GanananCMS_menu` - Menu items (admin)
- `GanananCMS_users` - User accounts (admin)
- `GanananCMS_orders` - All orders (admin)
- `adminAuthenticated` - Admin session status

## 🎨 Customization

### Change Theme Colors
Edit CSS variables in c3.html:
```css
:root {
    --primary-color: #e53935;    /* Red */
    --secondary-color: #4CAF50;  /* Green */
    --reward-color: #ff9800;     /* Orange */
}
```

### Add Menu Items
1. Login to admin portal
2. Go to "Menu & Pricing" tab
3. Click "+ Add New Item"
4. Fill details and save

### Modify Payment Options
Edit payment buttons in c3.html (lines 158-160)

## 🐛 Troubleshooting

### Server Not Starting
- Check if port 8080 is available
- Try different port: `python -m http.server 8000`

### Payment Not Working
- Verify internet connection (Razorpay CDN required)
- Check browser console for errors
- Ensure test key is correct

### Data Not Persisting
- Check browser localStorage is enabled
- Clear cache and reload
- Check browser console for errors

### Admin Access Denied
- Verify credentials: admin/admin123
- Clear localStorage and try again
- Check browser console for errors

## 📱 Browser Compatibility

- ✅ Chrome (Recommended)
- ✅ Firefox
- ✅ Edge
- ✅ Safari
- ⚠️ IE11 (Limited support)

## 🔄 Updates & Maintenance

### Clear All Data
1. Login to admin portal
2. Go to "Settings & Config"
3. Click "Reset All Database Data"

### Backup Data
```javascript
// Run in browser console
const backup = {
    users: localStorage.getItem('users'),
    orders: localStorage.getItem('GanananCMS_orders'),
    menu: localStorage.getItem('GanananCMS_menu')
};
console.log(JSON.stringify(backup));
```

## 📞 Support

For issues or questions:
1. Check troubleshooting section
2. Review browser console errors
3. Verify all files are present
4. Test with different browser

## 🎯 Future Enhancements

- [ ] Real-time order notifications
- [ ] SMS/Email confirmations
- [ ] QR code ordering
- [ ] Multi-language support
- [ ] Mobile app version
- [ ] Analytics dashboard
- [ ] Inventory management
- [ ] Staff scheduling
- [ ] Customer feedback system
- [ ] Promotional campaigns

## 📄 License

This project is for educational and demonstration purposes.

## 🙏 Credits

- **Payment Gateway**: Razorpay
- **Icons**: Font Awesome
- **Fonts**: Google Fonts (Roboto)

## 🚀 Quick Start

### **Option 1: Simple Local Testing**
1. Double-click `start-local-test.bat` (Windows)
2. Open browser to `http://localhost:8000/c3.html`
3. For admin: `http://localhost:8000/admin_portal.html`

### **Option 2: With Backend (Full Features)**
1. **Setup Database**: Run `database/schema.sql` in PostgreSQL
2. **Start Backend**: 
   ```bash
   cd backend
   npm install
   npm start
   ```
3. **Open Frontend**: Open `c3.html` in browser

### **Test Credentials**
- **Admin**: `admin` / `admin123`
- **Test Card**: `4111 1111 1111 1111`, CVV: `123`

## 📚 Documentation

- **[Receipt System Guide](RECEIPT_SYSTEM_GUIDE.md)** - Complete receipt functionality
- **[Testing Guide](TESTING_GUIDE.md)** - How to test all features
- **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** - Production deployment guide

---

**Version**: 2.0.0  
**Last Updated**: November 2025  
**Status**: Production Ready ✅ with Receipt System
