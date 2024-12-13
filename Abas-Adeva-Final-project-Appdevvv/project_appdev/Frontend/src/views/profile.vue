<template>
  <div class="profile-container">
    <!-- Back Button -->
    <button class="back-btn" @click="goBack">
      <i class="fas fa-arrow-left"></i> Back
    </button>
    <div class="profile-wrapper">
      <!-- Profile Header -->
      <div class="profile-header">
        <div class="profile-avatar">
          <span class="avatar-text">{{ getInitials }}</span>
        </div>
        <h1>{{ user.fullname }}</h1>
        <p class="email">{{ user.email }}</p>
      </div>

      <!-- Navigation Tabs -->
      <div class="profile-tabs">
        <button 
          :class="['tab-btn', { active: activeTab === 'details' }]" 
          @click="activeTab = 'details'"
        >
          <i class="fas fa-user"></i> Profile Details
        </button>
        <button 
          :class="['tab-btn', { active: activeTab === 'orders' }]" 
          @click="activeTab = 'orders'"
        >
          <i class="fas fa-shopping-bag"></i> Order History
        </button>
      </div>

      <!-- Loading Spinner -->
      <div v-if="loading" class="loading-spinner">
        <div class="spinner"></div>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="error-message">
        {{ error }}
      </div>

      <!-- Profile Details Tab -->
      <div v-if="activeTab === 'details' && !loading" class="profile-details">
        <form @submit.prevent="updateDetails" class="profile-form">
          <div class="form-group">
            <label for="fullname">Full Name</label>
            <input 
              type="text" 
              id="fullname" 
              v-model="user.fullname" 
              required
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="email">Email Address</label>
            <input 
              type="email" 
              id="email" 
              v-model="user.email" 
              readonly
              class="form-input readonly"
            />
            <small class="input-hint">Email cannot be modified</small>
          </div>

          <div class="form-group">
            <label for="phone">Phone Number</label>
            <input 
              type="tel" 
              id="phone" 
              v-model="user.phone"
              class="form-input"
              placeholder="Enter your phone number"
            />
          </div>

          <div class="form-group">
            <label for="address">Delivery Address</label>
            <textarea 
              id="address" 
              v-model="user.address"
              class="form-input textarea"
              placeholder="Enter your delivery address"
              rows="3"
            ></textarea>
          </div>

          <button type="submit" class="save-btn">
            <i class="fas fa-save"></i> Save Changes
          </button>
        </form>
      </div>

      <!-- Orders Tab -->
      <div v-if="activeTab === 'orders'" class="orders-list">
        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
          <p>Loading your orders...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="error-state">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ error }}</p>
          <button @click="fetchOrders" class="retry-btn">
            Try Again
          </button>
        </div>

        <!-- Orders List -->
        <div v-else-if="orders && orders.length > 0">
          <div v-for="order in orders" :key="order.id" class="order-card">
            <div class="order-header">
              <h3>Order #{{ order.id }}</h3>
              <span :class="['order-status', order.status]">{{ order.status }}</span>
            </div>
            
            <div class="order-details">
              <p><strong>Date:</strong> {{ formatDate(order.created_at || order.date) }}</p>
              <p><strong>Total:</strong> ₱{{ formatPrice(order.total_price) }}</p>
              <p><strong>Payment Method:</strong> {{ formatPaymentMethod(order.payment_method) }}</p>
              <p><strong>Delivery Address:</strong> {{ order.address }}</p>
              <p><strong>Contact Number:</strong> {{ order.contact_number }}</p>
            </div>

            <div class="order-items">
              <h4>Items:</h4>
              <div class="items-grid">
                <div v-for="item in order.items" :key="item.id" class="item-card">
                  <div class="item-info">
                    <p class="item-name">{{ item.name }}</p>
                    <p class="item-quantity">Qty: {{ item.quantity }}</p>
                    <p class="item-price">₱{{ formatPrice(item.price * item.quantity) }}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="order-actions" v-if="order.status === 'pending'">
              <button 
                class="cancel-btn" 
                @click="cancelOrder(order.id)"
                :disabled="cancelling === order.id"
              >
                <i class="fas fa-times"></i>
                {{ cancelling === order.id ? 'Cancelling...' : 'Cancel Order' }}
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="no-orders">
          <i class="fas fa-shopping-cart"></i>
          <p>No orders yet</p>
          <button class="shop-now-btn" @click="goToShop">
            <i class="fas fa-shopping-bag"></i> Shop Now
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
      activeTab: "details",
      user: {
        fullname: "",
        email: "",
        phone: "",
        address: "",
      },
      orders: [],
      loading: false,
      error: null,
      cancelling: null
    };
  },

  computed: {
    getInitials() {
      return this.user.fullname
        .split(' ')
        .map(name => name.charAt(0))
        .join('')
        .toUpperCase();
    }
  },

  async mounted() {
    try {
      await this.fetchProfile();
      if (this.activeTab === 'orders') {
        await this.fetchOrders();
      }
    } catch (error) {
      console.error('Error in mounted:', error);
    }
  },

  watch: {
    activeTab(newTab) {
      if (newTab === 'orders') {
        this.fetchOrders();
      }
    }
  },

  methods: {
    goBack() {
      this.$router.push('/home');
    },

    async fetchProfile() {
      try {
        this.loading = true;
        const response = await axios.get('http://localhost:5555/profile', {
          withCredentials: true
        });

        if (response.data.success) {
          this.user = response.data.profile;
        } else {
          throw new Error(response.data.message || 'Failed to fetch profile');
        }
      } catch (error) {
        console.error('Error fetching profile:', error);
        if (error.response?.status === 401) {
          this.$router.push('/login');
        } else {
          this.error = error.response?.data?.message || error.message || 'Failed to load profile';
        }
      } finally {
        this.loading = false;
      }
    },

    async updateDetails() {
      try {
        this.loading = true;
        const response = await axios.put('http://localhost:5555/profile', {
          fullname: this.user.fullname,
          phone: this.user.phone,
          address: this.user.address
        }, {
          withCredentials: true
        });

        if (response.data.success) {
          this.showNotification('Profile updated successfully');
        } else {
          throw new Error(response.data.message || 'Failed to update profile');
        }
      } catch (error) {
        console.error('Error updating profile:', error);
        this.showNotification(
          error.response?.data?.message || error.message || 'Failed to update profile',
          'error'
        );
      } finally {
        this.loading = false;
      }
    },

    async fetchOrders() {
      try {
        this.loading = true;
        console.log('Fetching orders...');
        
        const response = await axios.get('http://localhost:5555/orders', {
          withCredentials: true
        });
        
        console.log('Orders response:', response.data);
        
        if (response.data.success) {
          this.orders = response.data.orders || [];
          console.log('Orders loaded:', this.orders);
        } else {
          throw new Error(response.data.message || 'Failed to fetch orders');
        }
      } catch (error) {
        console.error('Error fetching orders:', error);
        if (error.response?.status === 401) {
          this.$router.push('/login');
        } else {
          this.error = error.response?.data?.message || error.message || 'Failed to load orders';
        }
      } finally {
        this.loading = false;
      }
    },

    formatDate(date) {
      return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    },

    formatPrice(price) {
      return parseFloat(price).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    },

    formatPaymentMethod(method) {
      const methods = {
        'cod': 'Cash on Delivery',
        'check_payment': 'Check Payment'
      };
      return methods[method] || method;
    },

    showNotification(message, type = 'success') {
      alert(message);
    },

    async cancelOrder(orderId) {
      if (!confirm('Are you sure you want to cancel this order?')) {
        return;
      }

      this.cancelling = orderId;
      try {
        const response = await axios.post(`http://localhost:5555/orders/${orderId}/cancel`, {}, {
          withCredentials: true
        });

        if (response.data.success) {
          this.showNotification('Order cancelled successfully');
          await this.fetchOrders();
        } else {
          throw new Error(response.data.message || 'Failed to cancel order');
        }
      } catch (error) {
        console.error('Error cancelling order:', error);
        
        if (error.response?.status === 401) {
          this.showNotification('Please login to cancel your order', 'error');
          this.$router.push('/login');
          return;
        }
        
        const errorMessage = error.response?.data?.message || 
                           error.message || 
                           'Failed to cancel order. Please try again later.';
        
        this.showNotification(errorMessage, 'error');
        
        if (errorMessage.includes('Only pending orders')) {
          await this.fetchOrders();
        }
      } finally {
        this.cancelling = null;
      }
    },

    viewOrder(orderId) {
      console.log('Viewing order:', orderId);
    },

    goToShop() {
      this.$router.push('/shop');
    }
  }
};
</script>

