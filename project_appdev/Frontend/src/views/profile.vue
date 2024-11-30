<template>
    <div class="profile-page">
      <div class="profile-container">
        <!-- Sidebar -->
        <aside class="profile-sidebar">
          <ul class="profile-menu">
            <li :class="{ active: activeTab === 'details' }" @click="activeTab = 'details'">
              <span>👤</span> My Details
            </li>
            <li :class="{ active: activeTab === 'orders' }" @click="activeTab = 'orders'">
              <span>📦</span> My Orders
            </li>
            <!-- Back to Homepage Button -->
            <li @click="goHome" class="home-button">
              <span>🏠</span> Home
            </li>
          </ul>
        </aside>
  
        <!-- Main Content -->
        <main class="profile-content">
          <!-- My Details Tab -->
          <section v-if="activeTab === 'details'" class="details-tab">
            <h2>My Details</h2>
            <form @submit.prevent="updateDetails">
              <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" v-model="user.name" required />
              </div>
              <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" v-model="user.email" required />
              </div>
              <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" v-model="user.phone" />
              </div>
              <div class="form-group">
                <label for="address">Address</label>
                <textarea id="address" v-model="user.address"></textarea>
              </div>
              <button type="submit" class="save-button">Save Changes</button>
            </form>
          </section>
  
          <!-- My Orders Tab -->
          <section v-if="activeTab === 'orders'" class="orders-tab">
            <h2>My Orders</h2>
            <div v-if="orders.length > 0">
              <div v-for="order in orders" :key="order.id" class="order-item">
                <p><strong>Order ID:</strong> {{ order.id }}</p>
                <p><strong>Date:</strong> {{ order.date }}</p>
                <p><strong>Total:</strong> ₱{{ order.total.toFixed(2) }}</p>
                <button @click="viewOrder(order.id)">View Details</button>
              </div>
            </div>
            <p v-else>No orders found.</p>
          </section>
        </main>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        activeTab: "details", // Default active tab
        user: {
          name: "",
          email: "",
          phone: "",
          address: "",
        },
        orders: [
          {
            id: "ORD12345",
            date: "2024-11-20",
            total: 149.99,
          },
          {
            id: "ORD67890",
            date: "2024-10-15",
            total: 89.99,
          },
        ],
      };
    },
    mounted() {
  const userData = JSON.parse(localStorage.getItem("user"));
  if (userData) {
    this.user = userData; // Load fullname and email
  } else {
    this.$router.push("/home"); // Redirect if not logged in
  }
},

    methods: {
      updateDetails() {
        // Simulate API call to save updated user details
        alert("Your details have been updated!");
  
        // Save updated details back to localStorage
        localStorage.setItem("user", JSON.stringify(this.user));
      },
      viewOrder(orderId) {
        alert(`Viewing details for order ID: ${orderId}`);
        // Optionally, redirect to order details page or open modal
      },
      goHome() {
        this.$router.push("/home"); // Navigate to the homepage
      },
    },
  };
  </script>
  
  <style scoped>
  /* General Page Styling */
  .profile-page {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 30px;
    background: linear-gradient(to bottom, #f9f9f9, #e0e0e0);
    font-family: 'Roboto', sans-serif;
  }
  
  .profile-container {
    display: flex;
    width: 90%;
    max-width: 1200px;
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    overflow: hidden;
  }
  
  /* Sidebar */
  .profile-sidebar {
    flex: 1;
    background-color: #f4f4f4;
    padding: 20px;
    border-right: 1px solid #ddd;
  }
  
  .profile-menu {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  
  .profile-menu li {
    padding: 15px 20px;
    margin-bottom: 10px;
    cursor: pointer;
    font-size: 1rem;
    color: #555;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 10px;
    transition: all 0.3s ease;
  }
  
  .profile-menu li:hover,
  .profile-menu li.active {
    background-color: #1e88e5;
    color: #fff;
  }
  
  .home-button {
    background-color: transparent;
  }
  
  .home-button:hover {
    background-color: #1e88e5;
    color: #fff;
  }
  
  /* Main Content */
  .profile-content {
    flex: 3;
    padding: 30px;
  }
  
  h2 {
    font-size: 1.8rem;
    margin-bottom: 20px;
    color: #333;
  }
  
  /* Responsive Design */
  @media (max-width: 768px) {
    .profile-container {
      flex-direction: column;
    }
  
    .profile-sidebar {
      border-right: none;
      border-bottom: 1px solid #ddd;
    }
  
    .profile-menu li {
      text-align: center;
    }
  
    .profile-content {
      padding: 20px;
    }
  }
  </style>
  