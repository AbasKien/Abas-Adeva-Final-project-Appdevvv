<template>
  <div class="product-page">
    <!-- Top Announcement Bar -->
    <div class="announcement-bar">
      <p>🚚 Only Cash on deliver | Shop now! | 3-Day Return Guarantee </p>
    </div>

    <!-- Header -->
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <span class="logo-icon">📚</span>
          <span class="logo-text">Margatheo Store</span>
        </div>
        
        <nav class="nav">
          <router-link to="/home" class="nav-link">
            <span class="icon">🏠</span>
            <span class="text">Home</span>
          </router-link>
          <router-link to="/product" class="nav-link">
            <span class="icon">🛍️</span>
            <span class="text">Shop</span>
          </router-link>
        </nav>

        <div class="user-controls">
          <!-- Search Bar -->
          <div class="search-bar">
            <input 
              type="text" 
              v-model="searchQuery" 
              @input="debouncedSearch" 
              placeholder="Search products..."
            />
            <button class="search-button">
              <span class="icon">🔍</span>
            </button>
          </div>

          <!-- Cart Icon -->
          <router-link to="/cart" class="cart-button">
            <span class="cart-icon">🛒</span>
            <span class="cart-text">Cart</span>
            <span class="cart-count" v-if="cartItemCount > 0">{{ cartItemCount }}</span>
          </router-link>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
      <!-- Header section with title and description -->
      <div class="header-section">
        <h1>Our Products</h1>
        <p>Discover quality school supplies for your academic journey</p>
      </div>

      <!-- Product grid -->
      <div class="product-grid">
        <div v-for="product in filteredProducts" :key="product.id" class="product-card">
          <div class="product-image">
            <img :src="`http://localhost:5555${product.image_url}`" :alt="product.name">
            <div class="product-overlay">
              <button 
                @click="addToCart(product)" 
                class="add-to-cart-btn"
                :disabled="product.stock === 0"
              >
                <span class="icon">🛒</span>
                {{ product.stock === 0 ? 'Out of Stock' : 'Add to Cart' }}
              </button>
            </div>
          </div>
          <div class="product-info">
            <h3 class="product-name">{{ product.name }}</h3>
            <p class="product-price">₱{{ formatPrice(product.price) }}</p>
            <p class="product-stock" :class="{ 'low-stock': product.stock <= 5 && product.stock > 0, 'out-of-stock': product.stock === 0 }">
              {{ product.stock === 0 ? 'Out of Stock' : product.stock <= 5 ? `Only ${product.stock} left` : 'In Stock' }}
            </p>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
      <div class="footer-content">
        <p>&copy; 2024 Margatheo Store. All Rights Reserved.</p>
        <p>Powered by <a href="http://localhost:8080/home" target="_blank">Margatheo&reg;</a></p>
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

  methods: {
    async fetchProducts() {
      try {
        this.loading = true;
        const response = await axios.get('http://localhost:5555/products');
        console.log('Products response:', response.data); // Debug log
        this.products = response.data.products.map(product => ({
          ...product,
          orderQuantity: 1
        }));
        this.filteredProducts = [...this.products];
      } catch (error) {
        console.error('Error fetching products:', error);
        if (error.response) {
          console.error('Error response:', error.response.data);
          console.error('Error status:', error.response.status);
        } else if (error.request) {
          console.error('No response received:', error.request);
        } else {
          console.error('Error message:', error.message);
        }
      } finally {
        this.loading = false;
      }
    },

    formatPrice(price) {
      const numPrice = typeof price === 'string' ? parseFloat(price) : price;
      return numPrice.toLocaleString('en-PH', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      });
    },

    debouncedSearch: _.debounce(function () {
      if (!this.searchQuery) {
        this.filteredProducts = this.products;
        return;
      }
      
      const query = this.searchQuery.toLowerCase();
      this.filteredProducts = this.products.filter(product =>
        product.name.toLowerCase().includes(query)
      );
    }, 300),

    async addToCart(product) {
      try {
        await axios.post('http://localhost:5555/cart/add', {
          productId: product.id,
          quantity: product.orderQuantity
        }, { withCredentials: true });
        product.orderQuantity = 1;
        await this.updateCartItemCount();
      } catch (error) {
        if (error.response && error.response.status === 401) {
          alert('Please log in to add items to cart');
          this.$router.push('/login');
        } else {
          console.error('Error adding to cart:', error);
          alert('Failed to add product to cart');
        }
      }
    },

    async updateCartItemCount() {
      try {
        const response = await axios.get('http://localhost:5555/cart', { withCredentials: true });
        this.cartItemCount = response.data.items.reduce((total, item) => total + item.quantity, 0);
      } catch (error) {
        console.error('Error updating cart count:', error);
        this.cartItemCount = 0;
      }
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
    }
  },

  async created() {
    await this.fetchProducts();
    await this.updateCartItemCount();
  }
};
</script>

