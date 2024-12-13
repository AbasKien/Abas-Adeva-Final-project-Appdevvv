<template>
  <div class="homepage">
    <!-- Announcement Bar -->
    <div class="announcement-bar">
      <span>🎒 Back to School | Shop now! | 3-Day Return Guarantee 📚</span>
    </div>

    <!-- Header -->
    <header class="header">
      <div class="logo">
        <span class="logo-icon">📚</span>
        Margatheo Store
      </div>
      <nav class="nav">
        <router-link to="/home" class="nav-link">  <span class="icon">🏠</span> Home </router-link>
        <router-link to="/product" class="nav-link"><span class="icon">🛍️</span> Shop </router-link>
      </nav>
      <div class="user-controls">
        <router-link to="/cart" class="cart-link">
          <span class="cart-icon">🛒</span>
          <span class="cart-label">Cart</span>
        </router-link>
        <div class="profile-menu">
          <button @click="showDropdown = !showDropdown" class="profile-btn">
            <span class="profile-icon">👤</span>
          </button>
          <div class="dropdown" v-if="showDropdown">
            <router-link to="/profile" class="dropdown-item">
              <span>👤</span> Profile
            </router-link>
            <a @click="logout" class="dropdown-item">
              <span>🚪</span> Logout
            </a>
          </div>
        </div>
      </div>
    </header>

    <!-- Featured Section -->
    <section class="featured-section">
      <div class="container">
        <h2 class="section-title">Welcome to Margatheo Store</h2>
        <p class="section-subtitle">Your One-Stop Shop for School Supplies</p>
        
        <!-- Features Grid -->
        <div class="features-grid">
          <div class="feature-card">
            <span class="feature-icon">📚</span>
            <h3>Quality Products</h3>
            <p>Carefully selected school supplies</p>
          </div>
          
          <div class="feature-card">
            <span class="feature-icon">🚚</span>
            <h3>Cash on Delivery</h3>
            <p>Convenient payment option</p>
          </div>
          
          <div class="feature-card">
            <span class="feature-icon">⭐</span>
            <h3>Best Service</h3>
            <p>Customer satisfaction guaranteed</p>
          </div>
          
          <div class="feature-card">
            <span class="feature-icon">↩️</span>
            <h3>Easy Returns</h3>
            <p>3-day return guarantee</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Quick Links -->
    <section class="quick-links">
      <div class="container">
        <div class="links-grid">
          <router-link to="/product" class="quick-link-card">
            <span class="link-icon">📝</span>
            <h3>School Supplies</h3>
            <p>Browse our collection</p>
          </router-link>

          <router-link to="/profile" class="quick-link-card">
            <span class="link-icon">👤</span>
            <h3>My Account</h3>
            <p>View profile & orders</p>
          </router-link>

          <router-link to="/cart" class="quick-link-card">
            <span class="link-icon">🛒</span>
            <h3>Shopping Cart</h3>
            <p>View your items</p>
          </router-link>

          <div class="quick-link-card" @click="contactUs">
            <span class="link-icon">📞</span>
            <h3>Contact Us</h3>
            <p>Get support</p>
          </div>
        </div>
      </div>
    </section>

    <!-- About Section -->
    <section class="about-section">
      <div class="container">
        <div class="about-content">
          <h2>About Margatheo Store</h2>
          <p>We're dedicated to providing quality school supplies at affordable prices. Our commitment to excellence ensures that students and professionals alike find everything they need for success.</p>
          <router-link to="/product" class="shop-now-btn">
            Shop Now <span class="icon">→</span>
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showDropdown: false
    }
  },
  methods: {
    logout() {
      localStorage.removeItem('token');
      this.$router.push('/login');
      this.showDropdown = false;
    },
    closeDropdown(e) {
      if (!e.target.closest('.profile-menu')) {
        this.showDropdown = false;
      }
    },
    contactUs() {
      alert('Contact us at: support@margatheostore.com');
    }
  },
  mounted() {
    document.addEventListener('click', this.closeDropdown);
  },
  unmounted() {
    document.removeEventListener('click', this.closeDropdown);
  }
}
</script>

