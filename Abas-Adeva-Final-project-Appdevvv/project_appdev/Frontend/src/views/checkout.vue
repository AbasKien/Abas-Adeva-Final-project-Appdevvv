<template>
  <div class="checkout-page">
    <div class="announcement-bar">
      <p>Checkout now!</p>
    </div>
    <div class="page-header">
      <h1>Checkout</h1>
      <div class="breadcrumb-nav">
        <div class="breadcrumb-item">
          <router-link to="/" class="breadcrumb-link">
            <span class="icon">🏠</span>
            <span class="text">Home</span>
          </router-link>
        </div>
        <div class="breadcrumb-separator">
          <span class="icon">➜</span>
        </div>
        <div class="breadcrumb-item">
          <router-link to="/cart" class="breadcrumb-link">
            <span class="icon">🛒</span>
            <span class="text">Cart</span>
          </router-link>
        </div>
        <div class="breadcrumb-separator">
          <span class="icon">➜</span>
        </div>
        <div class="breadcrumb-item active">
          <span class="icon">📦</span>
          <span class="text">Checkout</span>
        </div>
      </div>
    </div>
    <div class="checkout-container">
      <div class="checkout-grid">
        <!-- Left Column: Personal Information -->
        <div class="checkout-form">
          <div class="form-card">
            <div class="card-header">
              <span class="header-icon">👋</span>
              <h3>Personal Information</h3>
              <p class="subtitle">Please fill in your details for delivery</p>
            </div>
            <div class="card-body">
              <form @submit.prevent="checkout" class="needs-validation" novalidate>
                <div class="form-group">
                  <label for="contact-number">Contact Number</label>
                  <div class="input-wrapper">
                    <span class="input-icon">📱</span>
                    <input
                      type="tel"
                      id="contact-number"
                      v-model="form.contact_number"
                      required
                      placeholder="Enter your contact number"
                      @input="validateContactNumber"
                      maxlength="11"
                      pattern="[0-9]{11}"
                    />
                  </div>
                  <div class="invalid-feedback">Please enter a valid 11-digit contact number.</div>
                </div>

                <div class="form-group">
                  <label for="address">Shipping Address</label>
                  <div class="input-wrapper">
                    <span class="input-icon">📍</span>
                    <textarea
                      id="address"
                      v-model="form.address"
                      required
                      placeholder="Enter your complete shipping address"
                    ></textarea>
                  </div>
                  <div class="invalid-feedback">Please enter your address.</div>
                </div>

                <div class="form-group">
                  <label for="payment_method">Payment Method</label>
                  <div class="input-wrapper">
                    <span class="input-icon">💳</span>
                    <select v-model="form.payment_method" id="payment_method" disabled>
                      <option value="cod">Cash on Delivery</option>
                    </select>
                  </div>
                </div>
                <div v-if="errorMessage" class="error-message">
                  {{ errorMessage }}
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Right Column: Order Summary -->
        <div class="order-summary">
          <div class="summary-card">
            <div class="card-header">
              <span class="header-icon">📦</span>
              <h3>Order Summary</h3>
              <p class="subtitle">Review your order details</p>
            </div>
            <div class="card-body">
              <!-- Show cart items -->
              <div class="cart-items">
                <div v-for="item in cartItems" :key="item.id" class="cart-item">
                  <div class="item-details">
                    <div class="item-info">
                      <h4>{{ item.name }}</h4>
                      <p>Quantity: {{ item.quantity }}</p>
                      <p class="item-price">₱{{ (item.price * item.quantity).toFixed(2) }}</p>
                    </div>
                  </div>
                </div>
              </div>

              <div class="summary-list">
                <div class="summary-item">
                  <span>Total Items</span>
                  <span class="value">{{ totalItems }} items</span>
                </div>
                <div class="summary-item">
                  <span>Subtotal</span>
                  <span class="value">₱{{ totalPrice }}</span>
                </div>
                <div class="summary-item">
                  <span>Shipping Fee</span>
                  <span class="value">₱58.00</span>
                </div>
                <div class="summary-total">
                  <span>Total Amount</span>
                  <span class="value">₱{{ finalAmount }}</span>
                </div>
              </div>

              <div class="action-buttons">
                <button 
                  type="submit" 
                  class="btn-place-order" 
                  @click="checkout"
                  :disabled="isLoading || !form.contact_number || !form.address"
                >
                  <span class="icon">{{ isLoading ? '⏳' : '✨' }}</span>
                  {{ isLoading ? 'Processing...' : 'Place Order' }}
                </button>
                <button 
                  type="button" 
                  class="btn-back" 
                  @click="goToCart"
                  :disabled="isLoading"
                >
                  <span class="icon">🛒</span>
                  Back to Cart
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      form: {
        contact_number: "",
        address: "",
        payment_method: "cod",
      },
      isLoading: false,
      orderPlaced: false,
      errorMessage: "",
    };
  },
  computed: {
    totalItems() {
      const cart = JSON.parse(localStorage.getItem("cartItems")) || [];
      return cart.reduce((sum, item) => sum + item.quantity, 0);
    },
    totalPrice() {
      const cart = JSON.parse(localStorage.getItem("cartItems")) || [];
      return cart
        .reduce((total, item) => total + item.price * item.quantity, 0)
        .toFixed(2);
    },
    cartItems() {
      return JSON.parse(localStorage.getItem("cartItems")) || [];
    },
    finalAmount() {
      return (parseFloat(this.totalPrice) + 58).toFixed(2);
    }
  },
  methods: {
    validateContactNumber() {
      this.form.contact_number = this.form.contact_number.replace(/[^0-9]/g, "");
    },
    
    validateForm() {
      if (!this.form.contact_number || this.form.contact_number.length !== 11 || !/^\d+$/.test(this.form.contact_number)) {
        this.errorMessage = "Please enter a valid 11-digit contact number";
        return false;
      }

      if (!this.form.address || this.form.address.trim().length < 10) {
        this.errorMessage = "Please enter a complete shipping address (at least 10 characters)";
        return false;
      }

      if (!this.cartItems || this.cartItems.length === 0) {
        this.errorMessage = "Your cart is empty";
        this.$router.push('/cart');
        return false;
      }

      this.errorMessage = "";
      return true;
    },

    async checkout() {
      if (!this.validateForm()) {
        return;
      }

      this.isLoading = true;
      this.errorMessage = "";

      try {
        // Check authentication
        await axios.get("http://localhost:5555/profile", {
          withCredentials: true
        });

        // Format cart items
        const items = this.cartItems.map(item => ({
          product_id: parseInt(item.id || item.product_id),
          quantity: item.quantity,
          price: parseFloat(item.price)
        }));

        // Create order
        const orderData = {
          contact_number: this.form.contact_number,
          address: this.form.address,
          payment_method: this.form.payment_method,
          items: items,
          total_price: parseFloat(this.finalAmount)
        };

        const response = await axios.post(
          "http://localhost:5555/orders",
          orderData,
          { withCredentials: true }
        );

        if (response.data.success) {
          // Clear cart
          localStorage.removeItem("cartItems");
          
          // Show success message
          alert("Order placed successfully! Thank you for your purchase.");
          
          // Redirect to home page
          this.$router.push('/thank-you/:orderId');
        }
      } catch (error) {
        console.error("Checkout error:", error);
        if (error.response?.status === 401) {
          alert("Please log in to complete your purchase");
          this.$router.push('/login');
        } else {
          this.errorMessage = error.response?.data?.message || "An error occurred during checkout. Please try again.";
        }
      } finally {
        this.isLoading = false;
      }
    },

    goToCart() {
      this.$router.push('/cart');
    },

    async loadProfileData() {
      try {
        const response = await axios.get("http://localhost:5555/profile", {
          withCredentials: true,
        });
        if (response.data.success) {
          const profile = response.data.profile;
          // Set contact number from profile's phone field
          this.form.contact_number = profile.phone || "";
          this.form.address = profile.address || "";
        }
      } catch (error) {
        console.error("Error loading profile:", error);
        if (error.response?.status === 401) {
          this.$router.push('/login');
        }
      }
    }
  },
  created() {
    this.loadProfileData();
    
    // Redirect to cart if cart is empty
    if (!this.cartItems || this.cartItems.length === 0) {
      this.$router.push('/cart');
      return;
    }

    // Check authentication
    axios
      .get("http://localhost:5555/profile", {
        withCredentials: true
      })
      .catch(() => {
        this.$router.push('/login');
      });
  }
};
</script>

