const db = require('../config/db');

// Function to create an order in the database
const createOrder = (orderData, callback) => {
  const { contact_number, address, payment, total_price } = orderData;

  const query = 'INSERT INTO orders (contact_number, address, payment_method, total_price) VALUES (?, ?, ?, ?)';
  const values = [contact_number, address, payment, total_price];

  db.execute(query, values, (err, result) => {
    if (err) {
      return callback(err, null);
    }
    return callback(null, result.insertId);  // Return the order ID
  });
};

module.exports = { createOrder };
