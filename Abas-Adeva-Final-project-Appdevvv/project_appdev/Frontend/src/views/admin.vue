<template>
  <div class="d-flex">
    <!-- Sidebar -->
    <nav class="sidebar">
      <div class="sidebar-header">
        <i class="fas fa-graduation-cap fs-2 mb-2"></i>
        <h4>Margatheo Store</h4>
      </div>
      <ul class="nav nav-pills flex-column">
        <li class="nav-item">
          <router-link to="/admin/dashboard" class="nav-link" active-class="active">
            <i class="fas fa-home"></i>
            <span>Dashboard</span>
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/admin/products" class="nav-link" active-class="active">
            <i class="fas fa-box"></i>
            <span>Products</span>
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/admin/product-logs" class="nav-link" active-class="active">
            <i class="fas fa-clipboard-list"></i>
            <span>Product Logs</span>
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/admin/orders" class="nav-link" active-class="active">
            <i class="fas fa-truck"></i>
            <span>Orders</span>
          </router-link>
        </li>
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
      <div class="content-wrapper">
        <div class="welcome-section">
          <h1>Welcome to Admin Dashboard</h1>
          <p class="text-muted">Monitor your store's performance and manage inventory</p>
        </div>

        <!-- Charts Grid -->
        <div class="charts-grid">
          <!-- Stock Changes Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <div class="chart-title">
                <i class="fas fa-chart-line"></i>
                <h2>Stock Changes</h2>
              </div>
            </div>
            <div class="chart-body">
              <product-stock-chart />
            </div>
          </div>

          <!-- Stock Timeline Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <div class="chart-title">
                <i class="fas fa-history"></i>
                <h2>Stock Timeline</h2>
              </div>
            </div>
            <div class="chart-body">
              <stock-changes-chart />
            </div>
          </div>

          <!-- Sales Performance Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <div class="chart-title">
                <i class="fas fa-chart-bar"></i>
                <h2>Sales Performance</h2>
              </div>
            </div>
            <div class="chart-body">
              <sales-performance-chart />
            </div>
          </div>

          <!-- Top Selling Products Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <div class="chart-title">
                <i class="fas fa-crown"></i>
                <h2>Top Selling Products</h2>
              </div>
            </div>
            <div class="chart-body">
              <top-selling-products-chart />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import ProductStockChart from './ProductStockChart.vue';
import StockChangesChart from './StockChangesChart.vue';
import SalesPerformanceChart from './SalesPerformanceChart.vue';
import TopSellingProductsChart from './TopSellingProductsChart.vue';

export default {
  components: {
    ProductStockChart,
    StockChangesChart,
    SalesPerformanceChart,
    TopSellingProductsChart
  },
  methods: {
  async handleLogout() {
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
  }
}
};
</script>

<style scoped>
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
  box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
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
  color: white;
  border: none;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 2rem;
}

.logout-btn:hover {
  background: #dc3545;
  transform: translateY(-2px);
}

.main-content {
  margin-left: 280px;
  min-height: 100vh;
  background: #f8f9fa;
}

.content-wrapper {
  padding: 2rem;
  max-width: 1600px;
  margin: 0 auto;
}

.welcome-section {
  margin-bottom: 2rem;
}

.welcome-section h1 {
  font-size: 2rem;
  font-weight: 700;
  color: #2C3E50;
  margin-bottom: 0.5rem;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 32px;
  margin-top: 32px;
  padding: 0 24px;
}

.chart-card {
  background: #FFFFFF;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden;
  height: 500px;
  display: flex;
  flex-direction: column;
}

.chart-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.chart-header {
  padding: 24px 32px;
  border-bottom: 1px solid #F0F0F0;
}

.chart-title {
  display: flex;
  align-items: center;
  gap: 16px;
}

.chart-title i {
  font-size: 24px;
  color: #3498DB;
}

.chart-title h2 {
  font-size: 20px;
  font-weight: 600;
  color: #2C3E50;
  margin: 0;
}

.chart-body {
  padding: 32px;
  flex: 1;
  min-height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-body :deep(canvas) {
  width: 100% !important;
  height: 100% !important;
  max-height: 400px;
}

/* Responsive adjustments */
@media (max-width: 1200px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .chart-card {
    height: 450px;
  }
}

@media (max-width: 768px) {
  .charts-grid {
    padding: 0 16px;
    gap: 24px;
  }
  
  .chart-card {
    height: 400px;
  }
  
  .chart-header {
    padding: 20px 24px;
  }
  
  .chart-body {
    padding: 24px;
    min-height: 300px;
  }
}

@media (max-width: 992px) {
  .sidebar {
    width: 240px;
  }
  
  .main-content {
    margin-left: 240px;
  }
  
  .charts-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);
  }
  
  .main-content {
    margin-left: 0;
  }
}
</style>