<style scoped>
.product-page {
  font-family: "Poppins", sans-serif;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  color: #2d3748;
  min-height: 100vh;
}

.announcement-bar {
  background: linear-gradient(90deg, #4f46e5, #7c3aed);
  color: #fff;
  text-align: center;
  padding: 12px;
  font-size: 0.9rem;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

.logo {
  font-size: 1.75rem;
  font-weight: 700;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  letter-spacing: -0.5px;
}

.logo-icon {
  font-size: 1.5rem;
  margin-right: 0.5rem;
}

.logo-text {
  font-size: 1.25rem;
}

.nav {
  display: flex;
  gap: 2rem;
  margin: 0 2rem;
}

.nav-link {
  text-decoration: none;
  color: #4b5563;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.nav-link:hover,
.nav-link.active {
  color: #4f46e5;
  background: rgba(79, 70, 229, 0.1);
}

.search-bar {
  display: flex;
  align-items: center;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  padding: 0.5rem 1rem;
  margin-right: 1.5rem;
  transition: all 0.3s ease;
}

.search-bar:focus-within {
  border-color: #4f46e5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.search-bar input {
  border: none;
  outline: none;
  width: 250px;
  font-size: 0.95rem;
  color: #4b5563;
  padding: 0.25rem 0.5rem;
}

.search-bar button {
  background: none;
  border: none;
  color: #4b5563;
  cursor: pointer;
  padding: 0.25rem;
  transition: color 0.3s ease;
}

.search-bar button:hover {
  color: #4f46e5;
}

.cart-button {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: transparent;
  color: #1A365D;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  position: relative;
}

.cart-count {
  position: absolute;
  top: 0;
  right: 0;
  transform: translate(25%, -25%);
  background: #EF4444;
  color: white;
  font-size: 0.75rem;
  font-weight: 600;
  min-width: 1.25rem;
  height: 1.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 9999px;
  padding: 0 0.25rem;
}

.cart-button:hover {
  background: rgba(79, 70, 229, 0.1);
  color: #4F46E5;
  border-color: #4F46E5;
}

.cart-icon {
  font-size: 1.25rem;
  transition: transform 0.3s ease;
}

.cart-button:hover .cart-icon {
  transform: translateY(-2px);
}

.cart-text {
  font-weight: 500;
  letter-spacing: 0.025em;
}

.user-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.product-card:hover {
  transform: translateY(-5px);
}

.product-image {
  position: relative;
  padding-top: 100%;
  overflow: hidden;
}

.product-image img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 1rem;
}

.product-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(255, 255, 255, 0.95);
  padding: 1rem;
  transform: translateY(100%);
  transition: transform 0.3s ease;
}

.product-card:hover .product-overlay {
  transform: translateY(0);
}

.add-to-cart-btn {
  width: 100%;
  padding: 0.75rem;
  background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
  color: white;
  border: none;
  border-radius: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  position: relative;
  overflow: hidden;
}

.add-to-cart-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #7C3AED 0%, #4F46E5 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.add-to-cart-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
}

.add-to-cart-btn:hover:not(:disabled)::before {
  opacity: 1;
}

.add-to-cart-btn > * {
  position: relative;
  z-index: 1;
}

.add-to-cart-btn:disabled {
  background: #E5E7EB;
  color: #9CA3AF;
  cursor: not-allowed;
  transform: none;
}

.add-to-cart-btn .icon {
  font-size: 1.25rem;
}

.product-info {
  padding: 1rem;
  text-align: center;
}

.product-name {
  font-size: 1.1rem;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.product-price {
  font-size: 1.2rem;
  color: #4f46e5;
  font-weight: 600;
}

.product-stock {
  font-size: 0.9rem;
  color: #666;
}

.low-stock {
  color: #f4511e;
}

.out-of-stock {
  color: #e53e3e;
}

.footer {
  background: white;
  padding: 1.5rem 0;
  text-align: center;
  border-top: 1px solid #e2e8f0;
}

.footer-content {
  color: #64748b;
  font-size: 0.9rem;
}

.footer-content a {
  color: #4f46e5;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.footer-content a:hover {
  color: #7c3aed;
}

/* Responsive Design */
@media (max-width: 768px) {
  .container {
    padding: 1rem;
  }

  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1rem;
  }

  .header-section h1 {
    font-size: 1.75rem;
  }
}

@media (max-width: 480px) {
  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  }

  .product-name {
    font-size: 1rem;
  }

  .product-price {
    font-size: 1.1rem;
  }
}
</style>
