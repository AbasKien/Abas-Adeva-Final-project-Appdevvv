<template>
  <div class="container my-5">
    <h1 class="text-center mb-4">Checkout</h1>
    <div class="row g-4">
      <!-- Left Column: Personal Information -->
      <div class="col-md-6">
        <div class="card shadow-sm border-0">
          <div class="card-header bg-primary text-white">
            <h3 class="mb-0">Personal Information</h3>
          </div>
          <div class="card-body">
            <form @submit.prevent="checkout" class="needs-validation" novalidate>
              <div class="mb-3">
                <label for="contact-number" class="form-label">Contact Number</label>
                <input
                  type="tel"
                  id="contact-number"
                  class="form-control"
                  v-model="form.contact_number"
                  required
                  placeholder="Enter your contact number"
                  @input="validateContactNumber"
                  maxlength="11"
                />
                <div class="invalid-feedback">Please enter a valid contact number.</div>
              </div>
              <div class="mb-3">
                <label for="address" class="form-label">Shipping Address</label>
                <textarea
                  id="address"
                  class="form-control"
                  v-model="form.address"
                  required
                  placeholder="Enter your shipping address"
                ></textarea>
                <div class="invalid-feedback">Please enter your address.</div>
              </div>
              <div class="mb-3">
                <label for="payment" class="form-label">Payment Method</label>
                <select v-model="form.payment" id="payment" class="form-select" required>
                  <option value="check_payment">Check Payment</option>
                  <option value="cod">Cash on Delivery (COD)</option>
                </select>
                <div class="invalid-feedback">Please select a payment method.</div>
              </div>
              <!-- Centered Back to Cart Button -->
              <div class="d-flex justify-content-center mt-3">
                <button type="button" class="btn btn-secondary w-100" @click="goToCart">Back to Cart</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Right Column: Order Summary -->
      <div class="col-md-6">
        <div class="card shadow-sm border-0">
          <div class="card-header bg-info text-white">
            <h3 class="mb-0">Order Summary</h3>
          </div>
          <div class="card-body">
            <ul class="list-group">
              <li class="list-group-item d-flex justify-content-between">
                <span>Total Items:</span>
                <span>{{ totalItems }}</span>
              </li>
              <li class="list-group-item d-flex justify-content-between">
                <span>Total Price:</span>
                <span>₱{{ totalPrice }}</span>
              </li>
              <li class="list-group-item d-flex justify-content-between">
                <span>Shipping:</span>
                <span>₱58.00</span>
              </li>
              <li class="list-group-item d-flex justify-content-between fw-bold">
                <span>Total Amount:</span>
                <span>₱{{ (parseFloat(totalPrice) + 58).toFixed(2) }}</span>
              </li>
            </ul>
            <div class="d-flex justify-content-center mt-3">
              <button type="submit" class="btn btn-success w-100 py-2">
                Place Order
              </button>
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
        payment: "",
      },
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
  },
  methods: {
    validateContactNumber() {
      this.form.contact_number = this.form.contact_number.replace(/[^0-9]/g, "");
    },
    async checkout() {
      try {
        const response = await axios.post("http://localhost:5555/orders", {
          contact_number: this.form.contact_number,
          address: this.form.address,
          payment: this.form.payment,
          total_price: (parseFloat(this.totalPrice) + 58).toFixed(2),
        });

        alert(response.data.message);
        this.$router.push("/thank-you");
      } catch (error) {
        console.error("Failed to checkout:", error);
        alert("There was an error placing your order. Please try again.");
      }
    },
    goToCart() {
      this.$router.push("/cart");
    }
  },
};
</script>

<style scoped>
.container {
  max-width: 1000px;
}

.card {
  border-radius: 15px;
}

.card-header {
  border-radius: 15px 15px 0 0;
  font-weight: 600;
}

.list-group-item {
  border: none;
  padding: 10px 15px;
}

.btn {
  border-radius: 10px;
  font-size: 1.1rem;
  transition: background-color 0.3s, transform 0.2s;
}

.btn:hover {
  background-color: #3e8e41;
  transform: scale(1.05);
}

.btn:active {
  background-color: #2b6f29;
  transform: scale(1);
}

.invalid-feedback {
  display: block;
}

@media (max-width: 768px) {
  .container {
    padding: 0 15px;
  }
}
</style>
