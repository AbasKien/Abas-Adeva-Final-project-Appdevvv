const productModel = require("../../model/productModel");

// Controller function to get all products
exports.getAllProducts = (req, res) => {
  productModel
    .getAll()
    .then((products) => {
      res.json({ products }); // Return products as a JSON response
    })
    .catch((err) => {
      res.status(500).json({ message: "Error fetching products", error: err });
    });
};
// Controller function to add a new product
exports.addProduct = (req, res) => {
  console.log("Request body:", req.body); // Check form data
  console.log("Uploaded file:", req.file); // Check file data

  if (!req.file) {
    return res.status(400).json({ message: "Image file is required" });
  }

  const { name, description, price } = req.body;
  const image_url = `/uploads/${req.file.filename}`; // Save relative path to the image

  const newProduct = { name, description, price, image_url };

  productModel
    .create(newProduct)
    .then(() => {
      res.json({
        message: "Product added successfully!",
        success: true,
        product: newProduct,
      });
    })
    .catch((err) => {
      console.error("Error adding product:", err);
      res.status(500).json({ message: "Failed to add product", error: err });
    });
};

// Controller function to reduce stock after an order
exports.reduceStock = (req, res) => {
  const { productId, quantity } = req.body;

  if (quantity <= 0) {
    return res
      .status(400)
      .json({ success: false, message: "Quantity must be greater than zero" });
  }

  // Get the product details to check if the quantity ordered is valid
  productModel
    .getById(productId)
    .then((product) => {
      if (product.stock < quantity) {
        return res
          .status(400)
          .json({ success: false, message: "Insufficient stock available" });
      }

      // Update the stock
      return productModel.updateStock(productId, quantity);
    })
    .then(() => {
      res.json({
        success: true,
        message: "Order processed successfully, stock updated",
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Error processing order",
        error: err,
      });
    });
};

// Controller function to update product quantity
// Controller function to update product quantity
exports.updateProductQuantity = (req, res) => {
  console.log("Received update quantity request:");
  console.log("Request Params:", req.params);
  console.log("Request Body:", req.body);

  const { id } = req.params;
  let { quantity } = req.body;

  quantity = Number(quantity);

  if (isNaN(quantity) || quantity <= 0) {
    console.log("Invalid quantity:", quantity);
    return res
      .status(400)
      .json({ message: "Quantity must be a positive number." });
  }

  console.log(`Updating product ID ${id} with quantity: ${quantity}`);

  // Update product quantity and log it
  productModel
    .updateQuantity(id, quantity)
    .then((response) => {
      console.log("Quantity updated and logged successfully:", response);
      res.json({
        success: true,
        message: "Quantity updated and logged successfully",
        data: response,
      });
    })
    .catch((error) => {
      console.error("Error updating quantity:", error);
      res
        .status(500)
        .json({ message: "Error updating product quantity", error });
    });
};

// Controller function to update product details
exports.updateProduct = (req, res) => {
  const productId = req.params.id;
  const { name, description, price } = req.body;

  console.log("Updating product with ID:", productId);
  console.log("Request body:", req.body);

  // Find the product in the database
  productModel
    .getById(productId)
    .then((product) => {
      if (!product) {
        return res.status(404).json({ message: "Product not found" });
      }

      console.log("Found product:", product);

      // Prepare updated fields
      const updatedProduct = {
        name: name || product.name,
        description: description || product.description,
        price: price || product.price,
      };

      // If a new image is uploaded, update the image URL
      if (req.file) {
        console.log("New image uploaded:", req.file);
        updatedProduct.image_url = `/uploads/${req.file.filename}`;
      } else {
        // Keep the old image if no new image is uploaded
        updatedProduct.image_url = product.image_url;
        console.log(
          "No new image uploaded. Keeping old image URL:",
          updatedProduct.image_url
        );
      }

      console.log("Updated product details:", updatedProduct);

      // Update the product in the database
      productModel
        .update(productId, updatedProduct)
        .then(() => {
          console.log("Product updated successfully");
          res.json({
            message: "Product updated successfully",
            success: true,
            product: updatedProduct,
          });
        })
        .catch((err) => {
          console.error("Error updating product:", err);
          res
            .status(500)
            .json({ message: "Error updating product", error: err });
        });
    })
    .catch((err) => {
      console.error("Error fetching product:", err);
      res.status(500).json({ message: "Error fetching product", error: err });
    });
};

// Controller function to get all product logs
exports.getProductsWithLogs = (req, res) => {
  productModel
    .getProductsWithLogs()
    .then((products) => {
      res.json({ products });
    })
    .catch((err) => {
      res
        .status(500)
        .json({ message: "Error fetching products with logs", error: err });
    });
};

// Controller function to get product stock overview
exports.getProductStockOverview = (req, res) => {
  console.log("Received request to get product stock overview.");

  productModel
    .getProductStockOverview()
    .then((stockOverview) => {
      console.log("Stock overview retrieved successfully:", stockOverview);
      // Ensure that the response is always an array
      if (!Array.isArray(stockOverview)) {
        console.error(
          "Unexpected data format: Expected an array but got:",
          typeof stockOverview
        );
        return res
          .status(500)
          .json({ message: "Unexpected data format", error: stockOverview });
      }
      res.json({ stockOverview });
    })
    .catch((err) => {
      console.error(
        "Error occurred while fetching product stock overview:",
        err
      );
      res
        .status(500)
        .json({ message: "Error fetching product stock overview", error: err });
    });
};

exports.getProductStockChangesOverTime = (req, res) => {
  console.log("Received request to get product stock changes over time.");

  productModel
    .getStockChangesOverTime()
    .then((stockChanges) => {
      console.log("Stock changes retrieved successfully:", stockChanges);
      // Ensure that the response is always an array
      if (!Array.isArray(stockChanges)) {
        console.error(
          "Unexpected data format: Expected an array but got:",
          typeof stockChanges
        );
        return res
          .status(500)
          .json({ message: "Unexpected data format", error: stockChanges });
      }
      res.json({ stockChanges });
    })
    .catch((err) => {
      console.error(
        "Error occurred while fetching product stock changes:",
        err
      );
      res
        .status(500)
        .json({ message: "Error fetching product stock changes", error: err });
    });
};


exports.getSalesPerformance = (req, res) => {
  console.log("Received request to get sales performance data.");

  productModel
    .getSalesPerformance()
    .then((salesData) => {
      console.log("Sales performance data retrieved successfully:", salesData);
      if (!Array.isArray(salesData)) {
        console.error("Unexpected data format: Expected an array but got:", typeof salesData);
        return res.status(500).json({ message: "Unexpected data format", error: salesData });
      }
      res.json({ salesPerformance: salesData });
    })
    .catch((err) => {
      console.error("Error occurred while fetching sales performance data:", err);
      res.status(500).json({ message: "Error fetching sales performance data", error: err });
    });
};

exports.getTopSellingProducts = (req, res) => {
  console.log("Received request to get top selling products.");

  productModel
    .getTopSellingProducts()
    .then((topSellingProducts) => {
      console.log("Top selling products data retrieved successfully:", topSellingProducts);
      if (!Array.isArray(topSellingProducts)) {
        console.error("Unexpected data format: Expected an array but got:", typeof topSellingProducts);
        return res.status(500).json({ message: "Unexpected data format", error: topSellingProducts });
      }
      res.json({ topSellingProducts });
    })
    .catch((err) => {
      console.error("Error occurred while fetching top selling products data:", err);
      res.status(500).json({ message: "Error fetching top selling products data", error: err });
    });
    
};