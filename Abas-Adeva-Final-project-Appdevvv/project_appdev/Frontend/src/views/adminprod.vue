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
          <h1>Product Management</h1>
          <p class="text-muted">Manage your store's inventory and products</p>
          
          <!-- Low Stock Alert Banner -->
          <div v-if="lowStockProducts.length > 0" class="alert-banner">
            <div class="alert-content">
              <i class="fas fa-exclamation-circle"></i>
              <div class="alert-text">
                <strong>Low Stock Alert!</strong>
                <p>{{ lowStockProducts.length }} product(s) are running low on stock</p>
              </div>
            </div>
            <button class="view-details-btn" @click="showLowStockDetails = true">
              View Details
            </button>
          </div>
        </div>

        <!-- Low Stock Details Modal -->
        <div v-if="showLowStockDetails" class="modal fade show" tabindex="-1" style="display: block;" aria-modal="true" role="dialog">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Low Stock Products</h5>
                <button type="button" class="btn-close" @click="showLowStockDetails = false"></button>
              </div>
              <div class="modal-body">
                <div class="low-stock-list">
                  <div v-for="product in lowStockProducts" :key="product.id" class="low-stock-item">
                    <img :src="baseUrl + product.image_url" :alt="product.name" class="product-thumbnail">
                    <div class="product-info">
                      <h6>{{ product.name }}</h6>
                      <span class="stock-count">Stock: {{ product.stock }}</span>
                    </div>
                    <button class="restock-btn" @click="openAddQuantityModal(product)">
                      <i class="fas fa-plus"></i> Restock
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-if="showLowStockDetails" class="modal-backdrop fade show"></div>

        <!-- Products Table Card -->
        <div class="table-card">
          <div class="table-header">
            <div class="header-title">
              <i class="fas fa-box"></i>
              <h2>Products List</h2>
            </div>
            <button class="btn-primary" @click="showAddProductModal = true">
              <i class="fas fa-plus"></i> Add Product
            </button>
          </div>
          
          <div class="table-responsive">
            <table ref="tableRef" class="table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Image</th>
                  <th>Name</th>
                  <th>Description</th>
                  <th>Price</th>
                  <th>Stock</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in products" :key="item.id">
                  <td>{{ item.id }}</td>
                  <td>
                    <img :src="baseUrl + item.image_url" alt="Product" class="product-image" />
                  </td>
                  <td>{{ item.name }}</td>
                  <td>{{ item.description }}</td>
                  <td>₱{{ item.price }}</td>
                  <td>
                    <div class="stock-status">
                      <span :class="['stock-badge', getStockStatusClass(item.stock)]">
                        {{ item.stock }}
                      </span>
                      <span v-if="item.stock < 10" class="stock-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        Low Stock
                      </span>
                    </div>
                  </td>
                  <td>
                    <div class="action-buttons">
                      <button class="btn-icon" @click="openEditProductModal(item)" title="Edit">
                        <i class="fas fa-edit"></i>
                      </button>
                      <button class="btn-icon" @click="openAddQuantityModal(item)" title="Add Stock">
                        <i class="fas fa-plus"></i>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Product Modal -->
    <div v-if="showAddProductModal" class="modal fade show" id="addProductModal" tabindex="-1" 
         aria-labelledby="addProductModalLabel" style="display: block;" aria-modal="true" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addProductModalLabel">Add New Product</h5>
            <button type="button" class="btn-close" @click="closeAddModal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="addProduct">
              <div class="mb-3">
                <label for="productName" class="form-label">Product Name</label>
                <input type="text" id="productName" class="form-control" v-model="newProduct.name" required>
              </div>
              <div class="mb-3">
                <label for="productDescription" class="form-label">Description</label>
                <input type="text" id="productDescription" class="form-control" v-model="newProduct.description" required>
              </div>
              <div class="mb-3">
                <label for="productPrice" class="form-label">Price</label>
                <input type="number" id="productPrice" class="form-control" v-model="newProduct.price" required>
              </div>
              <div class="mb-3">
                <div class="drop-zone" :class="{ active: dragActive }" 
                  @dragenter.prevent="handleDrag" @dragover.prevent="handleDrag" @dragleave.prevent="handleDrag" @drop.prevent="(e) => handleDrop(e, 'newProduct')">
                  <div class="drop-zone-content">
                    <i class="fas fa-cloud-upload-alt fa-3x mb-3"></i>
                    <p class="drop-text">Drag and drop your image here</p>
                    <span class="or-divider">or</span>
                    <input
                      type="file"
                      id="productImage"
                      accept="image/*"
                      class="d-none"
                      @change="(e) => handleFileChange(e, 'newProduct')"
                    />
                    <label for="productImage" class="browse-btn">Choose File</label>
                  </div>
                </div>
                <div v-if="newProduct.image_url" class="file-preview">
                  <div class="preview-container">
                    <img :src="previewUrl" alt="Preview" class="preview-image" />
                    <div class="preview-info">
                      <span class="filename">{{ newProduct.image_url.name }}</span>
                      <button class="remove-btn" @click="removeImage('newProduct')">
                        <i class="fas fa-times"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeAddModal">Close</button>
                <button type="submit" class="btn btn-primary">Add Product</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showAddProductModal" class="modal-backdrop fade show"></div>

    <!-- Edit Product Modal -->
    <div v-if="showEditProductModal" class="modal fade show" id="editProductModal" tabindex="-1" 
         aria-labelledby="editProductModalLabel" style="display: block;" aria-modal="true" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editProductModalLabel">Edit Product</h5>
            <button type="button" class="btn-close" @click="closeEditModal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="updateProduct">
              <div class="mb-3">
                <label for="editProductName" class="form-label">Product Name</label>
                <input type="text" id="editProductName" class="form-control" v-model="editProduct.name" required>
              </div>
              <div class="mb-3">
                <label for="editProductDescription" class="form-label">Description</label>
                <input type="text" id="editProductDescription" class="form-control" v-model="editProduct.description" required>
              </div>
              <div class="mb-3">
                <label for="editProductPrice" class="form-label">Price</label>
                <input type="number" id="editProductPrice" class="form-control" v-model="editProduct.price" required>
              </div>
              <div class="mb-3">
                <div class="drop-zone" :class="{ active: dragActive }" 
                  @dragenter.prevent="handleDrag" @dragover.prevent="handleDrag" @dragleave.prevent="handleDrag" @drop.prevent="(e) => handleDrop(e, 'editProduct')">
                  <div class="drop-zone-content">
                    <i class="fas fa-cloud-upload-alt fa-3x mb-3"></i>
                    <p class="drop-text">Drag and drop your image here</p>
                    <span class="or-divider">or</span>
                    <input
                      type="file"
                      id="editProductImage"
                      accept="image/*"
                      class="d-none"
                      @change="(e) => handleFileChange(e, 'editProduct')"
                    />
                    <label for="editProductImage" class="browse-btn">Choose File</label>
                  </div>
                </div>
                <div v-if="editProduct.image_url" class="file-preview">
                  <div class="preview-container">
                    <img :src="previewUrl" alt="Preview" class="preview-image" />
                    <div class="preview-info">
                      <span class="filename">{{ editProduct.image_url.name }}</span>
                      <button class="remove-btn" @click="removeImage('editProduct')">
                        <i class="fas fa-times"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeEditModal">Close</button>
                <button type="submit" class="btn btn-primary">Update Product</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showEditProductModal" class="modal-backdrop fade show"></div>

    <!-- Add Quantity Modal -->
    <div v-if="showAddQuantityModal" class="modal fade show" id="addQuantityModal" tabindex="-1" 
         aria-labelledby="addQuantityModalLabel" style="display: block;" aria-modal="true" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addQuantityModalLabel">Add Quantity</h5>
            <button type="button" class="btn-close" @click="closeAddQuantityModal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="addQuantity">
              <div class="mb-3">
                <label class="form-label">Product: {{ selectedProduct?.name }}</label>
              </div>
              <div class="mb-3">
                <label for="quantity" class="form-label">Quantity to Add</label>
                <input type="number" class="form-control" id="quantity" v-model="quantityToAdd" required min="1">
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeAddQuantityModal">Close</button>
                <button type="submit" class="btn btn-primary">Add Quantity</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showAddQuantityModal" class="modal-backdrop fade show"></div>

    <!-- Replace the existing snackbar div -->
