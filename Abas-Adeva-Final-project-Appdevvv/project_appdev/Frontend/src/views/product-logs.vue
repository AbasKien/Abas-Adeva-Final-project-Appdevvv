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
          <h1>Product Logs</h1>
          <p class="text-muted">Track and monitor your inventory changes</p>
        </div>

        <!-- Products Table Card -->
        <div class="chart-card">
          <div class="chart-header">
            <div class="chart-title">
              <i class="fas fa-history"></i>
              <h2>Products List</h2>
            </div>
          </div>
          <div class="chart-body">
            <div class="table-container">
              <table id="productsTable" class="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Stock</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="product in products" :key="product.id">
                    <td>{{ product.id }}</td>
                    <td>{{ product.name }}</td>
                    <td>{{ product.stock }}</td>
                    <td>
                      <button class="btn-view-logs" @click="showLogs(product.id)">
                        <i class="fas fa-history"></i> View Logs
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Product Logs -->
    <div v-if="showModal" class="modal fade show" tabindex="-1" style="display: block;" aria-modal="true" role="dialog">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <div class="modal-title">
              <i class="fas fa-history"></i>
              <h5>Product History Logs</h5>
            </div>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <div class="action-buttons mb-3">
              <button class="action-btn primary" @click="printLogs">
                <i class="fas fa-print"></i> Print
              </button>
              <button class="action-btn success" @click="downloadCSV">
                <i class="fas fa-download"></i> Download CSV
              </button>
            </div>
            <!-- Print Header -->
            <div class="print-header d-none d-print-block mb-4">
              <div class="text-center">
                <h1 class="store-name">MARGATHEO STORE</h1>
                <p class="store-details">Your One-Stop School Supplies Destination</p>
                <p class="store-address">Masipit Calapan, City</p>
                <p class="store-contact">Contact: (09150232461) | Email: margatheostore@gmail.com</p>
                <div class="header-line"></div>
              </div>
            </div>
            <div class="table-container">
              <table id="logsTable" class="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Previous Quantity</th>
                    <th>Quantity Changed</th>
                    <th>New Quantity</th>
                    <th>Reason</th>
                    <th>Created At</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="log in selectedProductLogs" :key="log.log_id">
                    <td>{{ log.log_id }}</td>
                    <td>{{ log.previous_quantity }}</td>
                    <td>{{ log.quantity_changed }}</td>
                    <td>{{ log.new_quantity }}</td>
                    <td>{{ log.reason }}</td>
                    <td>{{ new Date(log.created_at).toLocaleString() }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showModal" class="modal-backdrop fade show"></div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue';
import axios from 'axios';

export default {
  setup() {
    const products = ref([]);
    const selectedProductLogs = ref([]);
    const showModal = ref(false);
    let currentProductId = ref(null);

    // Fetch products with logs from the server
    const fetchProducts = async () => {
      try {
        const response = await axios.get('http://localhost:5555/products-with-logs', { withCredentials: true });
        // Group products by ID to prevent duplication
        const productMap = new Map();
        response.data.products.forEach(product => {
          if (!productMap.has(product.id)) {
            productMap.set(product.id, {
              id: product.id,
              name: product.name,
              stock: product.stock
            });
          }
        });
        products.value = Array.from(productMap.values());
      } catch (error) {
        console.error('Error loading products', error);
      }
    };

    const refreshCurrentLogs = async () => {
      if (currentProductId.value && showModal.value) {
        await showLogs(currentProductId.value);
      }
    };

    const showLogs = async (productId) => {
      try {
        currentProductId.value = productId;
        // Destroy existing DataTable if it exists
        if ($.fn.DataTable.isDataTable('#logsTable')) {
          $('#logsTable').DataTable().destroy();
        }

        const response = await axios.get(`http://localhost:5555/product-logs/${productId}`, { withCredentials: true });
        selectedProductLogs.value = response.data.logs;
        showModal.value = true;
        
        // Initialize DataTables for the modal after a short delay to ensure DOM is updated
        setTimeout(() => {
          $('#logsTable').DataTable({
            responsive: true,
            order: [[5, 'desc']], // Sort by created_at column in descending order
            columns: [
              { data: 'log_id' },
              { data: 'previous_quantity' },
              { data: 'quantity_changed' },
              { data: 'new_quantity' },
              { data: 'reason' },
              { 
                data: 'created_at',
                render: function(data) {
                  const date = new Date(data);
                  const options = {
                    month: 'numeric',
                    day: 'numeric',
                    year: 'numeric',
                    hour: 'numeric',
                    minute: '2-digit',
                    hour12: true
                  };
                  return date.toLocaleString('en-US', options);
                }
              }
            ]
          });
        }, 100);
      } catch (error) {
        console.error('Error loading logs for product', error);
        alert('Error loading product logs');
      }
    };

    const closeModal = () => {
      showModal.value = false;
      selectedProductLogs.value = [];
      currentProductId.value = null;
    };

    // Event listener for order status updates
    const handleOrderStatusUpdate = () => {
      console.log('Order status updated, refreshing logs...');
      fetchProducts();
      refreshCurrentLogs();
    };

    onMounted(() => {
      fetchProducts();
      // Add event listener for order status updates
      window.addEventListener('orderStatusUpdated', handleOrderStatusUpdate);
      // Initialize DataTables for the main table
      setTimeout(() => {
        $('#productsTable').DataTable({
          responsive: true
        });
      }, 500);
    });

    onUnmounted(() => {
      // Remove event listener when component is unmounted
      window.removeEventListener('orderStatusUpdated', handleOrderStatusUpdate);
    });

    // Function to print logs
    const printLogs = () => {
      const printWindow = window.open('', '_blank');
      printWindow.document.write(`
        <html>
          <head>
            <title>Product Logs - Margatheo Store</title>
            <style>
              @media print {
                .print-header {
                  text-align: center;
                  margin-bottom: 30px;
                }
                .store-name {
                  font-size: 24px;
                  font-weight: bold;
                  margin-bottom: 8px;
                  color: #000;
                }
                .store-details {
                  font-size: 16px;
                  margin-bottom: 4px;
                }
                .store-address, .store-contact {
                  font-size: 14px;
                  margin-bottom: 4px;
                }
                .header-line {
                  height: 2px;
                  background: #000;
                  margin: 15px auto;
                  width: 80%;
                }
                table {
                  width: 100%;
                  border-collapse: collapse;
                  margin-top: 20px;
                }
                th, td {
                  border: 1px solid #000;
                  padding: 8px;
                  text-align: left;
                }
                th {
                  background-color: #f2f2f2;
                }
              }
            </style>
          </head>
          <body>
            <div class="print-header">
              <h1 class="store-name">MARGATHEO STORE</h1>
              <p class="store-details">Your One-Stop School Supplies Destination</p>
              <p class="store-address">Masipit Calapan, City</p>
              <p class="store-contact">Contact: (09150232461) | Email: margatheostore@gmail.com</p>
              <div class="header-line"></div>
            </div>
            ${document.querySelector('#logsTable').outerHTML}
          </body>
        </html>
      `);
      printWindow.document.close();
      printWindow.print();
    };

    // Function to download logs as CSV
    const downloadCSV = () => {
      if (selectedProductLogs.value.length === 0) {
        alert('No logs available to download.');
        return;
      }

      const headers = ['ID', 'Previous Quantity', 'Quantity Changed', 'New Quantity', 'Reason', 'Created At'];
      const rows = selectedProductLogs.value.map(log => {
        const date = new Date(log.created_at);
        // Format date in Excel-compatible format
        const formattedDate = date.toLocaleDateString('en-US', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: 'numeric',
          minute: '2-digit',
          hour12: true
        });

        return [
          log.log_id,
          log.previous_quantity,
          log.quantity_changed,
          log.new_quantity,
          log.reason,
          formattedDate
        ].join(',');
      });

      // Create CSV content with UTF-8 BOM
      const BOM = '\uFEFF';
      const csvContent = BOM + headers.join(',') + '\n' + rows.join('\n');

      // Create and download file
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', 'product_logs.csv');
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
    };

    return {
      products,
      selectedProductLogs,
      showLogs,
      closeModal,
      showModal,
      printLogs,
      downloadCSV
    };
  }
};
</script>