<style scoped>
.checkout-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #EEF2FF 0%, #F8FAFC 100%);
  font-family: 'Poppins', sans-serif;
}

.announcement-bar {
  background: linear-gradient(90deg, #4F46E5, #7C3AED);
  color: white;
  padding: 0.75rem;
  font-weight: 500;
}

.page-header {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem 5%;
}

.page-header h1 {
  font-size: 2rem;
  color: #1A365D;
  margin-bottom: 0.5rem;
}

.breadcrumb-nav {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 0;
  margin-bottom: 2rem;
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

.breadcrumb-item .icon {
  font-size: 1.25rem;
}

.breadcrumb-item .text {
  font-size: 0.9rem;
  font-weight: 500;
}

.checkout-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 5% 2rem;
}

.checkout-grid {
  display: grid;
  grid-template-columns: 1fr 380px;
  gap: 2rem;
}

.form-card,
.summary-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
  border-bottom: 1px solid #E2E8F0;
}

.header-icon {
  font-size: 1.5rem;
}

.card-header h3 {
  font-size: 1.25rem;
  color: #1A365D;
  margin: 0;
}

.subtitle {
  color: #4A5568;
  font-size: 0.9rem;
  margin: 0.25rem 0 0;
}

.card-body {
  padding: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group:last-child {
  margin-bottom: 0;
}

.form-group label {
  display: block;
  font-weight: 500;
  color: #2D3748;
  margin-bottom: 0.5rem;
}

.input-wrapper {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: #F7FAFC;
  border: 2px solid #E2E8F0;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  transition: all 0.3s ease;
}

.input-wrapper:focus-within {
  border-color: #4F46E5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.input-icon {
  font-size: 1.25rem;
  color: #4A5568;
}

.input-wrapper input,
.input-wrapper textarea,
.input-wrapper select {
  width: 100%;
  border: none;
  background: transparent;
  font-size: 1rem;
  color: #2D3748;
  font-family: inherit;
}

.input-wrapper input:focus,
.input-wrapper textarea:focus,
.input-wrapper select:focus {
  outline: none;
}

.input-wrapper input::placeholder,
.input-wrapper textarea::placeholder {
  color: #A0AEC0;
}

.payment-select select {
  cursor: not-allowed;
  opacity: 0.7;
}

.payment-note {
  font-size: 0.9rem;
  color: #4A5568;
  margin-top: 0.5rem;
}

.error-message {
  color: #E53E3E;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  padding: 0.5rem;
  background: #FEF2F2;
  border-radius: 8px;
  border: 1px solid #FCA5A5;
}

.cart-items {
  margin-bottom: 1.5rem;
  max-height: 300px;
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: #CBD5E0 #EDF2F7;
}

.cart-items::-webkit-scrollbar {
  width: 6px;
}

.cart-items::-webkit-scrollbar-track {
  background: #EDF2F7;
  border-radius: 3px;
}

.cart-items::-webkit-scrollbar-thumb {
  background: #CBD5E0;
  border-radius: 3px;
}

.cart-item {
  padding: 1rem;
  border: 1px solid #E2E8F0;
  border-radius: 12px;
  margin-bottom: 1rem;
}

.cart-item:last-child {
  margin-bottom: 0;
}

.item-info h4 {
  font-size: 1rem;
  color: #1A365D;
  margin: 0 0 0.5rem;
}

.item-meta {
  display: flex;
  justify-content: space-between;
  color: #4A5568;
  font-size: 0.9rem;
}

.item-price {
  font-weight: 600;
  color: #1A365D;
}

.summary-list {
  margin-bottom: 1.5rem;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  color: #4A5568;
  margin-bottom: 1rem;
}

.summary-divider {
  height: 1px;
  background: #E2E8F0;
  margin: 1rem 0;
}

.summary-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  padding-top: 1rem;
  border-top: 2px solid #E2E8F0;
}

