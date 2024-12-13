const orderModel = require('../../model/orderModel');

// Get all orders for admin
exports.getAllOrders = async (req, res) => {
    try {
        orderModel.getAllOrders((err, orders) => {
            if (err) {
                console.error('Error details:', err);
                return res.status(500).json({ 
                    success: false, 
                    message: 'Error fetching orders',
                    error: err.message 
                });
            }
            res.json({ success: true, orders });
        });
    } catch (err) {
        console.error('Error:', err);
        res.status(500).json({ 
            success: false, 
            message: 'Internal server error',
            error: err.message
        });
    }
};

// Update order status
exports.updateOrderStatus = async (req, res) => {
    try {
        const { orderId } = req.params;
        const { status } = req.body;

        if (!orderId) {
            return res.status(400).json({ 
                success: false, 
                message: 'Order ID is required'
            });
        }

        if (!status) {
            return res.status(400).json({ 
                success: false, 
                message: 'Status is required'
            });
        }

        if (!['pending', 'ship', 'delivered', 'complete', 'cancelled'].includes(status)) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid status'
            });
        }

        // Call the model function with orderId and status
        orderModel.updateOrderStatus(orderId, status, (err, result) => {
            if (err) {
                console.error('Error in updateOrderStatus:', err);
                return res.status(500).json({ 
                    success: false, 
                    message: err.message || 'Error updating order status'
                });
            }
            res.json(result);
        });
    } catch (err) {
        console.error('Error in updateOrderStatus controller:', err);
        res.status(500).json({ 
            success: false, 
            message: 'Internal server error'
        });
    }
};

// Get order details
exports.getOrderDetails = async (req, res) => {
    try {
        const { orderId } = req.params;
        console.log('Fetching details for order:', orderId);
        
        orderModel.getOrderDetails(orderId, (err, orderDetails) => {
            if (err) {
                console.error('Error details:', err);
                return res.status(500).json({ 
                    success: false, 
                    message: 'Error fetching order details',
                    error: err.message
                });
            }
            console.log('Order details from database:', orderDetails);
            res.json({ success: true, orderDetails });
        });
    } catch (err) {
        console.error('Error:', err);
        res.status(500).json({ 
            success: false, 
            message: 'Internal server error',
            error: err.message
        });
    }
};

// Get sales performance data
exports.getSalesPerformance = async (req, res) => {
    try {
        // Get all orders using a promise wrapper
        const getAllOrdersPromise = () => {
            return new Promise((resolve, reject) => {
                orderModel.getAllOrders((err, orders) => {
                    if (err) reject(err);
                    else resolve(orders);
                });
            });
        };

        // Fetch orders
        const orders = await getAllOrdersPromise();

        // Process orders to get daily sales data
        const salesByDate = orders.reduce((acc, order) => {
            // Only count completed orders
            if (order.status === 'complete') {
                // Convert the date to Asia/Manila timezone (UTC+8)
                const orderDate = new Date(order.created_at);
                const manilaDate = new Date(orderDate.getTime() + (8 * 60 * 60 * 1000)); // Add 8 hours for Manila time
                const date = manilaDate.toISOString().split('T')[0];
                
                if (!acc[date]) {
                    acc[date] = 0;
                }
                acc[date] += parseFloat(order.total_price || 0);
            }
            return acc;
        }, {});

        // Convert to array format and sort by date
        const salesPerformance = Object.entries(salesByDate)
            .map(([date, total_sales]) => ({
                date,
                total_sales
            }))
            .sort((a, b) => new Date(b.date) - new Date(a.date))
            .slice(0, 30); // Get last 30 days

        res.json({
            success: true,
            salesPerformance: salesPerformance
        });
    } catch (err) {
        console.error('Error:', err);
        res.status(500).json({
            success: false,
            message: 'Internal server error',
            error: err.message
        });
    }
};
