// router.js
const express = require("express");
const router = express.Router();
const userController = require("../controller/users/userController");
const productController = require("../controller/admin/productController");
const adminproductController = require("../controller/admin/adminproductController");
const orderController = require("../controller/users/orderController");
const cartController = require("../controller/users/cartController");
const upload = require("../config/upload"); 
const authenticate = require("../middleware/authenticate"); 

// Define routes
router.get("/verify-email", userController.verifyEmail);
router.post("/register", userController.registrationHandler); 
router.post("/login", userController.loginHandler); // Handle login

// Route to fetch all products
router.post("/adminproducts", adminproductController.addProduct);

// Route to add a product with image upload
router.post(
  "/add-product",
  upload.single("image"),
  productController.addProduct
);

// Route to fetch all products
router.get("/products", productController.getAllProducts);

// Route to reduce stock after an order is placed
router.post("/admin/reduce-stock", productController.reduceStock);

router.post('/cart/add', cartController.addToCart);
// Get all cart items
router.get('/cart', cartController.getCartItems);

// Update item quantity
router.put('/cart/update-quantity', cartController.updateCartQuantity);

// Remove item from cart
router.delete('/cart/remove', cartController.removeFromCart);

router.post("/orders", orderController.placeOrder); // Route to handle order placement

router.get("/check-session", (req, res) => {
  if (req.session.userId) {
    res.status(200).json({ role: req.session.role });
  } else {
    res.status(401).json({ message: "Not authenticated" });
  }
});

router.post("/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).send({ message: "Failed to logout" });
    }
    res.clearCookie("connect.sid"); // Clear the session cookie
    res.status(200).send({ message: "Logged out successfully" });
  });
});

module.exports = router; // Export the router for use in app.js
