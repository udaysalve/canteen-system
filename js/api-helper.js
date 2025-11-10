// ================================================
// API Helper Functions
// Handles communication with backend database
// ================================================

const API_CONFIG = {
    BASE_URL: 'http://localhost:3000/api',
    TIMEOUT: 10000
};

// Get auth token from localStorage
function getAuthToken() {
    return localStorage.getItem('authToken');
}

// Generic API call function
async function apiCall(endpoint, method = 'GET', data = null, requiresAuth = true) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json',
        }
    };

    // Add auth token if required
    if (requiresAuth) {
        const token = getAuthToken();
        if (token) {
            options.headers['Authorization'] = `Bearer ${token}`;
        }
    }

    // Add body data for POST/PUT requests
    if (data && (method === 'POST' || method === 'PUT')) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(`${API_CONFIG.BASE_URL}${endpoint}`, options);
        const result = await response.json();

        if (!response.ok) {
            throw new Error(result.error || 'API request failed');
        }

        return result;
    } catch (error) {
        console.error('API Error:', error);
        // Fallback to localStorage if API fails
        return { error: error.message, fallback: true };
    }
}

// ================================================
// ORDER SYNC FUNCTIONS
// ================================================

// Sync order to database
async function syncOrderToDatabase(orderData) {
    try {
        const currentUser = localStorage.getItem('currentUser');
        if (!currentUser) {
            console.error('No user logged in');
            return null;
        }

        // Prepare order data for API
        const apiOrderData = {
            items: orderData.items.map(item => ({
                item_id: getMenuItemId(item.name),
                quantity: item.quantity,
                special_request: item.special_request || ''
            })),
            table_number: Math.floor(Math.random() * 20) + 1,
            payment_method: orderData.payment_method || 'cash',
            special_instructions: orderData.special_instructions || ''
        };

        // Create order via API
        const result = await apiCall('/orders', 'POST', apiOrderData);

        if (result.error && result.fallback) {
            // Fallback: Store in localStorage for admin portal
            return syncOrderToLocalStorage(orderData);
        }

        return result.order;
    } catch (error) {
        console.error('Error syncing order:', error);
        // Fallback to localStorage
        return syncOrderToLocalStorage(orderData);
    }
}

// Fallback: Sync to localStorage (for admin portal compatibility)
function syncOrderToLocalStorage(orderData) {
    const currentUser = localStorage.getItem('currentUser');
    let adminOrders = JSON.parse(localStorage.getItem('GajananCMS_orders')) || [];
    
    // Generate order number
    const orderNumber = 'ORD' + Date.now().toString().slice(-8);

    const newOrder = {
        id: adminOrders.length + 1,
        order_number: orderNumber,
        userId: currentUser,
        userName: currentUser,
        items: orderData.items.map(item => `${item.quantity}x ${item.name}`).join(', '),
        itemsDetail: orderData.items, // Store detailed items
        status: orderData.payment_status === 'completed' ? 'COMPLETE' : 'NEW',
        tableNumber: Math.floor(Math.random() * 20) + 1,
        timestamp: new Date().toISOString(),
        created_at: new Date().toISOString(),
        subtotal: orderData.total,
        discount: orderData.discount || 0,
        total: orderData.total,
        payment_method: orderData.payment_method,
        payment_status: orderData.payment_status,
        order_type: 'dine-in'
    };

    adminOrders.push(newOrder);
    localStorage.setItem('GajananCMS_orders', JSON.stringify(adminOrders));
    
    // Also maintain order transaction records
    maintainOrderTransactionRecord(newOrder);

    return newOrder;
}

// Maintain separate order transaction records
function maintainOrderTransactionRecord(orderData) {
    let orderTransactions = JSON.parse(localStorage.getItem('order_transactions')) || [];
    
    const transaction = {
        transaction_id: 'OTXN' + Date.now(),
        order_id: orderData.id,
        order_number: orderData.order_number,
        user_id: orderData.userId,
        user_name: orderData.userName,
        transaction_type: 'ORDER',
        items: orderData.itemsDetail || [],
        subtotal: orderData.subtotal,
        discount: orderData.discount || 0,
        total_amount: orderData.total,
        status: orderData.status,
        timestamp: new Date().toISOString(),
        table_number: orderData.tableNumber
    };
    
    orderTransactions.push(transaction);
    localStorage.setItem('order_transactions', JSON.stringify(orderTransactions));
    
    return transaction;
}

// ================================================
// PAYMENT SYNC FUNCTIONS
// ================================================

