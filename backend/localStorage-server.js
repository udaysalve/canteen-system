// ================================================
// Shree Gajanan Canteen - LocalStorage Backend Server
// Works with localStorage frontend - Provides image serving
// ================================================

const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// ================================================
// MIDDLEWARE
// ================================================
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (images) from the cms directory
app.use('/images', express.static(path.join(__dirname, '../')));
app.use('/api/images', express.static(path.join(__dirname, '../')));
app.use(express.static(path.join(__dirname, '../')));

// ================================================
// BASIC ROUTES
// ================================================

// Health check
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Backend server is running',
        timestamp: new Date().toISOString(),
        mode: 'localStorage',
        note: 'All data is stored in browser localStorage'
    });
});

// Test route
app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'Backend API is working!',
        mode: 'localStorage Mode',
        endpoints: [
            '/api/health',
            '/api/test',
            '/api/debug/info',
            '/images/*'
        ],
        instructions: 'The frontend uses localStorage for data storage. No database needed!'
    });
});

// Debug info endpoint
app.get('/api/debug/info', (req, res) => {
    res.json({
        server: 'Gajanan Canteen Backend',
        mode: 'localStorage',
        port: PORT,
        status: 'Running',
        dataStorage: 'Browser localStorage',
        features: [
            'Image serving',
            'CORS enabled',
            'Static file serving',
            'Health monitoring'
        ],
        troubleshooting: {
            noData: 'Clear browser cache and reload admin portal',
            imagesNotLoading: 'Check if image files exist in root directory',
            dataNotSaving: 'Check browser console for localStorage errors'
        }
    });
});

// Catch-all for undefined routes
app.use('*', (req, res) => {
    res.status(404).json({ 
        error: 'Route not found',
        message: 'The frontend uses localStorage, so database routes are not needed',
        availableEndpoints: [
            '/api/health',
            '/api/test',
            '/api/debug/info',
            '/images/*'
        ]
    });
});

// ================================================
// START SERVER
// ================================================
app.listen(PORT, () => {
    console.log('');
    console.log('════════════════════════════════════════════════════════════════');
    console.log('');
    console.log('  ✅ Gajanan Canteen Backend Server Started!');
    console.log('');
    console.log(`  🌐 Server running on: http://localhost:${PORT}`);
    console.log('  📁 Serving images from: /images/*');
    console.log('  💾 Data Storage: Browser localStorage (No database needed)');
    console.log('  🔧 Debug Info: http://localhost:${PORT}/api/debug/info');
    console.log('');
    console.log('  📱 Frontend URLs:');
    console.log('     Customer App: http://localhost:8080/c3.html');
    console.log('     Admin Portal: http://localhost:8080/admin_portal.html');
    console.log('');
    console.log('════════════════════════════════════════════════════════════════');
    console.log('');
    console.log('  ℹ️  IMPORTANT: If admin portal shows no data:');
    console.log('     1. Open browser DevTools (F12)');
    console.log('     2. Go to Application > localStorage');
    console.log('     3. Clear all canteen-related data');
    console.log('     4. Reload the admin portal');
    console.log('     5. Data will be initialized automatically');
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