<transition name="toast">
  <div v-if="snackbar.show" class="notification-toast" :class="snackbar.color">
    <div class="notification-content">
      <div class="icon-circle">
        <i class="fas" :class="snackbar.color === 'success' ? 'fa-check' : 'fa-times'"></i>
      </div>
      <span class="notification-message">{{ snackbar.message }}</span>
    </div>
  </div>
</transition>
  </div>
</template>

<script>
import '../assets/admin.css';
import axios from 'axios';
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';

export default {
  setup() {
    // State Variables
    const products = ref([]);
    const tableRef = ref(null);
    const baseUrl = 'http://localhost:5555';

    // Form states
    const newProduct = ref({ name: '', description: '', price: '', image_url: '' });
    const editProduct = ref({ id: 0, name: '', description: '', price: '', quantity: 0, image_url: '' });

    // Modal visibility states
    const showAddProductModal = ref(false);
    const showAddQuantityModal = ref(false);
    const showEditProductModal = ref(false);

    // Selected product and quantity to add
    const selectedProduct = ref(null);
    const quantityToAdd = ref(null);

    // Snackbar state for messages
    const snackbar = ref({ show: false, message: '', color: 'success' });

    // Drag and drop state
    const dragActive = ref(false);
    const previewUrl = ref('');

    // Low stock products
    const showLowStockDetails = ref(false);
    const lowStockProducts = computed(() => {
      return products.value.filter(product => product.stock < 10);
    });

    // Methods
    const fetchProducts = async () => {
      try {
        const response = await axios.get(`${baseUrl}/products`);
        products.value = Array.isArray(response.data.products) ? response.data.products : [];
      } catch (error) {
        console.error('Error fetching products:', error);
        products.value = [];
      }
    };

    const openEditProductModal = (item) => {
      editProduct.value = { ...item };
      showEditProductModal.value = true;
    };

    const updateProduct = async (event) => {
      event.preventDefault();
      console.log("Product to Update:", editProduct.value);

      if (!editProduct.value || !editProduct.value.id) {
        handleError("Product ID is missing. Cannot update the product.");
        return;
      }

      try {
        const formData = new FormData();
        if (editProduct.value.name) formData.append("name", editProduct.value.name);
        if (editProduct.value.description)
          formData.append("description", editProduct.value.description);
        if (editProduct.value.price) formData.append("price", editProduct.value.price);
        if (editProduct.value.image_url instanceof File)
          formData.append("image", editProduct.value.image_url);

        const response = await axios.put(
          `${baseUrl}/products/${editProduct.value.id}`,
          formData,
          {
            headers: { "Content-Type": "multipart/form-data" },
          }
        );

        if (response.status === 200 && response.data.success) {
          const successMessage = response.data.message || "Product updated successfully!";
          handleResponse(response, successMessage);
          showEditProductModal.value = false;
        } else {
          const errorMessage =
            response.data && response.data.message
              ? response.data.message
              : "Unexpected response from the server.";
          handleError(errorMessage);
        }
      } catch (error) {
        console.error("Error updating product:", error);
        const errorMessage =
          error.response && error.response.data && error.response.data.message
            ? error.response.data.message
            : "Failed to update product. Please try again.";
        handleError(errorMessage);
      }
    };

    const addProduct = async (event) => {
      event.preventDefault();
      console.log('Product to Add:', newProduct.value);

      // Get the authentication token
      const token = localStorage.getItem('token');
      if (!token) {
        handleError('Authentication required. Please log in again.');
        return;
      }

      const formData = new FormData();
      formData.append('name', newProduct.value.name);
      formData.append('description', newProduct.value.description);
      formData.append('price', newProduct.value.price);
      if (newProduct.value.image_url) {
        formData.append('image', newProduct.value.image_url);
      }

      try {
        const response = await axios.post(`${baseUrl}/add-product`, formData, {
          headers: { 
            'Content-Type': 'multipart/form-data',
            'Authorization': `Bearer ${token}`
          },
        });

        if (response.data.success) {
          handleResponse(response, `✨ Product "${newProduct.value.name}" added successfully!`);
          resetNewProductForm();
          resetFileInput();
          await fetchProducts();
          showAddProductModal.value = false;
        } else {
          throw new Error(response.data.message || 'Failed to add product');
        }
      } catch (error) {
        console.error('Error adding product:', error);
        const errorMessage =
          error.response?.data?.message || error.message || 'An error occurred while adding the product';
        handleError(errorMessage);
      }
    };

    const resetNewProductForm = () => {
      newProduct.value = { 
        name: '', 
        description: '', 
        price: '', 
        image_url: '' 
      };
    };

    const openAddQuantityModal = (item) => {
      selectedProduct.value = item;
      quantityToAdd.value = null;
      showAddQuantityModal.value = true;
    };

    const closeAddQuantityModal = () => {
      showAddQuantityModal.value = false;
      selectedProduct.value = null;
      quantityToAdd.value = null;
    };

    const addQuantity = async (event) => {
      if (event) event.preventDefault();
      if (!selectedProduct.value || quantityToAdd.value === null) return;

      try {
        const response = await axios.patch(`${baseUrl}/products/${selectedProduct.value.id}/quantity`, {
          quantity: quantityToAdd.value,
        });

        handleResponse(response, `✨ Successfully added ${quantityToAdd.value} units to ${selectedProduct.value.name}`);
        await fetchProducts();
        closeAddQuantityModal();
      } catch (error) {
        console.error('Error adding quantity:', error);
        const errorMessage = error.response?.data?.message || 'Error updating quantity';
        handleError(errorMessage);
      }
    };

    const handleDrag = (event) => {
      event.preventDefault();
      event.stopPropagation();
      if (event.type === "dragenter" || event.type === "dragover") {
        dragActive.value = true;
      } else if (event.type === "dragleave") {
        dragActive.value = false;
      }
    };

    const handleDrop = (event, productType) => {
      event.preventDefault();
      event.stopPropagation();
      dragActive.value = false;
      
      const file = event.dataTransfer.files[0];
      if (file && file.type.startsWith('image/')) {
        if (productType === 'newProduct') {
          newProduct.value.image_url = file;
          previewUrl.value = URL.createObjectURL(file);
        } else if (productType === 'editProduct') {
          editProduct.value.image_url = file;
          previewUrl.value = URL.createObjectURL(file);
        }
      }
    };

    const handleFileChange = (event, productType) => {
      const file = event.target.files[0];
      if (file && file.type.startsWith('image/')) {
        if (productType === 'newProduct') {
          newProduct.value.image_url = file;
          previewUrl.value = URL.createObjectURL(file);
        } else if (productType === 'editProduct') {
          editProduct.value.image_url = file;
          previewUrl.value = URL.createObjectURL(file);
        }
      }
    };

    const router = useRouter();

    const handleLogout = async () => {
      if (confirm('Are you sure you want to logout?')) 
      try {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        localStorage.removeItem('role');
        await axios.post(`${baseUrl}/logout`);
        router.push('/login');
      } catch (error) {
        console.error('Logout error:', error);
        // Still redirect to login even if the server request fails
        router.push('/login');
      }
    };

    const handleResponse = (response, message) => {
      snackbar.value = {
        show: true,
        message: message || 'Operation completed successfully! ✨',
        color: 'success'
      };
      
      setTimeout(() => {
        snackbar.value.show = false;
      }, 3000);
    };

    const handleError = (message) => {
      snackbar.value = {
        show: true,
        message: message || 'An error occurred. Please try again.',
        color: 'error'
      };
      
      setTimeout(() => {
        snackbar.value.show = false;
      }, 3000);
    };

    const createFormData = (productData) => {
      const formData = new FormData();
      Object.keys(productData).forEach(key => {
        if (key === 'image_url' && productData[key] instanceof File) {
          formData.append('image', productData[key]);
        } else {
          formData.append(key, productData[key]);
        }
      });
      return formData;
    };

    const resetFileInput = () => {
      const fileInput = document.getElementById('productImage');
      if (fileInput) {
        fileInput.value = ''; // Clear the file input value
      }
    };

    const loadDataTables = () => {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css';
      document.head.appendChild(link);

      const scriptJQuery = document.createElement('script');
      scriptJQuery.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
      scriptJQuery.onload = () => initDataTable();
      document.head.appendChild(scriptJQuery);
    };

    const initDataTable = () => {
      const scriptDataTable = document.createElement('script');
      scriptDataTable.src = 'https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js';
      scriptDataTable.onload = () => {
        if (tableRef.value) {
          $(tableRef.value).DataTable();
        }
      };
      document.head.appendChild(scriptDataTable);
    };

    const closeAddModal = () => {
      showAddProductModal.value = false;
    };

    const closeEditModal = () => {
      showEditProductModal.value = false;
    };

    const removeImage = (productType) => {
      if (productType === 'newProduct') {
        newProduct.value.image_url = '';
        previewUrl.value = '';
      } else if (productType === 'editProduct') {
        editProduct.value.image_url = '';
        previewUrl.value = '';
      }
    };

    const getStockStatusClass = (stock) => {
      if (stock === 0) return 'out-of-stock';
      if (stock < 10) return 'low-stock';
      return 'in-stock';
    };

    onMounted(() => {
      fetchProducts();
      loadDataTables();
    });

    return {
      products, tableRef, baseUrl, newProduct, showAddProductModal, showAddQuantityModal,
      selectedProduct, quantityToAdd, snackbar, showEditProductModal, editProduct,
      openEditProductModal, updateProduct, addProduct, openAddQuantityModal, addQuantity, 
      handleFileChange, handleLogout, closeAddModal, closeAddQuantityModal, closeEditModal,
      dragActive, handleDrag, handleDrop, previewUrl, removeImage, getStockStatusClass,
      showLowStockDetails, lowStockProducts
    };

  }
};
</script>

