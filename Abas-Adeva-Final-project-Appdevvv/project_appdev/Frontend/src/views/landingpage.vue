<template>
  <div class="landing-page">
    <!-- Announcement Bar -->
    <div class="announcement-bar">
      <marquee behavior="scroll" direction="left">🎒 Back to School Sale! Up to 30% Off on Selected Items | Free Shipping on Orders Over ₱1000 | 3-Day Return Guarantee 📚</marquee>
    </div>

    <!-- Header -->
    <header class="header">
      <div class="logo">
        <span class="logo-icon">📚</span>
        Margatheo Store
      </div>
      <div class="nav-controls">
        <router-link to="/login" class="login-button">Sign In</router-link>
        <router-link to="/register" class="register-button">Get Started</router-link>
      </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <h1 class="hero-title">Your Academic Success Starts Here</h1>
        <p class="hero-subtitle">Premium School Supplies for Every Student's Journey</p>
        <div class="hero-features">
          <div class="feature">
            <span class="feature-icon">✨</span>
            <span>Premium Quality</span>
          </div>
          <div class="feature">
            <span class="feature-icon">🚚</span>
            <span>Fast Delivery</span>
          </div>
          <div class="feature">
            <span class="feature-icon">💰</span>
            <span>Best Prices</span>
          </div>
        </div>
        <router-link to="/login" class="cta-button">Explore Collection</router-link>
      </div>
      <div class="hero-image">
        <img src="https://img.freepik.com/free-vector/school-supplies-design_24908-56095.jpg" alt="School Supplies Collection" />
      </div>
    </section>

    <!-- Categories Section -->
    <section class="categories">
      <h2 class="section-title">Popular Categories</h2>
      <div class="category-grid">
        <div class="category-card">
          <div class="category-icon">✏️</div>
          <h3>Writing Essentials</h3>
          <p>Pens, Pencils & More</p>
        </div>
        <div class="category-card">
          <div class="category-icon">📓</div>
          <h3>Notebooks</h3>
          <p>Premium Paper Products</p>
        </div>
        <div class="category-card">
          <div class="category-icon">🎨</div>
          <h3>Art Supplies</h3>
          <p>Colors & Crafts</p>
        </div>
        <div class="category-card">
          <div class="category-icon">🎒</div>
          <h3>Bags & Cases</h3>
          <p>Stylish Storage Solutions</p>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features">
      <h2 class="section-title">Why Choose Margatheo Store?</h2>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">🌟</div>
          <h3>Premium Quality</h3>
          <p>Carefully selected products that last</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">💎</div>
          <h3>Best Value</h3>
          <p>Competitive prices on all items</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">🚚</div>
          <h3>Fast Delivery</h3>
          <p>Quick and reliable shipping</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">♻️</div>
          <h3>Easy Returns</h3>
          <p>Hassle-free 3-day return policy</p>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
      <div class="footer-content">
        <div class="footer-section">
          <h4>Contact Us</h4>
          <p><span class="footer-icon">📍</span> Margatheo Store</p>
          <p><span class="footer-icon">📞</span> +639150232461</p>
          <p><span class="footer-icon">✉️</span> margatheostore@gmail.com</p>
        </div>
        <div class="footer-section">
          <h4>Quick Links</h4>
          <router-link to="/about">About Us</router-link>
          <router-link to="/terms">Terms & Conditions</router-link>
          <router-link to="/privacy">Privacy Policy</router-link>
        </div>
        <div class="footer-section">
          <h4>Follow Us</h4>
          <div class="social-links">
            <a href="#" class="social-link">Facebook</a>
            <a href="#" class="social-link">Instagram</a>
            <a href="#" class="social-link">Twitter</a>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2024 Margatheo Store. All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: "LandingPage"
};
</script>

<style scoped>
/* Modern E-commerce Styling */
.landing-page {
  font-family: 'Poppins', sans-serif;
  color: #2D3748;
  background: #F7FAFC;
}

.announcement-bar {
  background: linear-gradient(90deg, #4F46E5, #7C3AED);
  color: white;
  padding: 0.75rem;
  font-weight: 500;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 5%;
  background: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.logo {
  font-size: 1.5rem;
  font-weight: 700;
  color: #4F46E5;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.logo-icon {
  font-size: 1.8rem;
}

.nav-controls {
  display: flex;
  gap: 1rem;
}

.login-button, .register-button {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
}

.login-button {
  color: #4F46E5;
  background: #EEF2FF;
}

.register-button {
  color: white;
  background: #4F46E5;
}

.login-button:hover, .register-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.hero {
  display: flex;
  align-items: center;
  padding: 4rem 5%;
  background: linear-gradient(135deg, #EEF2FF 0%, #F8FAFC 100%);
  min-height: 80vh;
}

.hero-content {
  flex: 1;
  padding-right: 2rem;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  color: #1A365D;
  line-height: 1.2;
  margin-bottom: 1.5rem;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: #4A5568;
  margin-bottom: 2rem;
}

.hero-features {
  display: flex;
  gap: 2rem;
  margin-bottom: 2rem;
}

.feature {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.feature-icon {
  font-size: 1.5rem;
}

.hero-image {
  flex: 1;
  display: flex;
  justify-content: center;
}

.hero-image img {
  max-width: 100%;
  height: auto;
  border-radius: 20px;
  box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
}

.categories, .features {
  padding: 5rem 5%;
  background: white;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #1A365D;
  margin-bottom: 3rem;
}

.category-grid, .features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.category-card, .feature-card {
  background: white;
  padding: 2rem;
  border-radius: 16px;
  text-align: center;
  transition: all 0.3s ease;
  border: 1px solid #E2E8F0;
}

.category-card:hover, .feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
}

.category-icon, .feature-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.cta-button {
  display: inline-block;
  padding: 1rem 2rem;
  background: #4F46E5;
  color: white;
  border-radius: 8px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
}

.cta-button:hover {
  background: #4338CA;
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.footer {
  background: #1A365D;
  color: white;
  padding: 4rem 5% 2rem;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
  margin-bottom: 3rem;
}

.footer-section h4 {
  font-size: 1.25rem;
  margin-bottom: 1.5rem;
}

.footer-section p {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.footer-icon {
  font-size: 1.2rem;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-link {
  color: white;
  text-decoration: none;
  opacity: 0.8;
  transition: opacity 0.3s ease;
}

.social-link:hover {
  opacity: 1;
}

.footer-bottom {
  text-align: center;
  padding-top: 2rem;
  border-top: 1px solid rgba(255,255,255,0.1);
}

@media (max-width: 768px) {
  .hero {
    flex-direction: column;
    text-align: center;
    padding: 2rem 5%;
  }

  .hero-content {
    padding-right: 0;
    margin-bottom: 2rem;
  }

  .hero-title {
    font-size: 2.5rem;
  }

  .hero-features {
    justify-content: center;
    flex-wrap: wrap;
  }

  .header {
    padding: 1rem;
  }

  .nav-controls {
    gap: 0.5rem;
  }

  .login-button, .register-button {
    padding: 0.5rem 1rem;
  }
}
</style>