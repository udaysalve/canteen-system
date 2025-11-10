// ================================================
// Shree Gajanan Canteen - Simple Backend Server
// Works without database - Uses localStorage on frontend
// ================================================

const express = require('express');
const cors = require('cors');
const path = require('path');

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
// BASIC ROUTES
// ================================================

// Health check
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Backend server is running',
        timestamp: new Date().toISOString()
    });
});

// Test route
app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'Backend API is working!',
        endpoints: [
            '/api/health',
            '/api/test',
            '/images/*'
        ]
    });
});

// Catch-all for undefined routes
app.use('*', (req, res) => {
    res.status(404).json({ 
        error: 'Route not found',
        message: 'The frontend uses localStorage, so database routes are not needed'
    });
});

// ================================================
// START SERVER
// ================================================
app.listen(PORT, () => {
    console.log('');
    console.log('════════════════════════════════════════════════════════════════');
    console.log('');
    console.log('  ✅ Backend Server Started Successfully!');
    console.log('');
    console.log(`  🌐 Server running on: http://localhost:${PORT}`);
    console.log('  📁 Serving images from: /images/*');
    console.log('  💾 Using localStorage (no database needed)');
    console.log('');
    console.log('════════════════════════════════════════════════════════════════');
    console.log('');
    console.log('  Server is ready! Keep this window open.');
    console.log('');
});

// Handle errors
process.on('uncaughtException', (err) => {
    console.error('❌ Uncaught Exception:', err);
});

process.on('unhandledRejection', (err) => {
    console.error('❌ Unhandled Rejection:', err);
});
