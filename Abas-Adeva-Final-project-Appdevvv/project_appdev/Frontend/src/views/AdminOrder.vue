<template>
  <div class="container-fluid">
    <div class="admin-order">
      <div class="page-header">
        <div class="header-content">
          <h1>Order Management</h1>
          <p class="text-muted">Monitor and manage your store's orders</p>
        </div>
      </div>

      <div class="dashboard-stats">
        <div class="stat-card to-pay">
          <div class="stat-icon">
            <i class="fas fa-wallet"></i>
          </div>
          <div class="stat-details">
            <div class="stat-value">{{ pendingOrders }}</div>
            <div class="stat-info">
              <h3>TO PAY</h3>
              <p>Pending Payment</p>
            </div>
          </div>
        </div>

        <div class="stat-card to-ship">
          <div class="stat-icon">
            <i class="fas fa-shipping-fast"></i>
          </div>
          <div class="stat-details">
            <div class="stat-value">{{ shippedOrders }}</div>
            <div class="stat-info">
              <h3>TO SHIP</h3>
              <p>Ready for Shipping</p>
            </div>
          </div>
        </div>

        <div class="stat-card to-deliver">
          <div class="stat-icon">
            <i class="fas fa-truck"></i>
          </div>
          <div class="stat-details">
            <div class="stat-value">{{ toDeliverOrders }}</div>
            <div class="stat-info">
              <h3>TO DELIVER</h3>
              <p>In Transit</p>
            </div>
          </div>
        </div>

        <div class="stat-card completed">
          <div class="stat-icon">
            <i class="fas fa-check-circle"></i>
          </div>
          <div class="stat-details">
            <div class="stat-value">{{ completedOrders }}</div>
            <div class="stat-info">
              <h3>COMPLETED</h3>
              <p>Successful Orders</p>
            </div>
          </div>
        </div>

        <div class="stat-card cancelled">
          <div class="stat-icon">
            <i class="fas fa-times-circle"></i>
          </div>
          <div class="stat-details">
            <div class="stat-value">{{ cancelledOrders }}</div>
            <div class="stat-info">
              <h3>CANCELLED</h3>
              <p>Cancelled Orders</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Sidebar -->
      <nav class="sidebar">
        <div class="sidebar-header">
          <i class="fas fa-graduation-cap fs-2 mb-2"></i>
          <h4>Margatheo Store</h4>
        </div>
        <ul class="nav nav-pills flex-column">
          <!-- Dashboard Link -->
          <li class="nav-item">
            <router-link to="/admin/dashboard" class="nav-link" active-class="active">
              <i class="fas fa-home"></i>
              <span>Dashboard</span>
            </router-link>
          </li>
          
          <!-- Products Link -->
          <li class="nav-item">
            <router-link to="/admin/products" class="nav-link" active-class="active">
              <i class="fas fa-box"></i>
              <span>Products</span>
            </router-link>
          </li>

          <!-- Product Logs Link -->
          <li class="nav-item">
            <router-link to="/admin/product-logs" class="nav-link" active-class="active">
              <i class="fas fa-clipboard-list"></i>
              <span>Product Logs</span>
            </router-link>
          </li>

          <!-- Orders Link -->
          <li class="nav-item">
            <router-link to="/admin/orders" class="nav-link" active-class="active">
              <i class="fas fa-truck"></i>
              <span>Orders</span>
            </router-link>
          </li>

          <!-- Logout Button -->
          <li class="nav-item mt-auto">
            <button @click="handleLogout" class="logout-btn">
              <i class="fas fa-sign-out-alt"></i>
              <span>Logout</span>
            </button>
          </li>
        </ul>
      </nav>

      <!-- Main Content -->
      <div class="main-content">
        <div class="orders-section">
          <div class="section-header">
            <h2>Recent Orders</h2>
            <div class="search-wrapper">
              <input 
                type="text" 
                placeholder="Search by ID, customer or contact..." 
                v-model="searchQuery"
                class="search-input"
              >
            </div>
          </div>
          
          <div class="orders-table-wrapper">
            <table class="orders-table">
              <thead>
                <tr>
                  <th>ORDER ID</th>
                  <th>CUSTOMER</th>
                  <th>CONTACT</th>
                  <th>TOTAL PRICE</th>
                  <th>STATUS</th>
                  <th>DATE</th>
                  <th class="text-center">ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order in filteredOrders" :key="order.id">
                  <td>
                    <span class="order-id">#{{ order.id }}</span>
                  </td>
                  <td>
                    <div class="customer-name">{{ order.fullname || 'Customer' }}</div>
                  </td>
                  <td>{{ order.contact_number }}</td>
                  <td>
                    <div class="price-tag">₱{{ parseFloat(order.total_price).toFixed(2) }}</div>
                  </td>
                  <td>
                    <span :class="['status-pill', `status-${order.status}`]">
                      {{ getStatusDisplay(order.status) }}
                    </span>
                  </td>
                  <td>
                    <span class="date-text">{{ formatDate(order.created_at) }}</span>
                  </td>
                  <td>
                    <div class="actions-cell">
                      <select 
                        v-model="order.status" 
                        @change="updateStatus(order.id, $event.target.value)"
                        class="status-select"
                        :disabled="order.status === 'complete' || order.status === 'cancelled'"
                      >
                        <option value="pending">To Pay</option>
                        <option value="ship">To Ship</option>
                        <option value="delivered">To Deliver</option>
                        <option value="complete">Complete</option>
                        <option value="cancelled">Cancelled</option>
                      </select>
                      <button 
                        @click="viewDetails(order)"
                        class="view-btn"
                      >
                        <i class="fas fa-eye"></i>
                      </button>
                      <!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
        <button type="button" class="btn-close" @click="closeModal" aria-label="Close"></button>
      </div>
      <div class="modal-body" v-if="selectedOrder">
        <div class="order-info">
          <div class="info-group">
            <h6>Order Information</h6>
            <p><strong>Order ID:</strong> #{{ selectedOrder.id }}</p>
            <p><strong>Date:</strong> {{ formatDate(selectedOrder.created_at) }}</p>
            <p><strong>Status:</strong> {{ getStatusDisplay(selectedOrder.status) }}</p>
            <p><strong>Total Amount:</strong> ₱{{ parseFloat(selectedOrder.total_price).toFixed(2) }}</p>
          </div>
          <div class="info-group">
            <h6>Customer Information</h6>
            <p><strong>Name:</strong> {{ selectedOrder.fullname }}</p>
            <p><strong>Contact:</strong> {{ selectedOrder.contact_number }}</p>
            <p><strong>Email:</strong> {{ selectedOrder.email }}</p>
            <p><strong>Address:</strong> {{ selectedOrder.address }}</p>
          </div>
        </div>
        <div class="order-items">
          <h6>Order Items</h6>
          <div class="table-responsive">
            <table class="table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Quantity</th>
                  <th>Price</th>
                  <th>Total</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in orderItems" :key="item.id">
                  <td>{{ item.name }}</td>
                  <td>{{ item.quantity }}</td>
                  <td>₱{{ parseFloat(item.price).toFixed(2) }}</td>
                  <td>₱{{ (item.quantity * item.price).toFixed(2) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" @click="closeModal">Close</button>
      </div>
    </div>
  </div>
</div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Modal } from 'bootstrap';
import axios from 'axios';
import { ref, onMounted, computed } from 'vue';

export default {
  name: 'AdminOrder',
  setup() {
    const orders = ref([]);
    const selectedOrder = ref(null);
    const orderItems = ref([]);
    let modal = null;

    const pendingOrders = ref(0);
    const shippedOrders = ref(0);
    const toDeliverOrders = ref(0);
    const completedOrders = ref(0);
    const cancelledOrders = ref(0);

    const searchQuery = ref('');

    const filteredOrders = computed(() => {
      return orders.value.filter(order => {
        return order.fullname.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
               order.contact_number.includes(searchQuery.value) ||
               order.id.toString().includes(searchQuery.value);
      });
    });

    onMounted(async () => {
      await fetchOrders();
      // Initialize modal after component is mounted
      const modalElement = document.getElementById('orderDetailsModal');
      if (modalElement) {
        modal = new Modal(modalElement);
      }
    });

    const viewDetails = async (order) => {
      selectedOrder.value = order;
      try {
        const response = await axios.get(`http://localhost:5555/admin/orders/${order.id}`, {
          withCredentials: true
        });
        
        if (response.data.success) {
          const orderDetails = response.data.orderDetails[0];
          orderItems.value = orderDetails.items || [];
          if (modal) {
            modal.show();
          }
        }
      } catch (error) {
        console.error('Error fetching order details:', error);
        if (error.response?.status === 401) {
          window.location.href = '/login';
        } else {
          alert('Failed to fetch order details');
        }
      }
    };

    const closeModal = () => {
      if (modal) {
        modal.hide();
      }
    };

    const fetchOrders = async () => {
      try {
        const response = await axios.get('http://localhost:5555/admin/orders', {
          withCredentials: true
        });

        if (response.data.success) {
          // Map the orders and ensure each has a currentStatus property
          orders.value = response.data.orders.map(order => ({
            ...order,
            currentStatus: order.status // Keep track of current status
          }));
          
          // Sort orders by date (newest first)
          orders.value.sort((a, b) => {
            return new Date(b.created_at) - new Date(a.created_at);
          });

          // Update status counters
          pendingOrders.value = orders.value.filter(order => order.status === 'pending').length;
          shippedOrders.value = orders.value.filter(order => order.status === 'ship').length;
          toDeliverOrders.value = orders.value.filter(order => order.status === 'delivered').length;
          completedOrders.value = orders.value.filter(order => order.status === 'complete').length;
          cancelledOrders.value = orders.value.filter(order => order.status === 'cancelled').length;
        } else {
          throw new Error('Failed to fetch orders');
        }
      } catch (error) {
        console.error('Error fetching orders:', error);
        alert('Error loading orders');
        if (error.response?.status === 401) {
          window.location.href = '/login';
        }
      }
    };

    const updateStatus = async (orderId, newStatus) => {
      try {
        const order = orders.value.find(o => o.id === orderId);
        if (!order) return;

        // Store the current status in case we need to revert
        const currentStatus = order.status;

        // First get the order details if we're completing the order
        if (newStatus === 'complete') {
          try {
            console.log('Completing order:', orderId);
            // Get order details including items
            const detailsResponse = await axios.get(
              `http://localhost:5555/admin/orders/${orderId}`,
              { withCredentials: true }
            );

            if (!detailsResponse.data.success) {
              throw new Error('Failed to get order details');
            }

            // Update the order status
            const response = await axios.put(
              `http://localhost:5555/admin/orders/${orderId}/status`,
              { status: newStatus },
              { withCredentials: true }
            );

            if (response.data.success) {
              order.status = newStatus;
              order.currentStatus = newStatus;
              console.log('Order completed successfully, dispatching update event...');
              // Dispatch event for sales chart and product logs update
              window.dispatchEvent(new Event('orderStatusUpdated'));
              alert('Order completed successfully. Product logs have been updated.');
              await fetchOrders(); // Refresh the orders list
            }
          } catch (error) {
            console.error('Error completing order:', error);
            alert(error.response?.data?.message || 'Failed to complete order');
            order.status = currentStatus;
          }
        } else {
          // For other status updates
          try {
            const response = await axios.put(
              `http://localhost:5555/admin/orders/${orderId}/status`,
              { status: newStatus },
              { withCredentials: true }
            );

            if (response.data.success) {
              order.status = newStatus;
              order.currentStatus = newStatus;
              // Dispatch event for sales chart update
              window.dispatchEvent(new Event('orderStatusUpdated'));
              alert('Order status updated successfully');
              await fetchOrders(); // Refresh the orders list
            }
          } catch (error) {
            console.error('Error updating status:', error);
            alert(error.response?.data?.message || 'Failed to update order status');
            order.status = currentStatus;
          }
        }
      } catch (error) {
        console.error('Error in updateStatus:', error);
        alert('An unexpected error occurred');
        const order = orders.value.find(o => o.id === orderId);
        if (order) {
          order.status = order.currentStatus || 'pending';
        }
      }
    };

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    };

    const getStatusDisplay = (status) => {
      const statusMap = {
        'pending': 'To Pay',
        'ship': 'To Ship',
        'delivered': 'To Deliver',
        'complete': 'Completed',
        'cancelled': 'Cancelled'
      };
      return statusMap[status] || status;
    };

    const getStatusBadgeClass = (status) => {
      const classMap = {
        'pending': 'badge bg-warning',
        'ship': 'badge bg-primary',
        'delivered': 'badge bg-info',
        'complete': 'badge bg-success',
        'cancelled': 'badge bg-danger'
      };
      return classMap[status] || 'badge bg-secondary';
    };

    const handleLogout = async () => {
      if (confirm('Are you sure you want to logout?')) {
        try {
          await axios.post('http://localhost:5555/logout', {}, {
            withCredentials: true
          });
          localStorage.clear();
          window.location.href = '/login';
        } catch (error) {
          console.error('Logout failed:', error);
        }
      }
    };

    return {
      orders,
      selectedOrder,
      orderItems,
      pendingOrders,
      shippedOrders,
      toDeliverOrders,
      completedOrders,
      cancelledOrders,
      searchQuery,
      filteredOrders,
      viewDetails,
      closeModal,
      formatDate,
      getStatusDisplay,
      updateStatus,
      handleLogout
    };
  }
};
</script>

