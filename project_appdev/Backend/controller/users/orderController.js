const { createOrder } = require('../../model/orderModel');

const placeOrder = (req, res) => {
  const { contact_number, address, payment, total_price } = req.body;

  // Create the order in the database
  createOrder({ contact_number, address, payment, total_price }, (err, orderId) => {
    if (err) {
      console.error('Error inserting order into database:', err);
      return res.status(500).json({ message: 'Failed to place order' });
    }

    // Respond with success message
    return res.status(200).json({
      message: 'Order placed successfully!',
      orderId, // Optionally include the Order ID in the response
    });
  });
};

module.exports = { placeOrder };