.total-amount {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
}

.currency {
  color: #4A5568;
  font-size: 0.9rem;
}

.amount {
  color: #1A365D;
  font-size: 1.5rem;
}

.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 1.5rem;
}

.btn-place-order {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  width: 100%;
  background: #4F46E5;
  color: white;
  border: none;
  border-radius: 12px;
  padding: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-place-order:hover:not(:disabled) {
  background: #4338CA;
  transform: translateY(-2px);
}

.btn-place-order:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.btn-back {
  width: 100%;
  background: #EEF2FF;
  color: #4F46E5;
  border: none;
  border-radius: 12px;
  padding: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-back:hover:not(:disabled) {
  background: #E0E7FF;
  transform: translateY(-2px);
}

.secure-checkout {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin-top: 1rem;
  color: #4A5568;
  font-size: 0.9rem;
}

.secure-icon {
  font-size: 1rem;
}

@media (max-width: 1024px) {
  .checkout-grid {
    grid-template-columns: 1fr 340px;
  }
}

@media (max-width: 768px) {
  .checkout-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .page-header,
  .checkout-container {
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .card-header {
    padding: 1rem;
  }

  .card-body {
    padding: 1rem;
  }

  .header-icon {
    font-size: 1.25rem;
  }

  .card-header h3 {
    font-size: 1.1rem;
  }

  .breadcrumb-item .text {
    display: none;
  }
  
  .breadcrumb-nav {
    justify-content: center;
  }
}
</style>
