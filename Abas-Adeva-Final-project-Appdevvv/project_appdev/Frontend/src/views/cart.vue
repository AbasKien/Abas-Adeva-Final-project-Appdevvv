<template>
  <div class="cart-page">
    <div class="announcement-bar">
      <p>🚚 Checkout now!</p>
    </div>
    
    <div class="breadcrumb-nav">
      <div class="breadcrumb-item">
        <router-link to="/home" class="breadcrumb-link">
          <span class="icon">🏠</span>
          <span class="text">Home</span>
        </router-link>
      </div>
      <div class="breadcrumb-separator">
        <span class="icon">➜</span>
      </div>
      <div class="breadcrumb-item active">
        <span class="icon">🛒</span>
        <span class="text">Cart</span>
      </div>
    </div>

    <div class="cart-container">
      <!-- Shopping Cart Section -->
      <div class="cart">
        <div class="cart-header">
          <h2 class="cart-title">Shopping Cart</h2>
          <p class="cart-items-count">{{ totalItems }} items</p>
        </div>

        <div v-if="cartItems.length > 0" class="cart-items-list">
          <!-- Loop through cart items -->
          <div v-for="item in cartItems" :key="item.cart_id" class="cart-item">
            <div class="cart-item-image-container">
              <img :src="`http://localhost:5555${item.image_url}`" alt="Item image" class="cart-item-image" />
            </div>
            <div class="cart-item-details">
              <div class="item-info">
                <h3 class="item-name">{{ item.name }}</h3>
                <p class="item-price">₱{{ (Number(item.price) || 0).toFixed(2) }}</p>
              </div>
              <div class="quantity-controls">
                <button @click="decrementQuantity(item)" :disabled="item.quantity <= 1" class="quantity-btn">−</button>
                <input
                  type="number"
                  v-model.number="item.quantity"
                  min="1"
                  :max="item.stock"
                  class="quantity-input"
                  @change="updateCartQuantity(item)"
                />
                <button @click="incrementQuantity(item)" :disabled="item.quantity >= item.stock" class="quantity-btn">+</button>
              </div>
              <button @click="removeItem(item.cart_id)" class="remove-button">×</button>
            </div>
          </div>
        </div>

        <div v-else class="empty-cart">
          <div class="empty-cart-content">
            <span class="empty-cart-icon">🛒</span>
            <p>Your cart is empty</p>
            <router-link to="/product" class="shop-now-btn">Shop Now</router-link>
          </div>
        </div>

        <router-link to="/product" class="back-to-shop">
          <span class="icon">←</span>
          <span>Continue Shopping</span>
        </router-link>
      </div>

      <!-- Summary Section -->
      <div class="summary">
        <div class="summary-content">
          <h2 class="summary-title">Order Summary</h2>
          <div class="summary-items">
            <div class="summary-item">
              <span>Items ({{ totalItems }})</span>
              <span class="amount">₱{{ totalCost.toFixed(2) }}</span>
            </div>
            <div class="shipping-section">
              <label for="shipping" class="shipping-label">SHIPPING</label>
              <select id="shipping" class="shipping-select">
                <option value="58">Standard Delivery - ₱58.00</option>
              </select>
            </div>
            <div class="summary-divider"></div>
            <div class="summary-total">
              <span>Total</span>
              <span class="total-amount">₱{{ (totalCost + 58).toFixed(2) }}</span>
            </div>
          </div>
          <button 
            @click="checkout" 
            class="checkout-button" 
            :disabled="cartItems.length === 0"
            :class="{ 'disabled': cartItems.length === 0 }"
          >
            <span class="icon">🔒</span>
            <span>Secure Checkout</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      cartItems: [], // Initialize an empty array for cart items
      loading: false,
    };
  },
  computed: {
    // Calculate the total number of items in the cart
    totalItems() {
      return this.cartItems.reduce((sum, item) => sum + item.quantity, 0);
    },
    // Calculate the total cost of items in the cart
    totalCost() {
      return this.cartItems.reduce(
        (sum, item) => sum + (Number(item.price) || 0) * item.quantity,
        0
      );
    },
  },
  methods: {
    // Fetch cart items from the backend
    async fetchCartItems() {
      try {
        this.loading = true;
        const response = await axios.get('http://localhost:5555/cart', { withCredentials: true });
        this.cartItems = response.data.items;
      } catch (error) {
        if (error.response && error.response.status === 401) {
          this.$router.push('/login');
        } else {
          console.error('Error fetching cart:', error);
          alert('Failed to load cart items');
        }
      } finally {
        this.loading = false;
      }
    },

    // Increment the quantity of an item
    async incrementQuantity(item) {
      if (item.quantity < item.stock) {
        item.quantity++;
        await this.updateCartQuantity(item);
      }
    },

    // Decrement the quantity of an item
    async decrementQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        await this.updateCartQuantity(item);
      }
    },

    // Update cart item quantity
    async updateCartQuantity(item) {
      try {
        await axios.put('http://localhost:5555/cart/update-quantity', {
          cartId: item.cart_id,
          quantity: item.quantity
        }, { withCredentials: true });
      } catch (error) {
        console.error('Error updating quantity:', error);
        alert('Failed to update quantity');
        // Refresh cart to get the correct state
        await this.fetchCartItems();
      }
    },

    // Remove an item from the cart
    async removeItem(cartId) {
      try {
        await axios.delete('http://localhost:5555/cart/remove', {
          data: { cartId },
          withCredentials: true
        });
        await this.fetchCartItems(); // Refresh the cart
      } catch (error) {
        console.error('Error removing item:', error);
        alert('Failed to remove item from cart');
      }
    },

    // Handle the checkout process
    checkout() {
      try {
        // Save cart items to localStorage
        localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
        
        // Navigate to checkout
        this.$router.push('/checkout');
      } catch (error) {
        console.error('Error proceeding to checkout:', error);
        alert('Failed to proceed to checkout. Please try again.');
      }
    }
  },

  // Fetch cart items when the component is created
  async created() {
    await this.fetchCartItems();
  }
};
</script>