<style scoped>
/* Sidebar styles */
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

/* Main Content Styles */
.main-content {
  margin-left: 280px;
  padding: 2rem;
  min-height: 100vh;
  background: #F8FAFC;
}

.content-wrapper {
  padding: 2rem;
  width: 100%;
}

.chart-card {
  background: white;
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
  width: 100%;
}

.chart-header {
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.chart-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #1a202c;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.chart-body {
  padding: 0;
}

/* Table styles */
.table-container {
  width: 100%;
  overflow-x: auto;
}

.table {
  width: 100%;
  border-collapse: collapse;
  white-space: nowrap;
}

.table th {
  background: #f8fafc;
  padding: 0.75rem 1.5rem;
  font-weight: 600;
  color: #475569;
  text-align: left;
  border-bottom: 2px solid #e2e8f0;
}

.table td {
  padding: 0.75rem 1.5rem;
  color: #1e293b;
  border-bottom: 1px solid #e2e8f0;
}

/* Table header styles */
.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  background: #fff;
}

.entries-section {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.entries-section select {
  padding: 0.375rem 2rem 0.375rem 0.75rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.375rem;
  background-color: #fff;
  color: #1a202c;
}

.search-section {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.search-section input {
  padding: 0.375rem 0.75rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.375rem;
  width: 240px;
}

/* Action button styles */
.btn-view-logs {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background-color: #3b82f6;
  color: white;
  border-radius: 0.375rem;
  font-weight: 500;
  transition: background-color 0.2s;
}

.btn-view-logs:hover {
  background-color: #2563eb;
}

/* Column widths */
.table th:nth-child(1),
.table td:nth-child(1) {
  width: 10%;
}

.table th:nth-child(2),
.table td:nth-child(2) {
  width: 50%;
}

.table th:nth-child(3),
.table td:nth-child(3) {
  width: 20%;
}

.table th:nth-child(4),
.table td:nth-child(4) {
  width: 20%;
}

/* Hover effect */
.table tbody tr:hover {
  background-color: #f8fafc;
}

/* Modal styles */
.modal-dialog {
  max-width: 80%;
  margin: 1.75rem auto;
}

.modal-content {
  width: 100%;
}

.modal .table-container {
  margin: 0;
  width: 100%;
}

/* Make the modal table columns more proportional */
.modal .table th:nth-child(1), /* ID */
.modal .table td:nth-child(1) {
  width: 8%;
}

.modal .table th:nth-child(2), /* Previous Quantity */
.modal .table td:nth-child(2) {
  width: 15%;
}

.modal .table th:nth-child(3), /* Quantity Changed */
.modal .table td:nth-child(3) {
  width: 15%;
}

.modal .table th:nth-child(4), /* New Quantity */
.modal .table td:nth-child(4) {
  width: 15%;
}

.modal .table th:nth-child(5), /* Reason */
.modal .table td:nth-child(5) {
  width: 27%;
}

.modal .table th:nth-child(6), /* Created At */
.modal .table td:nth-child(6) {
  width: 20%;
}

/* Products table column widths */
#productsTable th:nth-child(1), /* ID */
#productsTable td:nth-child(1) {
  width: 10%;
}

#productsTable th:nth-child(2), /* Name */
#productsTable td:nth-child(2) {
  width: 40%;
}

#productsTable th:nth-child(3), /* Stock */
#productsTable td:nth-child(3) {
  width: 25%;
}

#productsTable th:nth-child(4), /* Actions */
#productsTable td:nth-child(4) {
  width: 25%;
}

/* Print Styles */
@media print {
  .sidebar, .btn-close, .action-buttons {
    display: none !important;
  }

  .main-content {
    margin-left: 0;
    padding: 0;
  }

  .modal {
    position: absolute;
    left: 0;
    top: 0;
    margin: 0;
    padding: 0;
  }

  .modal-content {
    box-shadow: none;
  }

  .print-header {
    margin-bottom: 2rem;
  }

  .store-name {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 0.5rem;
  }

  .store-details, .store-address, .store-contact {
    margin: 0.25rem 0;
  }

  .header-line {
    border-bottom: 2px solid #000;
    margin: 1rem 0;
  }
}
</style>
