const express = require('express');
const cors = require('cors');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const PORT = 3001;

// Enable CORS for all origins
app.use(cors());
app.use(express.json());

const ORDERS_FILE = path.join(__dirname, '..', 'shared-orders.json');

// Initialize orders file if it doesn't exist
async function initOrdersFile() {
    try {
        await fs.access(ORDERS_FILE);
    } catch {
        await fs.writeFile(ORDERS_FILE, JSON.stringify({ orders: [], lastUpdate: null }));
    }
}

// Read orders from file
async function readOrders() {
    try {
        const data = await fs.readFile(ORDERS_FILE, 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error('Error reading orders:', error);
        return { orders: [], lastUpdate: null };
    }
}

// Write orders to file
async function writeOrders(data) {
    try {
        await fs.writeFile(ORDERS_FILE, JSON.stringify(data, null, 2));
        return true;
    } catch (error) {
        console.error('Error writing orders:', error);
        return false;
    }
}

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'Sync server is running' });
});

// Get all orders
app.get('/api/orders', async (req, res) => {
    try {
        const data = await readOrders();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: 'Failed to read orders' });
    }
});

// Add new order
app.post('/api/orders', async (req, res) => {
    try {
        const newOrder = req.body;
        const data = await readOrders();
        
        // Add order ID if not present
        if (!newOrder.id) {
            newOrder.id = data.orders.length + 1;
        }
        
        // Add timestamp if not present
        if (!newOrder.timestamp) {
            newOrder.timestamp = new Date().toISOString();
        }
        
        // Add status if not present
        if (!newOrder.status) {
            newOrder.status = 'NEW';
        }
        
        data.orders.unshift(newOrder);
        data.lastUpdate = new Date().toISOString();
        
        await writeOrders(data);
        
        console.log('✅ New order added:', newOrder.id, '| Table:', newOrder.table_number);
        
        res.json({ success: true, order: newOrder });
    } catch (error) {
        console.error('Error adding order:', error);
        res.status(500).json({ error: 'Failed to add order' });
    }
});

// Update order status
app.put('/api/orders/:id', async (req, res) => {
    try {
        const orderId = parseInt(req.params.id);
        const updates = req.body;
        const data = await readOrders();
        
        const orderIndex = data.orders.findIndex(o => o.id === orderId);
        if (orderIndex === -1) {
            return res.status(404).json({ error: 'Order not found' });
        }
        
        data.orders[orderIndex] = { ...data.orders[orderIndex], ...updates };
        data.lastUpdate = new Date().toISOString();
        
        await writeOrders(data);
        
        res.json({ success: true, order: data.orders[orderIndex] });
    } catch (error) {
        res.status(500).json({ error: 'Failed to update order' });
    }
});

// Get orders since timestamp (for polling)
app.get('/api/orders/since/:timestamp', async (req, res) => {
    try {
        const since = new Date(req.params.timestamp);
        const data = await readOrders();
        
        const newOrders = data.orders.filter(order => {
            const orderTime = new Date(order.timestamp);
            return orderTime > since;
        });
        
        res.json({ orders: newOrders, lastUpdate: data.lastUpdate });
    } catch (error) {
        res.status(500).json({ error: 'Failed to get new orders' });
    }
});

// Clear all orders (for testing)
app.delete('/api/orders', async (req, res) => {
    try {
        await writeOrders({ orders: [], lastUpdate: new Date().toISOString() });
        res.json({ success: true, message: 'All orders cleared' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to clear orders' });
    }
});

// Start server
initOrdersFile().then(() => {
    app.listen(PORT, '0.0.0.0', () => {
        console.log('╔════════════════════════════════════════════╗');
        console.log('║   🔄 Order Sync Server Started            ║');
        console.log('╠════════════════════════════════════════════╣');
        console.log(`║   Port: ${PORT}                              ║`);
        console.log(`║   Status: ✅ Running                       ║`);
        console.log(`║   CORS: ✅ Enabled for all origins        ║`);
        console.log('╠════════════════════════════════════════════╣');
        console.log('║   Endpoints:                               ║');
        console.log(`║   GET    /health                           ║`);
        console.log(`║   GET    /api/orders                       ║`);
        console.log(`║   POST   /api/orders                       ║`);
        console.log(`║   PUT    /api/orders/:id                   ║`);
        console.log(`║   GET    /api/orders/since/:timestamp      ║`);
        console.log(`║   DELETE /api/orders                       ║`);
        console.log('╚════════════════════════════════════════════╝');
        console.log('');
        console.log('💡 Orders will sync across all devices!');
        console.log('📱 Mobile orders → 🖥️  Admin dashboard');
        console.log('');
    });
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down sync server...');
    process.exit(0);
});