// Sync payment to database
async function syncPaymentToDatabase(paymentData) {
    try {
        const apiPaymentData = {
            order_id: paymentData.order_id,
            payment_method: paymentData.payment_method,
            payment_gateway: paymentData.payment_gateway || 'razorpay',
            transaction_id: paymentData.transaction_id || generateTransactionId(),
            razorpay_payment_id: paymentData.razorpay_payment_id,
            razorpay_order_id: paymentData.razorpay_order_id,
            amount: paymentData.amount,
            payment_status: paymentData.payment_status
        };

        const result = await apiCall('/payments', 'POST', apiPaymentData);

        if (result.error && result.fallback) {
            // Fallback: Store in localStorage
            return syncPaymentToLocalStorage(paymentData);
        }

        return result.payment;
    } catch (error) {
        console.error('Error syncing payment:', error);
        return syncPaymentToLocalStorage(paymentData);
    }
}

// Fallback: Sync payment to localStorage
function syncPaymentToLocalStorage(paymentData) {
    let payments = JSON.parse(localStorage.getItem('payment_history')) || [];
    const currentUser = localStorage.getItem('currentUser');

    const newPayment = {
        payment_id: payments.length + 1,
        transaction_id: paymentData.transaction_id || generateTransactionId(),
        order_id: paymentData.order_id,
        order_number: paymentData.order_number,
        user_id: currentUser,
        user_name: currentUser,
        payment_method: paymentData.payment_method,
        payment_gateway: paymentData.payment_gateway,
        razorpay_payment_id: paymentData.razorpay_payment_id,
        razorpay_order_id: paymentData.razorpay_order_id,
        amount: paymentData.amount,
        currency: 'INR',
        payment_status: paymentData.payment_status || 'success',
        payment_date: new Date().toISOString(),
        timestamp: new Date().toISOString()
    };

    payments.push(newPayment);
    localStorage.setItem('payment_history', JSON.stringify(payments));
    
    // Also maintain payment transaction records
    maintainPaymentTransactionRecord(newPayment);

    return newPayment;
}

// Maintain separate payment transaction records
function maintainPaymentTransactionRecord(paymentData) {
    let paymentTransactions = JSON.parse(localStorage.getItem('payment_transactions')) || [];
    
    const transaction = {
        transaction_id: paymentData.transaction_id,
        payment_id: paymentData.payment_id,
        order_id: paymentData.order_id,
        order_number: paymentData.order_number,
        user_id: paymentData.user_id,
        user_name: paymentData.user_name,
        transaction_type: 'PAYMENT',
        payment_method: paymentData.payment_method,
        payment_gateway: paymentData.payment_gateway,
        gateway_payment_id: paymentData.razorpay_payment_id,
        amount: paymentData.amount,
        currency: paymentData.currency,
        status: paymentData.payment_status,
        timestamp: paymentData.timestamp,
        payment_date: paymentData.payment_date
    };
    
    paymentTransactions.push(transaction);
    localStorage.setItem('payment_transactions', JSON.stringify(paymentTransactions));
    
    return transaction;
}

// ================================================
// HELPER FUNCTIONS
// ================================================

// Get menu item ID by name (fallback to 0 if not found)
function getMenuItemId(itemName) {
    // This would normally query the database
    // For now, return a default ID
    const menuMap = {
        'Tea': 1,
        'Special Tea': 2,
        'Coffee': 3,
        'Milk': 4,
        'Cold Chocolate Milk': 5,
        'Pohe': 6,
        'Vada Pav': 7,
        'Idli Sambar': 8,
        'Paneer Masala': 9,
        'Dal Fry': 10
    };
    return menuMap[itemName] || 0;
}

// Generate transaction ID
function generateTransactionId() {
    return 'TXN' + Date.now() + Math.random().toString(36).substr(2, 9).toUpperCase();
}

// ================================================
// REAL-TIME SYNC TRIGGER
// ================================================

// Trigger admin panel refresh (using localStorage event)
function notifyAdminPanel() {
    // Set a flag that admin panel can listen to
    localStorage.setItem('admin_refresh_trigger', Date.now().toString());
    
    // Dispatch custom event
    window.dispatchEvent(new CustomEvent('orderUpdated', {
        detail: { timestamp: Date.now() }
    }));
}

// ================================================
// EXPORT FUNCTIONS
// ================================================

window.CanteenAPI = {
    syncOrderToDatabase,
    syncPaymentToDatabase,
    notifyAdminPanel,
    apiCall
};
