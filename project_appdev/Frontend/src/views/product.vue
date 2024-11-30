<template>
  <div class="product-page">
    <!-- Top Announcement Bar -->
    <div class="announcement-bar">
      <p>🚀 Free shipping on orders over ₱2,000! Shop now.</p>
    </div>

    <!-- Header -->
    <header class="header">
      <div class="logo">Margatheo Store</div>
      <nav class="nav">
        <router-link to="/home" class="nav-link" :class="{ active: $route.path === '/home' }">Home</router-link>
        <router-link to="/product" class="nav-link" :class="{ active: $route.path === '/product' }">Shop</router-link>
      </nav>
      <div class="user-controls">
        <!-- Search Bar -->
        <div class="search-bar">
          <input type="text" v-model="searchQuery" @input="debouncedSearch" placeholder="Search products..." />
          <button><i class="fas fa-search"></i></button>
        </div>
      </div>
      <!-- Cart Icon -->
      <router-link to="/cart" class="cart">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="cart-logo">
          <path d="M6 6h15l-1.5 9h-13L6 6z"></path>
          <path d="M6 6L4 4"></path>
          <path d="M20 6L22 4"></path>
          <circle cx="10" cy="19" r="2"></circle>
          <circle cx="18" cy="19" r="2"></circle>
        </svg>
        <span class="cart-count">{{ cartItemCount }}</span>
      </router-link>
    </header>

    <!-- Products Section -->
    <section class="products">
      <div class="content">
        <h2>Our Products</h2>
        <p class="description">
          Explore our premium collection of school supplies. Quality and style
          to help you succeed.
        </p>
        <div v-if="loading" class="loading">Loading products...</div>
        <div v-else-if="filteredProducts.length > 0" class="product-grid">
          <!-- Product Card -->
          <div class="product-card" v-for="product in filteredProducts" :key="product.id">
            <div class="image-wrapper">
              <img :src="`http://localhost:5555${product.image_url}`" :alt="product.name" class="product-image" />
              <div class="badge" v-if="product.isNew || product.isDiscounted">
                {{ product.isNew ? "New" : product.discount + "% Off" }}
              </div>
            </div>
            <div class="product-info">
              <h3 class="product-name">{{ product.name }}</h3>
              <p class="product-price">
                ₱{{ product.price }} <span class="old-price" v-if="product.oldPrice">₱{{ product.oldPrice }}</span>
              </p>
              <div class="quantity-container">
                <button @click="decrementQuantity(product)" class="quantity-button" :disabled="product.orderQuantity <= 1">-</button>
                <input v-model.number="product.orderQuantity" type="number" min="1" :max="product.stock" class="quantity-input" />
                <button @click="incrementQuantity(product)" class="quantity-button" :disabled="product.orderQuantity >= product.stock">+</button>
              </div>
              <!-- Add to Cart Button -->
              <button @click="addToCart(product)" class="add-to-cart" :disabled="product.orderQuantity <= 0 || product.orderQuantity > product.stock">Add to Cart</button>
            </div>
          </div>
        </div>
        <p v-else>No products available at the moment.</p>
      </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
  <div class="footer-content">
    <p>© 2024 Margatheo Store. All Rights Reserved.</p>
    <div class="social-icons">
      <a href="#"><i class="fab fa-facebook-f"></i></a>
      <a href="#"><i class="fab fa-twitter"></i></a>
      <a href="#"><i class="fab fa-instagram"></i></a>
    </div>
  </div>
</footer>
  </div>
</template>

<script>
import axios from "axios";
import _ from 'lodash';