<style scoped>
.notification-toast {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  min-width: 320px;
  max-width: 450px;
  background: linear-gradient(to right, #ffffff, #f8f9fa);
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  z-index: 1050;
  padding: 16px 20px;
  backdrop-filter: blur(10px);
  animation: toastSlideDown 0.4s ease forwards;
}

.notification-toast.success {
  background: linear-gradient(135deg, #f0fff4, #dcfce7);
  border: 1px solid #86efac;
}

.notification-toast.error {
  background: linear-gradient(135deg, #fff1f2, #fee2e2);
  border: 1px solid #fca5a5;
}

.notification-content {
  display: flex;
  align-items: center;
  gap: 14px;
}

.icon-circle {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 1.1rem;
}

.success .icon-circle {
  background: #22c55e;
  color: white;
  box-shadow: 0 2px 8px rgba(34, 197, 94, 0.2);
}

.error .icon-circle {
  background: #ef4444;
  color: white;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.2);
}

.notification-message {
  color: #374151;
  font-size: 15px;
  font-weight: 500;
  line-height: 1.4;
}

.success .notification-message {
  color: #166534;
}

.error .notification-message {
  color: #991b1b;
}

@keyframes toastSlideDown {
  0% {
    transform: translateX(-50%) translateY(-100%);
    opacity: 0;
  }
  100% {
    transform: translateX(-50%) translateY(0);
    opacity: 1;
  }
}

.toast-enter-active {
  animation: toastSlideDown 0.4s ease forwards;
}

.toast-leave-active {
  animation: toastSlideDown 0.4s ease forwards reverse;
}
/* Base Layout */
.d-flex {
  display: flex;
}

.sidebar {
  width: 280px;
  min-height: 100vh;
  background: linear-gradient(180deg, #2C3E50 0%, #3498DB 100%);
  padding: 2rem 1.5rem;
  position: fixed;
  left: 0;
  top: 0;
  z-index: 1000;
}

.sidebar-header {
  text-align: center;
  color: white;
  margin-bottom: 2rem;
}

.sidebar-header i {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.nav-pills {
  list-style: none;
  padding: 0;
  margin: 0;
}

.nav-link {
  display: flex;
  align-items: center;
  color: rgba(255, 255, 255, 0.8);
  padding: 0.8rem 1rem;
  border-radius: 8px;
  margin-bottom: 0.5rem;
  transition: all 0.3s ease;
  text-decoration: none;
}

.nav-link i {
  margin-right: 12px;
  width: 20px;
  text-align: center;
}

.nav-link:hover, .nav-link.active {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.logout-btn {
  width: 100%;
  padding: 0.8rem;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.main-content {
  margin-left: 280px;
  padding: 2rem;
  width: calc(100% - 280px);
  min-height: 100vh;
  background: #F8F9FA;
}

.welcome-section {
  margin-bottom: 2rem;
}

.welcome-section h1 {
  font-size: 2rem;
  color: #2C3E50;
  margin-bottom: 0.5rem;
}

/* Table Card Styling */
.table-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #F0F0F0;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-title i {
  font-size: 24px;
  color: #3498DB;
}

.header-title h2 {
  font-size: 20px;
  font-weight: 600;
  color: #2C3E50;
  margin: 0;
}

.table-responsive {
  padding: 1.5rem;
  overflow-x: auto;
}

/* DataTable Styling */
.table {
  width: 100%;
  border-collapse: collapse;
}

.table th {
  background: #F8F9FA;
  color: #2C3E50;
  font-weight: 600;
  padding: 1rem;
  text-align: left;
  border-bottom: 2px solid #E9ECEF;
}

.table td {
  padding: 1rem;
  border-bottom: 1px solid #E9ECEF;
  vertical-align: middle;
}

.product-image {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 8px;
}

.stock-status {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.stock-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
  padding: 0.35rem 0.75rem;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.9rem;
}

.stock-badge.in-stock {
  background: #DEF7EC;
  color: #046C4E;
}

.stock-badge.low-stock {
  background: #FDF6B2;
  color: #723B13;
}

.stock-badge.out-of-stock {
  background: #FDE8E8;
  color: #9B1C1C;
}

.stock-warning {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.35rem 0.75rem;
  background: #FFFBEB;
  border: 1px solid #FCD34D;
  border-radius: 6px;
  color: #92400E;
  font-size: 0.85rem;
  font-weight: 500;
}

.stock-warning i {
  color: #F59E0B;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.btn-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: none;
  background: #F8F9FA;
  color: #2C3E50;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-icon:hover {
  background: #E9ECEF;
}

.btn-primary {
  background: #3498DB;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background: #2980B9;
}

.drop-zone {
  padding: 20px;
  border: 2px dashed #ccc;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.drop-zone.active {
  border-color: #3498DB;
  background: rgba(52, 152, 219, 0.1);
}

.drop-zone-content {
  text-align: center;
}

.drop-text {
  font-size: 16px;
  color: #666;
  margin-bottom: 10px;
}

.or-divider {
  display: block;
  margin: 10px 0;
  text-align: center;
  font-size: 14px;
  color: #ccc;
}

.browse-btn {
  background: #3498DB;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
}

.browse-btn:hover {
  background: #2980B9;
}

.file-preview {
  margin-top: 20px;
}

.preview-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.preview-image {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 8px;
}

.preview-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filename {
  font-size: 14px;
  color: #666;
}

.remove-btn {
  background: #FFEBEE;
  color: #C62828;
  border: none;
  padding: 0.25rem 0.5rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
}

.remove-btn:hover {
  background: #FFC0CB;
}

.alert-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #FEF3C7;
  border: 1px solid #F59E0B;
  border-radius: 8px;
  padding: 1rem 1.5rem;
  margin: 1.5rem 0;
}

.alert-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.alert-content i {
  font-size: 1.5rem;
  color: #D97706;
}

.alert-text {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.alert-text strong {
  color: #92400E;
  font-size: 1rem;
}

.alert-text p {
  color: #92400E;
  margin: 0;
  font-size: 0.9rem;
}

.view-details-btn {
  background: #D97706;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.view-details-btn:hover {
  background: #B45309;
}

.low-stock-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.low-stock-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: #F9FAFB;
  border-radius: 8px;
}

.product-thumbnail {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 6px;
}

.product-info {
  flex: 1;
}

.product-info h6 {
  margin: 0;
  color: #1F2937;
  font-size: 0.95rem;
}

.stock-count {
  font-size: 0.85rem;
  color: #EF4444;
  font-weight: 500;
}

.restock-btn {
  background: #3498DB;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.restock-btn:hover {
  background: #2980B9;
}

/* Responsive Design */
@media (max-width: 992px) {
  .sidebar {
    width: 240px;
  }
  
  .main-content {
    margin-left: 240px;
    width: calc(100% - 240px);
  }
}

@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);
  }
  
  .main-content {
    margin-left: 0;
    width: 100%;
  }
  
  .table-header {
    flex-direction: column;
    gap: 1rem;
  }
  
  .btn-primary {
    width: 100%;
    justify-content: center;
  }
}
</style>