<style scoped>
/* Modern E-commerce Styling */
.profile-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  padding: 2rem;
  position: relative;
}

.profile-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  background: white;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  padding: 2rem;
}

.profile-header {
  text-align: center;
  padding: 2rem 0;
  background: linear-gradient(90deg, #4F46E5, #7C3AED);
  margin: -2rem -2rem 2rem -2rem;
  border-radius: 20px 20px 0 0;
  color: white;
}

.profile-avatar {
  width: 120px;
  height: 120px;
  margin: 0 auto 1.5rem;
  border-radius: 50%;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  border: 4px solid rgba(255, 255, 255, 0.2);
}

.avatar-text {
  font-size: 2.5rem;
  color: #4F46E5;
  font-weight: 600;
}

.profile-header h1 {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  font-weight: 700;
}

.email {
  font-size: 1.1rem;
  opacity: 0.9;
}

.profile-tabs {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  border-bottom: 2px solid #edf2f7;
  padding-bottom: 1rem;
}

.tab-btn {
  padding: 0.75rem 1.5rem;
  border: none;
  background: transparent;
  color: #718096;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.tab-btn:hover {
  color: #4F46E5;
  background: rgba(79, 70, 229, 0.1);
}

.tab-btn.active {
  color: #4F46E5;
  background: rgba(79, 70, 229, 0.1);
}

.tab-btn i {
  font-size: 1.1rem;
}

.profile-form {
  max-width: 600px;
  margin: 0 auto;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  color: #4a5568;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 2px solid #edf2f7;
  border-radius: 10px;
  font-size: 1rem;
  transition: all 0.3s ease;
  color: #2d3748;
  background: #f8fafc;
}

.form-input:focus {
  border-color: #4F46E5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
  outline: none;
  background: white;
}

.form-input.readonly {
  background: #f1f5f9;
  cursor: not-allowed;
}

.input-hint {
  display: block;
  color: #718096;
  font-size: 0.875rem;
  margin-top: 0.5rem;
}

.save-btn {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin-top: 2rem;
}

.save-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
}

