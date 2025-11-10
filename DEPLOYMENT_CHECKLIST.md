# 🚀 Deployment Checklist - Canteen Management System

## Pre-Deployment Setup

### **1. Database Setup**
```bash
# If using PostgreSQL (recommended for production)
psql -U postgres -d canteen_db -f database/schema.sql

# Or use any PostgreSQL client to run the schema.sql file
```

### **2. Backend Server Setup**
```bash
cd backend
npm install
# Create .env file with your database credentials
cp .env.example .env
# Edit .env file with your actual database details
npm start
```

### **3. Frontend Setup**
- Ensure all HTML files are in the cms directory
- Update image paths if needed
- Test all functionality locally

## ✅ Pre-Launch Testing Checklist

### **Database & Backend**
- [ ] Database schema created successfully
- [ ] Backend server starts without errors
- [ ] API endpoints respond correctly
- [ ] Image serving works (http://localhost:3000/images/)
- [ ] CORS is properly configured

### **Frontend - Main App (c3.html)**
- [ ] Login/Signup functionality works
- [ ] Menu displays with images
- [ ] Cart functionality (add/remove items)
- [ ] Order placement works
- [ ] Payment integration (Cash/Card/UPI) functional
- [ ] Receipt generation works for all payment methods
- [ ] Receipt print functionality works
- [ ] Receipt download functionality works
- [ ] Order history displays correctly
- [ ] User profile management works

### **Admin Portal (admin_portal.html)**
- [ ] Admin login works (admin/admin123)
- [ ] Dashboard displays statistics
- [ ] "Initialize Sample Data" button works
- [ ] Menu management (add/edit/delete items)
- [ ] User management functionality
- [ ] Order management and status updates
- [ ] All tabs switch correctly
- [ ] Data persistence works

### **Receipt System**
- [ ] Receipt modal opens correctly
- [ ] Receipt contains all required information:
  - [ ] Company header with contact details
  - [ ] Order number and timestamp
  - [ ] Customer information
  - [ ] Payment method and ID
  - [ ] Itemized list with quantities and prices
  - [ ] Subtotal, discount, tax, and total
  - [ ] Footer with thank you message
- [ ] Print functionality works across browsers
- [ ] Download creates proper HTML file
- [ ] Receipt closes properly

### **Cross-Browser Testing**
- [ ] Chrome - All features work
- [ ] Firefox - All features work
- [ ] Safari - All features work
- [ ] Edge - All features work
- [ ] Mobile browsers - Responsive design works

## 🔧 Configuration Updates

### **Production Environment Variables**
```env
# Backend (.env file)
DB_HOST=your_production_db_host
DB_PORT=5432
DB_NAME=canteen_db
DB_USER=your_db_user
DB_PASSWORD=your_secure_password
JWT_SECRET=your_very_secure_jwt_secret_key
PORT=3000
```

### **Frontend Configuration Updates**

#### **Update API Base URL (if needed)**
In `c3.html`, update the API base URL:
```javascript
const API_BASE_URL = 'https://your-domain.com'; // Update this
```

#### **Update Image Paths**
In `c3.html`, update image serving URL:
```javascript
<img src="${API_BASE_URL}/images/${item.image}" alt="${item.name}">
```

#### **Update Razorpay Configuration**
In `c3.html`, update Razorpay key:
```javascript
key: 'rzp_live_your_live_key', // Replace test key with live key
```

## 🛡️ Security Checklist

### **Backend Security**
- [ ] Environment variables properly configured
- [ ] Database credentials secured
- [ ] JWT secret is strong and unique
- [ ] CORS configured for your domain only
- [ ] Input validation implemented
- [ ] SQL injection protection in place
- [ ] Rate limiting configured (if needed)

### **Frontend Security**
- [ ] No sensitive data in client-side code
- [ ] API keys properly configured
- [ ] XSS protection measures in place
- [ ] HTTPS enabled in production

## 📊 Performance Optimization

### **Database**
- [ ] Indexes created for frequently queried columns
- [ ] Database connection pooling configured
- [ ] Query optimization reviewed

### **Frontend**
- [ ] Images optimized for web
- [ ] CSS and JavaScript minified (if needed)
- [ ] Caching headers configured
- [ ] CDN setup for static assets (optional)

## 🚀 Deployment Steps

### **1. Backend Deployment**
```bash
# Deploy to your server (example for Node.js hosting)
git clone your-repo
cd cms/backend
npm install --production
# Set up environment variables
# Start with process manager (PM2 recommended)
pm2 start server.js --name canteen-api
```

### **2. Frontend Deployment**
```bash
# Upload HTML files to web server
# Ensure proper file permissions
# Configure web server (Apache/Nginx) if needed
```

### **3. Database Deployment**
```bash
# Create production database
# Run schema.sql
# Set up database backups
# Configure database monitoring
```

## 🔍 Post-Deployment Testing

### **Smoke Tests**
1. **Basic Functionality**
   - [ ] Website loads without errors
   - [ ] Login/signup works
   - [ ] Order placement works
   - [ ] Payment processing works
   - [ ] Receipt generation works
   - [ ] Admin portal accessible

2. **Integration Tests**
   - [ ] Database connectivity
   - [ ] Payment gateway integration
   - [ ] Email notifications (if implemented)
   - [ ] File uploads/downloads

3. **Performance Tests**
   - [ ] Page load times acceptable
   - [ ] Database query performance
   - [ ] Concurrent user handling
   - [ ] Memory usage monitoring

## 📱 Mobile Responsiveness

### **Test on Different Screen Sizes**
- [ ] Mobile phones (320px - 480px)
- [ ] Tablets (768px - 1024px)
- [ ] Desktop (1024px+)
- [ ] Touch interactions work properly
- [ ] Receipt printing works on mobile

## 🆘 Troubleshooting Guide

### **Common Issues & Solutions**

#### **Backend Issues**
- **Server won't start**: Check environment variables and database connection
- **API errors**: Check logs and database connectivity
- **Image serving issues**: Verify static file serving configuration

#### **Frontend Issues**
- **Receipt not generating**: Check browser console for JavaScript errors
- **Payment failures**: Verify Razorpay configuration and test credentials
- **Admin portal errors**: Clear browser cache and check localStorage

#### **Database Issues**
- **Connection errors**: Verify credentials and network connectivity
- **Schema errors**: Ensure all tables and indexes are created properly
- **Performance issues**: Check query optimization and indexing

## 📋 Maintenance Tasks

### **Regular Maintenance**
- [ ] Database backups scheduled
- [ ] Log rotation configured
- [ ] Security updates applied
- [ ] Performance monitoring in place
- [ ] Error tracking configured

### **Monitoring Setup**
- [ ] Server uptime monitoring
- [ ] Database performance monitoring
- [ ] Application error tracking
- [ ] User activity analytics (optional)

## 🎯 Success Metrics

### **Technical Metrics**
- Server uptime > 99.5%
- Page load time < 3 seconds
- API response time < 500ms
- Zero critical security vulnerabilities

### **Business Metrics**
- User registration rate
- Order completion rate
- Payment success rate
- Customer satisfaction scores

---

## 🚀 Go-Live Checklist

**Final verification before going live:**

- [ ] All tests pass
- [ ] Security review completed
- [ ] Performance benchmarks met
- [ ] Backup and recovery procedures tested
- [ ] Monitoring and alerting configured
- [ ] Documentation updated
- [ ] Team trained on new system
- [ ] Rollback plan prepared

**🎉 Ready for Production!**

Once all items are checked, your Canteen Management System is ready for production deployment!
