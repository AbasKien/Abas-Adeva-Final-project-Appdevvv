const db = require("../config/db"); // Your MySQL database connection

const productModel = {
  // Method to get all products
  getAll: () => {
    return new Promise((resolve, reject) => {
      const query = "SELECT * FROM products"; // Fetching all products
      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching products:", err);
          return reject({ message: "Error fetching products", error: err });
        }
        resolve(results);
      });
    });
  },

  // Method to create a new product (add product)
  create: (data) => {
    return new Promise((resolve, reject) => {
      const query =
        "INSERT INTO products (name, description, price, image_url) VALUES (?, ?, ?, ?)";
      db.query(
        query,
        [data.name, data.description, data.price, data.image_url],
        (err, result) => {
          if (err) {
            console.error("Error inserting product:", err);
            return reject({ message: "Error inserting product", error: err });
          }
          resolve({ success: true, result });
        }
      );
    });
  },

  // Method to update stock after an order is placed
  updateStock: (productId, quantity) => {
    return new Promise((resolve, reject) => {
      const query =
        "UPDATE products SET stocks = stocks - ? WHERE id = ? AND stocks >= ?";
      db.query(query, [quantity, productId, quantity], (err, result) => {
        if (err) {
          console.error("Error updating stock:", err);
          return reject(err);
        }
        // If no rows are affected, it means stock was insufficient
        if (result.affectedRows === 0) {
          return reject("Insufficient stock");
        }
        resolve(result);
      });
    });
  },

  // Method to get product details by ID
  getById: (productId) => {
    return new Promise((resolve, reject) => {
      const query = "SELECT * FROM products WHERE id = ?";
      db.query(query, [productId], (err, results) => {
        if (err) {
          console.error("Error fetching product:", err);
          return reject(err);
        }
        resolve(results[0]);
      });
    });
  },

  // Method to update the quantity of a product
  updateQuantity: (id, quantity) => {
    return new Promise((resolve, reject) => {
      // First, check if the product exists
      const checkQuery = "SELECT * FROM products WHERE id = ?";
      db.query(checkQuery, [id], (err, result) => {
        if (err) {
          console.error("Error checking if product exists:", err);
          return reject({ message: "Error checking product", error: err });
        }
        if (result.length === 0) {
          // Product not found
          return reject({ message: "Product not found" });
        }

        const currentQuantity = result[0].stock; // Get the current quantity of the product

        // Update the quantity: adding or subtracting the value
        const updatedQuantity = currentQuantity + quantity;

        // Ensure quantity doesn't go negative if you only want to allow positive quantities
        if (updatedQuantity < 0) {
          return reject({ message: "Cannot have negative quantity." });
        }

        // Update product quantity
        const updateQuery = "UPDATE products SET stock = ? WHERE id = ?";
        db.query(updateQuery, [updatedQuantity, id], (err, updateResult) => {
          if (err) {
            console.error("Error updating product quantity:", err);
            return reject({ message: "Error updating quantity", error: err });
          }
          if (updateResult.affectedRows === 0) {
            return reject({
              message: "No rows affected. Product may not exist.",
            });
          }

          const reason = "Restock";
          // Insert into product_quantity_logs table
          const logQuery = `
              INSERT INTO product_quantity_logs (product_id, previous_quantity, quantity_changed, new_quantity, reason)
              VALUES (?, ?, ?, ?, ?)
            `;
          db.query(
            logQuery,
            [id, currentQuantity, quantity, updatedQuantity, reason],
            (err, logResult) => {
              if (err) {
                console.error("Error inserting log:", err);
                return reject({
                  message: "Error logging quantity change",
                  error: err,
                });
              }
              resolve({
                success: true,
                message: "Quantity updated and logged successfully",
                updatedQuantity,
              });
            }
          );
        });
      });
    });
  },

  // Method to get product logs by ID
  getProductLogsById: (productId) => {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT 
          pql.id as log_id,
          pql.previous_quantity,
          pql.quantity_changed,
          pql.new_quantity,
          pql.reason,
          pql.created_at
        FROM product_quantity_logs pql
        WHERE pql.product_id = ?
        ORDER BY pql.created_at DESC
      `;
      
      db.query(query, [productId], (err, results) => {
        if (err) {
          console.error("Error fetching product logs:", err);
          return reject(err);
        }
        results.forEach((log) => {
          log.created_at = log.created_at.toISOString();
        });
        resolve(results);
      });
    });
  },

  // Method to update product details
  update: (id, data) => {
    return new Promise((resolve, reject) => {
      // Dynamically build the query and values to update only provided fields
      const fields = [];
      const values = [];
      if (data.name) {
        fields.push("name = ?");
        values.push(data.name);
      }
      if (data.description) {
        fields.push("description = ?");
        values.push(data.description);
      }
      if (data.price) {
        fields.push("price = ?");
        values.push(data.price);
      }
      if (data.image_url) {
        fields.push("image_url = ?");
        values.push(data.image_url);
      }
      // If no fields are provided, reject with an error
      if (fields.length === 0) {
        return reject({ message: "No fields to update" });
      }
      // Add the ID at the end for the WHERE clause
      values.push(id);
      const query = `UPDATE products SET ${fields.join(", ")} WHERE id = ?`;

      db.query(query, values, (err, result) => {
        if (err) {
          console.error("Error updating product:", err);
          return reject({ message: "Error updating product", error: err });
        }
        if (result.affectedRows === 0) {
          return reject({ message: "Product not found or no changes made" });
        }
        resolve({
          success: true,
          message: "Product updated successfully",
          result,
        });
      });
    });
  },

  getProductsWithLogs: () => {
    return new Promise((resolve, reject) => {
      const query = `
  SELECT 
  p.id, 
  p.name, 
  p.stock,
  pql.id AS log_id, 
  pql.previous_quantity,
  pql.quantity_changed,
  pql.new_quantity,
  pql.reason,
  pql.created_at
FROM 
  products p
LEFT JOIN 
  product_quantity_logs pql ON p.id = pql.product_id
ORDER BY 
  p.id, pql.created_at DESC;
`;

      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching products with logs:", err);
          return reject({
            message: "Error fetching products with logs",
            error: err,
          });
        }
        resolve(results);
      });
    });
  },

  getProductStockOverview: () => {
    return new Promise((resolve, reject) => {
      const query = "SELECT name, stock FROM products"; // Query to get stock overview
      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching product stock overview:", err);
          return reject({
            message: "Error fetching product stock overview",
            error: err,
          });
        }
        resolve(results);
      });
    });
  },

  getStockChangesOverTime: () => {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT 
          p.id AS product_id,
          p.name AS product_name,
          pql.previous_quantity,
          pql.quantity_changed,
          pql.new_quantity,
          pql.reason,
          pql.created_at
        FROM 
          product_quantity_logs pql
        JOIN 
          products p ON pql.product_id = p.id
        ORDER BY 
          pql.created_at DESC;
      `;
      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching stock changes over time:", err);
          return reject({
            message: "Error fetching stock changes",
            error: err,
          });
        }
        resolve(results);
      });
    });
  },

  getSalesPerformance: () => {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT 
          DATE_FORMAT(created_at, '%Y-%m-%d') AS date,
          SUM(total_price) AS total_sales
        FROM 
          orders
        WHERE 
          status = 'complete' -- Only include completed orders
        GROUP BY 
          DATE_FORMAT(created_at, '%Y-%m-%d')
        ORDER BY 
          date ASC;
      `;

      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching sales performance data:", err);
          return reject({
            message: "Error fetching sales data",
            error: err,
          });
        }
        resolve(results);
      });
    });
  },

  getTopSellingProducts: () => {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT 
          p.name AS product_name,
          SUM(oi.quantity) AS total_sold
        FROM 
          order_items oi
        JOIN 
          products p ON oi.product_id = p.id
        GROUP BY 
          p.id, p.name
        ORDER BY 
          total_sold DESC
        LIMIT 10;
      `;

      db.query(query, (err, results) => {
        if (err) {
          console.error("Error fetching top selling products data:", err);
          return reject({
            message: "Error fetching top selling products data",
            error: err,
          });
        }
        resolve(results);
      });
    });
  },
};

module.exports = productModel;