<style scoped>
.homepage {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
}

.announcement-bar {
  background: #4F46E5;
  color: white;
  padding: 0.5rem;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
}

.announcement-bar span {
  display: inline-block;
  animation: slide 20s linear infinite;
}

@keyframes slide {
  0% { transform: translateX(100%); }
  100% { transform: translateX(-100%); }
}

.header {
  background: white;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 1.5rem;
  font-weight: 700;
  color: #4F46E5;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav-link {
  text-decoration: none;
  color: #4b5563;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: color 0.3s ease;
}

.nav-link:hover {
  color: #4F46E5;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.featured-section {
  padding: 4rem 0;
  text-align: center;
}

.section-title {
  font-size: 2.5rem;
  color: #1f2937;
  margin-bottom: 1rem;
  font-weight: 700;
}

.section-subtitle {
  font-size: 1.25rem;
  color: #6b7280;
  margin-bottom: 3rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.feature-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  display: inline-block;
}

.feature-card h3 {
  color: #1f2937;
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.feature-card p {
  color: #6b7280;
}

.quick-links {
  background: white;
  padding: 4rem 0;
}

.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.quick-link-card {
  text-decoration: none;
  color: inherit;
  background: #f8fafc;
  padding: 2rem;
  border-radius: 1rem;
  text-align: center;
  transition: all 0.3s ease;
  cursor: pointer;
}

.quick-link-card:hover {
  background: #4F46E5;
  color: white;
  transform: translateY(-5px);
}

.link-icon {
  font-size: 2rem;
  margin-bottom: 1rem;
  display: inline-block;
}

.quick-link-card h3 {
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.quick-link-card p {
  opacity: 0.8;
}

.about-section {
  padding: 4rem 0;
  background: linear-gradient(90deg, #4F46E5, #7C3AED);
  color: white;
}

.about-content {
  max-width: 800px;
  margin: 0 auto;
  text-align: center;
}

.about-content h2 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  font-weight: 700;
}

.about-content p {
  font-size: 1.1rem;
  margin-bottom: 2rem;
  opacity: 0.9;
  line-height: 1.7;
}

.shop-now-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background: white;
  color: #4F46E5;
  padding: 1rem 2rem;
  border-radius: 0.5rem;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
}

.shop-now-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.user-controls {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.cart-link,
.profile-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
  color: #1A365D;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  transition: all 0.3s ease;
}

.cart-link:hover,
.profile-link:hover {
  background: rgba(79, 70, 229, 0.1);
  color: #4F46E5;
}

.cart-icon,
.profile-icon {
  font-size: 1.25rem;
  transition: transform 0.3s ease;
}

.cart-link:hover .cart-icon,
.profile-link:hover .profile-icon {
  transform: translateY(-2px);
}

.cart-label,
.profile-label {
  font-weight: 500;
  letter-spacing: 0.025em;
}

.profile-menu {
  position: relative;
  display: inline-block;
}

.profile-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.profile-btn:hover {
  background: rgba(79, 70, 229, 0.1);
}

.profile-icon {
  font-size: 1.5rem;
}

.dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  min-width: 200px;
  margin-top: 8px;
  z-index: 1000;
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  color: #1a1a1a;
  text-decoration: none;
  cursor: pointer;
}

.dropdown-item:hover {
  background: rgba(79, 70, 229, 0.1);
  color: #4F46E5;
}

.dropdown-item span {
  font-size: 1.2rem;
}

@media (max-width: 768px) {
  .header {
    padding: 1rem;
  }
  
  .nav {
    gap: 1rem;
  }
  
  .section-title {
    font-size: 2rem;
  }
  
  .container {
    padding: 1rem;
  }
  
  .features-grid,
  .links-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .about-content {
    padding: 0 1rem;
  }
}
</style>