<style scoped>
/* Base Styles */
.cart-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #EEF2FF 0%, #F8FAFC 100%);
  padding: 0 0 2rem 0;
  font-family: 'Poppins', sans-serif;
  color: #1A365D;
}

.announcement-bar {
  background: #4F46E5;
  color: white;
  text-align: center;
  padding: 0.75rem;
  font-size: 0.9rem;
  font-weight: 500;
}

.breadcrumb-nav {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1.5rem 5%;
  background: white;
  margin-bottom: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.breadcrumb-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.breadcrumb-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #4F46E5;
  text-decoration: none;
  padding: 0.5rem;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.breadcrumb-link:hover {
  background: #EEF2FF;
}

.breadcrumb-item.active {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #1A365D;
  padding: 0.5rem;
  border-radius: 8px;
  background: #EEF2FF;
}

.breadcrumb-separator {
  color: #94A3B8;
  display: flex;
  align-items: center;
}

.cart-container {
  display: flex;
  gap: 2rem;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 5%;
}

.cart {
  flex: 1.5;
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.cart-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1A365D;
  margin: 0;
}

.cart-items-count {
  color: #64748B;
  font-size: 0.9rem;
  margin: 0;
}

.cart-items-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.cart-item {
  display: flex;
  gap: 1.5rem;
  padding: 1.5rem;
  background: #F8FAFC;
  border-radius: 12px;
  position: relative;
}

.cart-item-image-container {
  width: 120px;
  height: 120px;
  flex-shrink: 0;
}

.cart-item-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.cart-item-details {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 1.1rem;
  font-weight: 500;
  margin: 0 0 0.5rem 0;
  color: #1A365D;
}

.item-price {
  font-size: 1.2rem;
  font-weight: 600;
  color: #4F46E5;
  margin: 0;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: white;
  padding: 0.25rem;
  border-radius: 8px;
  border: 1px solid #E2E8F0;
}

.quantity-btn {
  background: none;
  border: none;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #4F46E5;
  font-size: 1.2rem;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.quantity-btn:hover:not(:disabled) {
  background: #EEF2FF;
}

.quantity-btn:disabled {
  color: #CBD5E0;
  cursor: not-allowed;
}

.quantity-input {
  width: 40px;
  text-align: center;
  border: none;
  font-size: 0.9rem;
  font-weight: 500;
  color: #1A365D;
}

.quantity-input::-webkit-inner-spin-button,
.quantity-input::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.remove-button {
  background: none;
  border: none;
  color: #94A3B8;
  cursor: pointer;
  font-size: 1.5rem;
  padding: 0.5rem;
  border-radius: 50%;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-button:hover {
  background: #FEE2E2;
  color: #EF4444;
}

.empty-cart {
  text-align: center;
  padding: 4rem 2rem;
}

.empty-cart-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.empty-cart-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.shop-now-btn {
  display: inline-block;
  background: #4F46E5;
  color: white;
  padding: 0.75rem 2rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.2s ease;
}

.shop-now-btn:hover {
  background: #4338CA;
  transform: translateY(-1px);
}

.back-to-shop {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #4F46E5;
  text-decoration: none;
  margin-top: 2rem;
  font-weight: 500;
  transition: all 0.2s ease;
}

.back-to-shop:hover {
  color: #4338CA;
}

.summary {
  flex: 1;
  position: relative;
}

.summary-content {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 2rem;
}

.summary-title {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0 0 1.5rem 0;
  color: #1A365D;
}

.summary-items {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  color: #64748B;
  font-size: 0.9rem;
}

.shipping-section {
  margin: 1.5rem 0;
}

.shipping-label {
  display: block;
  font-weight: 600;
  color: #1A365D;
  margin-bottom: 0.75rem;
}

.shipping-select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #E2E8F0;
  border-radius: 8px;
  background: white;
  color: #1A365D;
  font-size: 0.95rem;
  cursor: pointer;
  transition: all 0.3s ease;
  outline: none;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%234F46E5' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 1rem center;
  background-size: 1em;
}

.shipping-select:hover {
  border-color: #4F46E5;
}

.shipping-select:focus {
  border-color: #4F46E5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.shipping-select option {
  padding: 0.5rem;
}

.summary-divider {
  height: 1px;
  background: #E2E8F0;
  margin: 1rem 0;
}

.summary-total {
  display: flex;
  justify-content: space-between;
  font-weight: 600;
  color: #1A365D;
  font-size: 1.1rem;
}

.total-amount {
  color: #4F46E5;
}

.checkout-button {
  width: 100%;
  background: #4F46E5;
  color: white;
  border: none;
  padding: 1rem;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  margin-top: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.2s ease;
}

.checkout-button:hover:not(.disabled) {
  background: #4338CA;
  transform: translateY(-1px);
}

.checkout-button.disabled {
  background: #CBD5E0;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .cart-container {
    flex-direction: column;
  }

  .cart-item {
    flex-direction: column;
  }

  .cart-item-image-container {
    width: 100%;
    height: 200px;
  }

  .cart-item-details {
    flex-direction: column;
    align-items: flex-start;
  }

  .quantity-controls {
    width: 100%;
    justify-content: center;
  }

  .remove-button {
    position: absolute;
    top: 1rem;
    right: 1rem;
  }

  .summary-content {
    position: static;
  }
}

@media (max-width: 480px) {
  .breadcrumb-item .text {
    display: none;
  }
  
  .breadcrumb-nav {
    justify-content: center;
  }

  .cart-container {
    padding: 0 1rem;
  }

  .cart, .summary-content {
    padding: 1rem;
  }

  .cart-item {
    padding: 1rem;
  }

  .cart-item-image-container {
    height: 150px;
  }
}
</style>