.orders-list {
  padding: 1rem;
}

.order-card {
  background: white;
  border-radius: 15px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  border: 1px solid #edf2f7;
  transition: all 0.3s ease;
}

.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #edf2f7;
}

.order-header h3 {
  color: #2d3748;
  font-weight: 600;
}

.order-status {
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: capitalize;
}

.order-status.pending {
  background: #fef3c7;
  color: #92400e;
}

.order-status.cancelled {
  background: #fee2e2;
  color: #991b1b;
}

.order-status.completed {
  background: #dcfce7;
  color: #166534;
}

.order-details {
  margin: 1rem 0;
  color: #4a5568;
}

.order-details p {
  margin: 0.5rem 0;
  display: flex;
  gap: 0.5rem;
}

.order-details strong {
  min-width: 120px;
  color: #2d3748;
}

.order-items {
  margin-top: 1.5rem;
}

.order-items h4 {
  color: #2d3748;
  margin-bottom: 1rem;
}

.items-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.item-card {
  background: #f8fafc;
  border-radius: 10px;
  padding: 1rem;
  transition: all 0.3s ease;
}

.item-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.item-name {
  font-weight: 600;
  color: #2d3748;
  margin-bottom: 0.5rem;
}

.item-quantity {
  color: #718096;
  font-size: 0.875rem;
}

.item-price {
  color: #4F46E5;
  font-weight: 500;
  margin-top: 0.5rem;
}

.order-actions {
  margin-top: 1.5rem;
  display: flex;
  justify-content: flex-end;
}

.cancel-btn {
  padding: 0.75rem 1.5rem;
  background: #ef4444;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.cancel-btn:hover:not(:disabled) {
  background: #dc2626;
  transform: translateY(-1px);
}

.cancel-btn:disabled {
  background: #fca5a5;
  cursor: not-allowed;
}

.no-orders {
  text-align: center;
  padding: 3rem;
  color: #718096;
}

.no-orders i {
  font-size: 3rem;
  margin-bottom: 1rem;
  color: #cbd5e1;
}

.shop-now-btn {
  margin-top: 1rem;
  padding: 0.75rem 2rem;
  background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.shop-now-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
}

.back-btn {
  position: absolute;
  top: 2rem;
  left: 2rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: white;
  color: #4F46E5;
  border: 2px solid #4F46E5;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(79, 70, 229, 0.1);
}

.back-btn:hover {
  background: #4F46E5;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(79, 70, 229, 0.2);
}

.loading-spinner {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 200px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e2e8f0;
  border-top: 4px solid #4F46E5;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-message {
  text-align: center;
  color: #ef4444;
  padding: 1rem;
  background: #fee2e2;
  border-radius: 8px;
  margin: 1rem 0;
}

.loading-state {
  text-align: center;
  padding: 3rem;
}

.loading-state .spinner {
  margin: 0 auto 1rem;
}

.error-state {
  text-align: center;
  padding: 3rem;
  color: #ef4444;
}

.error-state i {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.retry-btn {
  margin-top: 1rem;
  padding: 0.75rem 1.5rem;
  background: #4F46E5;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.retry-btn:hover {
  background: #4338ca;
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .profile-container {
    padding: 1rem;
  }

  .profile-wrapper {
    padding: 1rem;
  }

  .profile-header {
    margin: -1rem -1rem 1.5rem -1rem;
    padding: 1.5rem 1rem;
  }

  .profile-avatar {
    width: 100px;
    height: 100px;
  }

  .avatar-text {
    font-size: 2rem;
  }

  .profile-header h1 {
    font-size: 1.5rem;
  }

  .profile-tabs {
    padding: 0 0.5rem;
  }

  .tab-btn {
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
  }

  .back-btn {
    top: 1rem;
    left: 1rem;
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
  }

  .items-grid {
    grid-template-columns: 1fr;
  }

  .order-details strong {
    min-width: 100px;
  }
}
</style>