<style scoped>
.container-fluid {
  padding-left: 280px; /* Adjust based on sidebar width */
  width: 100%;
  min-height: 100vh;
}

.admin-order {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem 3rem;
}

.page-header {
  text-align: left;
  margin-bottom: 2rem;
  padding: 1rem 0;
}

.dashboard-stats {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1.25rem;
  margin-bottom: 2.5rem;
}

.orders-section {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.sidebar {
  width: 280px;
  min-height: 100vh;
  background: linear-gradient(180deg, #2C3E50 0%, #3498DB 100%);
  color: white;
  padding: 2rem 1.5rem;
  position: fixed;
  left: 0;
  top: 0;
  z-index: 1000;
  box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.sidebar-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-header i {
  color: #FFC107;
  margin-bottom: 0.5rem;
}

.sidebar-header h4 {
  margin: 0;
  font-weight: 600;
  font-size: 1.25rem;
}

.nav-link {
  color: rgba(255, 255, 255, 0.8) !important;
  padding: 1rem 1.5rem;
  border-radius: 12px;
  margin-bottom: 0.5rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white !important;
  transform: translateX(5px);
}

.nav-link.active {
  background: rgba(255, 255, 255, 0.2);
  color: white !important;
  font-weight: 600;
}

.nav-link i {
  font-size: 1.25rem;
  width: 1.5rem;
  text-align: center;
}

.logout-btn {
  width: 100%;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 12px;
  color: white;
  display: flex;
  align-items: center;
  gap: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 2rem;
}

.logout-btn:hover {
  background: #E74C3C;
}

.logout-btn i {
  font-size: 1.25rem;
}

.orders-section {
  max-width: 1200px;
  margin: 0 auto;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #f1f5f9;
}

.section-header h2 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.search-wrapper {
  position: relative;
  width: 320px;
}

.search-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 0.875rem;
  color: #1e293b;
  transition: all 0.2s;
}

.search-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.orders-table-wrapper {
  overflow-x: auto;
  padding: 0.5rem;
}

.orders-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
}

.orders-table th {
  padding: 1rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: #64748b;
  text-align: left;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}

.orders-table td {
  padding: 1rem;
  vertical-align: middle;
  border-bottom: 1px solid #f1f5f9;
}

.orders-table tr:hover {
  background-color: #f8fafc;
}

.order-id {
  font-weight: 600;
  color: #1e293b;
}

.customer-name {
  font-weight: 500;
  color: #1e293b;
}

.price-tag {
  font-weight: 600;
  color: #059669;
}

.date-text {
  color: #64748b;
  font-size: 0.875rem;
}

.status-pill {
  display: inline-flex;
  align-items: center;
  padding: 0.375rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.status-pending {
  background-color: #fef3c7;
  color: #d97706;
}

.status-ship {
  background-color: #dbeafe;
  color: #2563eb;
}

.status-delivered {
  background-color: #e0f2fe;
  color: #0284c7;
}

.status-complete {
  background-color: #dcfce7;
  color: #16a34a;
}

.status-cancelled {
  background-color: #fee2e2;
  color: #dc2626;
}

.actions-cell {
  display: flex;
  gap: 0.5rem;
  justify-content: flex-start;
  align-items: center;
}

.status-select {
  padding: 0.5rem;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.875rem;
  color: #1e293b;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
}

.status-select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.status-select:disabled {
  background-color: #f1f5f9;
  cursor: not-allowed;
  opacity: 0.7;
}

.view-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border: none;
  border-radius: 6px;
  background-color: #3b82f6;
  color: white;
  cursor: pointer;
  transition: all 0.2s;
}

.view-btn:hover {
  background-color: #2563eb;
}

.view-btn i {
  font-size: 0.875rem;
}

/* Modal Styles */
.modal-body {
  padding: 1.5rem;
}

.order-info {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-bottom: 2rem;
}

.info-group {
  background: #f8fafc;
  padding: 1.5rem;
  border-radius: 8px;
}

.info-group h6 {
  color: #1e293b;
  font-weight: 600;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid #e2e8f0;
}

.info-group p {
  margin-bottom: 0.5rem;
  color: #64748b;
}

.info-group strong {
  color: #1e293b;
}

.order-items {
  margin-top: 1rem;
}

.order-items h6 {
  color: #1e293b;
  font-weight: 600;
  margin-bottom: 1rem;
}

.table {
  width: 100%;
  margin-bottom: 1rem;
  background-color: transparent;
}

.table th {
  font-weight: 600;
  color: #1e293b;
  background: #f8fafc;
  padding: 0.75rem;
}

.table td {
  padding: 0.75rem;
  vertical-align: middle;
  color: #64748b;
}

.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

@media (max-width: 1280px) {
  .container-fluid {
    padding-left: 260px;
  }
  
  .dashboard-stats {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .container-fluid {
    padding-left: 0;
  }
  
  .admin-order {
    padding: 1rem;
  }

  .dashboard-stats {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .dashboard-stats {
    grid-template-columns: 1fr;
  }
}
</style>
