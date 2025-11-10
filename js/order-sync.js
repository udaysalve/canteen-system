/**
 * Order Sync System
 * Syncs orders across devices using a central server
 */

class OrderSync {
    constructor(serverUrl = 'http://localhost:3001') {
        this.serverUrl = serverUrl;
        this.pollInterval = 2000; // Poll every 2 seconds
        this.pollingTimer = null;
        this.lastCheck = new Date().toISOString();
        this.isPolling = false;
        this.onNewOrder = null; // Callback for new orders
    }

    /**
     * Submit a new order to the sync server
     */
    async submitOrder(orderData) {
        try {
            const response = await fetch(`${this.serverUrl}/api/orders`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(orderData)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();
            console.log('✅ Order synced to server:', result.order.id);
            return result;
        } catch (error) {
            console.error('❌ Failed to sync order:', error);
            // Fallback to localStorage only
            return null;
        }
    }

    /**
     * Get all orders from server
     */
    async getAllOrders() {
        try {
            const response = await fetch(`${this.serverUrl}/api/orders`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            return data.orders || [];
        } catch (error) {
            console.error('❌ Failed to fetch orders:', error);
            return [];
        }
    }

    /**
     * Get new orders since last check
     */
    async getNewOrders() {
        try {
            const response = await fetch(`${this.serverUrl}/api/orders/since/${this.lastCheck}`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            
            if (data.orders && data.orders.length > 0) {
                console.log(`📥 Received ${data.orders.length} new order(s)`);
                this.lastCheck = data.lastUpdate || new Date().toISOString();
                return data.orders;
            }
            
            return [];
        } catch (error) {
            console.error('❌ Failed to check for new orders:', error);
            return [];
        }
    }

    /**
     * Start polling for new orders
     */
    startPolling(callback) {
        if (this.isPolling) {
            console.log('⚠️ Already polling');
            return;
        }

        this.onNewOrder = callback;
        this.isPolling = true;
        console.log('🔄 Started polling for new orders (every 2 seconds)');

        this.pollingTimer = setInterval(async () => {
            const newOrders = await this.getNewOrders();
            if (newOrders.length > 0 && this.onNewOrder) {
                this.onNewOrder(newOrders);
            }
        }, this.pollInterval);
    }

    /**
     * Stop polling
     */
    stopPolling() {
        if (this.pollingTimer) {
            clearInterval(this.pollingTimer);
            this.pollingTimer = null;
            this.isPolling = false;
            console.log('🛑 Stopped polling');
        }
    }

    /**
     * Update order status
     */
    async updateOrderStatus(orderId, status) {
        try {
            const response = await fetch(`${this.serverUrl}/api/orders/${orderId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ status })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();
            console.log('✅ Order status updated:', orderId, '→', status);
            return result;
        } catch (error) {
            console.error('❌ Failed to update order status:', error);
            return null;
        }
    }

    /**
     * Check if server is available
     */
    async checkHealth() {
        try {
            const response = await fetch(`${this.serverUrl}/health`);
            if (!response.ok) {
                return false;
            }
            const data = await response.json();
            return data.status === 'ok';
        } catch (error) {
            return false;
        }
    }
}

// Create global instance
window.OrderSync = new OrderSync();

// Auto-check server health on load
window.addEventListener('load', async () => {
    const isHealthy = await window.OrderSync.checkHealth();
    if (isHealthy) {
        console.log('✅ Order sync server is available');
    } else {
        console.warn('⚠️ Order sync server is not available - orders will use localStorage only');
    }
});