export default {
  data() {
    return {
      products: [],
      filteredProducts: [],
      searchQuery: '',
      cartItemCount: 0,
      loading: true,
    };
  },
  created() {
    this.fetchProducts();
    this.updateCartItemCount();
  },
  methods: {
  async fetchProducts() {
    try {
      const response = await axios.get("http://localhost:5555/products");
      this.products = response.data.products.map((product) => ({
        ...product,
        orderQuantity: 1,
      }));
      this.filteredProducts = this.products;  // Initially show all products
    } catch (error) {
      console.error("Error fetching products:", error);
    } finally {
      this.loading = false;
    }
  },

  // Debounced search method
  debouncedSearch: _.debounce(function () {
    this.filteredProducts = this.products.filter((product) =>
      product.name.toLowerCase().includes(this.searchQuery.toLowerCase())
    );
  }, 300),

  async addToCart(product) {
    const cart = JSON.parse(localStorage.getItem("cartItems")) || [];
    const existingProduct = cart.find((item) => item.id === product.id);

    if (existingProduct) {
      existingProduct.quantity += product.orderQuantity; // Update quantity if the item exists
    } else {
      cart.push({
        id: product.id,
        name: product.name,
        price: product.price,
        image: `http://localhost:5555${product.image_url}`,
        quantity: product.orderQuantity,
      });
    }

    localStorage.setItem("cartItems", JSON.stringify(cart)); // Save to localStorage
    this.updateCartItemCount(); // Update the cart count
  },

  updateCartItemCount() {
    // Get the current cart from localStorage and calculate the total number of items
    const cart = JSON.parse(localStorage.getItem("cartItems")) || [];
    this.cartItemCount = cart.reduce((total, item) => total + item.quantity, 0);
  },

  decrementQuantity(product) {
    if (product.orderQuantity > 1) {
      product.orderQuantity--;
    }
  },

  incrementQuantity(product) {
    if (product.orderQuantity < product.stock) {
      product.orderQuantity++;
    }
  },
},

// Call updateCartItemCount when the component is created
created() {
  this.fetchProducts();
  this.updateCartItemCount(); // Ensure cart count is updated when the page loads
},

};

</script>

<style scoped>
/* General Reset */
body {
  margin: 0;
  font-family: "Poppins", sans-serif;
  background: #f9f9f9;
  color: #333;
}

.announcement-bar {
  background: linear-gradient(90deg, #f4511e, #ff6e40);
  color: white;
  text-align: center;
  padding: 12px;
  font-size: 14px;
}

/* Header */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 30px;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 32px;
  color: #f4511e;
}

.nav-link {
  font-size: 18px;
  margin: 0 15px;
  text-decoration: none;
  color: #333;
}

.nav-link.active {
  color: #f4511e;
  font-weight: bold;
}

.search-bar {
  position: relative;
  flex-grow: 1;
  max-width: 300px;
}

.search-bar input {
  border: 1px solid #ddd;
  padding: 8px;
  width: 100%;
  border-radius: 25px;
}

.search-bar button {
  position: absolute;
  right: 5px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
}

.cart {
  position: absolute;
  top: 15px;
  right: 30px;
  display: flex;
  align-items: center;
}

.cart .cart-logo {
  width: 24px;
  height: 24px;
}

.cart-count {
  position: absolute;
  top: -8px;
  right: -10px;
  background: #f4511e;
  color: white;
  padding: 3px 6px;
  border-radius: 50%;
  font-size: 14px;
  font-weight: bold;
}

/* Product Grid */
.product-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-around;
  gap: 20px;
  padding: 20px;
}

.product-card {
  display: flex;
  flex-direction: column;
  gap: 15px;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  width: 250px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.product-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

.product-image {
  width: 150px;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
}

.product-info {
  text-align: center;
}

.product-name {
  font-size: 18px;
  font-weight: bold;
}

.product-price {
  font-size: 16px;
  color: #f4511e;
}

.old-price {
  font-size: 14px;
  color: #999;
  text-decoration: line-through;
  margin-left: 10px;
}

.quantity-container {
  display: flex;
  gap: 10px;
  align-items: center;
}

.quantity-button {
  padding: 5px 10px;
  font-size: 14px;
  background: #f4511e;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.quantity-button:disabled {
  background: #ddd;
}

.quantity-input {
  width: 40px;
  padding: 5px;
  font-size: 14px;
  text-align: center;
}

.add-to-cart {
  padding: 10px;
  background: #f4511e;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.add-to-cart:disabled {
  background: #ddd;
}

/* Footer */
.footer {
  background-color: #333;
  color: #fff;
  padding: 20px 0;
  text-align: center;
  box-shadow: 0px -2px 4px rgba(0, 0, 0, 0.1);
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
}

.social-icons {
  display: flex;
  gap: 15px;
}

.social-icons a {
  color: #fff;
  font-size: 18px;
  transition: color 0.3s;
}

.social-icons a:hover {
  color: #f4511e;
}
</style>
