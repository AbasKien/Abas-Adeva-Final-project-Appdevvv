<template>
  <div class="cart-page">
    <div class="cart-container">
      <!-- Shopping Cart Section -->
      <div class="cart">
        <h2 class="cart-title">Shopping Cart</h2>
        <p class="cart-items-count">{{ totalItems }} items</p>

        <div v-if="cartItems.length > 0" class="cart-items-list">
          <!-- Loop through cart items -->
          <div v-for="item in cartItems" :key="item.id" class="cart-item">
            <img :src="item.image" alt="Item image" class="cart-item-image" />
            <div class="cart-item-details">
              <h3 class="item-name">{{ item.name }}</h3>
              <p class="item-price">₱{{ (Number(item.price) || 0).toFixed(2) }}</p>
              <div class="quantity-controls">
                <button @click="decrementQuantity(item)">-</button>
                <input
                  type="number"
                  v-model.number="item.quantity"
                  min="1"
                  class="quantity-input"
                  @change="updateLocalCart"
                />
                <button @click="incrementQuantity(item)">+</button>
              </div>
            </div>
            <button @click="removeItem(item.id)" class="remove-button">✕</button>
          </div>
        </div>

        <div v-else class="empty-cart">
          <p>Your cart is empty. Start shopping now!</p>
        </div>

        <a href="/product" class="back-to-shop">← Back to shop</a>
      </div>

      <!-- Summary Section -->
      <div class="summary">
        <h2 class="summary-title">Summary</h2>
        <div class="summary-item">
          <span>ITEMS {{ totalItems }}</span>
          <span>₱{{ totalCost.toFixed(2) }}</span>
        </div>
        <div class="summary-item">
          <label for="shipping">SHIPPING</label>
          <select id="shipping" class="shipping-select">
            <option value="58">Standard Delivery - ₱58.00</option>
          </select>
        </div>
        <div class="summary-item">
          <label for="give-code">Voucher</label> <br>
          <div class="give-code-container">
            <input type="text" id="give-code" placeholder="Enter your code" />
            <button>→</button>
          </div>
        </div>
        <div class="summary-total">
          <span>TOTAL PRICE</span>
          <span>₱{{ (totalCost + 58).toFixed(2) }}</span>
        </div>
        <button @click="checkout" class="checkout-button">CHECKOUT</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      cartItems: [], // Initialize an empty array for cart items
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
    // Initialize the cart from localStorage when the component is created
    loadCartFromLocalStorage() {
      const savedCart = localStorage.getItem('cartItems');
      if (savedCart) {
        this.cartItems = JSON.parse(savedCart);
      }
    },

    // Save the cart to localStorage
    saveCartToLocalStorage() {
      localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
    },

    // Increment the quantity of an item
    incrementQuantity(item) {
      item.quantity++;
      this.saveCartToLocalStorage(); // Update the cart in local storage
    },

    // Decrement the quantity of an item
    decrementQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        this.saveCartToLocalStorage(); // Update the cart in local storage
      }
    },

    // Remove an item from the cart
    removeItem(itemId) {
      this.cartItems = this.cartItems.filter((item) => item.id !== itemId);
      this.saveCartToLocalStorage(); // Sync the updated cart with local storage
    },

    // Handle changes to the quantity input
    updateLocalCart() {
      this.saveCartToLocalStorage(); // Update the cart in local storage whenever quantity changes
    },

    // Handle the checkout process
    checkout() {
      this.$router.push('/checkout'); // Navigate to the /checkout page
    },
  },

  // Load the cart items when the component is created
  created() {
    this.loadCartFromLocalStorage();
  },
};
</script>


<style scoped>
.cart-page {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 30px;
  background-color: #f4f4f4;
}

.cart-container {
  display: flex;
  width: 90%;
  max-width: 1200px;
  gap: 30px;
}

.cart {
  flex: 2;
  background-color: #fff;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.cart-title {
  font-size: 1.8rem;
  font-weight: bold;
  margin-bottom: 25px;
}

.cart-items-count {
  font-size: 1rem;
  color: #666;
  margin-bottom: 20px;
}

.cart-items-list {
  margin-top: 20px;
}

.cart-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #ddd;
}

.cart-item-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 8px;
}

.cart-item-details {
  flex: 1;
  margin-left: 15px;
}

.item-name {
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 5px;
}

.item-price {
  color: #888;
  font-size: 0.9rem;
  margin-bottom: 10px;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.quantity-input {
  width: 50px;
  text-align: center;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.remove-button {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #888;
  cursor: pointer;
}

.remove-button:hover {
  color: #f00;
}

.back-to-shop {
  display: inline-block;
  margin-top: 30px;
  color: #141516;
  text-decoration: none;
  font-size: 0.9rem;
}

.back-to-shop:hover {
  text-decoration: underline;
}

.summary {
  flex: 1;
  background-color: #f7f7f7;
  padding: 30px;
  border-radius: 10px;
  text-align: left;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.summary-title {
  font-size: 1.5rem;
  font-weight: bold;
  margin-bottom: 20px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  font-size: 1rem;
  color: #333;
}

.shipping-select {
  width: 100%;
  padding: 8px;
  margin-top: 10px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 5px;
}

.give-code-container {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.give-code-container input {
  flex: 1;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.give-code-container button {
  background-color: #000;
  color: #fff;
  border: none;
  padding: 0 20px;
  font-size: 1rem;
  border-radius: 5px;
  cursor: pointer;
}

.give-code-container button:hover {
  background-color: #333;
}

.summary-total {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  font-weight: bold;
  margin-top: 30px;
}

.checkout-button {
  width: 100%;
  padding: 15px;
  margin-top: 20px;
  background-color: #000;
  color: #fff;
  font-size: 1.1rem;
  border: none;
  cursor: pointer;
  border-radius: 5px;
  text-transform: uppercase;
}

.checkout-button:hover {
  background-color: #333;
}
</style>
