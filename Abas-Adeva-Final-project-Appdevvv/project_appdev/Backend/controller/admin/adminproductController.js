const adminModel = require('../../model/adminModel');
const userModel = require('../../model/userModel'); 
const productModel = require('../../model/productModel');

const adminproductController = {
    // Add Product for both Users and Admins
    addProduct: async (req, res) => {
        try {
            const { name, description, price } = req.body;
            
            // Validate required fields
            if (!name || !description || !price) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'Name, description, and price are required!' 
                });
            }

            // Validate price is a number
            const numericPrice = parseFloat(price);
            if (isNaN(numericPrice) || numericPrice <= 0) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'Price must be a valid positive number!' 
                });
            }

            // Ensure the image file is uploaded
            if (!req.file) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'Image file is required!' 
                });
            }

            const image_url = `/uploads/${req.file.filename}`;

            // Data object for the product
            const newProduct = {
                name,
                description,
                price: numericPrice,
                stock: 0, // Initialize stock as 0
                image_url
            };

            // Insert into products database using the create method
            const result = await productModel.create(newProduct);

            res.json({ 
                success: true, 
                message: 'Product added successfully!',
                product: newProduct
            });
        } catch (err) {
            console.error('Error adding product:', err);
            res.status(500).json({ 
                success: false, 
                message: 'Error adding product', 
                error: err.message || err 
            });
        }
    },

    // Get all products (admin view)
    getAllProducts: async (req, res) => {
        try {
            const products = await adminModel.findAll();
            res.json({ success: true, products });
        } catch (err) {
            console.error('Error fetching products:', err);
            res.status(500).json({ success: false, message: 'Error fetching products', error: err });
        }
    },

    // Get all products with their logs
    getProductsWithLogs: async (req, res) => {
        try {
            const products = await productModel.getProductsWithLogs();
            res.json({ success: true, products });
        } catch (error) {
            console.error('Error fetching products with logs:', error);
            res.status(500).json({ 
                success: false, 
                message: 'Error fetching products with logs',
                error: error.message 
            });
        }
    },

    // Get logs for a specific product
    getProductLogs: async (req, res) => {
        try {
            const productId = req.params.productId;
            const logs = await productModel.getProductLogsById(productId);
            res.json({ 
                success: true, 
                logs 
            });
        } catch (error) {
            console.error('Error fetching product logs:', error);
            res.status(500).json({ 
                success: false, 
                message: 'Error fetching product logs',
                error: error.message 
            });
        }
    }
};

module.exports = adminproductController;
