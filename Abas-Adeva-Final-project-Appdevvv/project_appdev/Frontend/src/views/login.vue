<template>
  <div class="auth-page">
    <div class="auth-container">
      <div class="auth-card">
        <div class="brand-section">
          <div class="logo">📚</div>
          <h1 class="brand">Welcome to Margatheo</h1>
          <p class="tagline">Your one-stop school supplies shop!</p>
        </div>

        <div class="auth-image">
          <img src="https://img.freepik.com/free-vector/hand-drawn-school-supplies-pattern_23-2149464866.jpg" alt="School Supplies" />
        </div>

        <form @submit.prevent="login" class="auth-form">
          <div class="welcome-back">
            <h2>Welcome Back!</h2>
            <p>Sign in to continue shopping</p>
          </div>

          <div class="form-group">
            <label for="email">Email Address</label>
            <div class="input-wrapper">
              <span class="input-icon">✉️</span>
              <input
                type="email"
                id="email"
                v-model="email"
                required
                placeholder="Enter your email"
                autocomplete="email"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔑</span>
              <input
                type="password"
                id="password"
                v-model="password"
                required
                placeholder="Enter your password"
                autocomplete="current-password"
              />
            </div>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Signing in...' : 'Sign In' }}
          </button>

          <p class="auth-link">
            New to our store? 
            <router-link to="/register" class="link">Create an account</router-link>
          </p>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      error: null,
      isLoading: false
    }
  },
  methods: {
    async login() {
      this.error = null;
      this.isLoading = true;
      
      try {
        // Add your login logic here
        const response = await fetch('http://localhost:8000/api/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            email: this.email,
            password: this.password
          })
        });

        const data = await response.json();

        if (!response.ok) {
          throw new Error(data.message || 'Login failed');
        }

        // Store the token
        localStorage.setItem('token', data.token);
        
        // Redirect to home page
        this.$router.push('/home');
      } catch (err) {
        this.error = err.message;
      } finally {
        this.isLoading = false;
      }
    }
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F3F4F6;
  padding: 2rem;
}

.auth-container {
  width: 100%;
  max-width: 480px;
}

.auth-card {
  background: white;
  padding: 2.5rem;
  border-radius: 1.5rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
}

.brand-section {
  text-align: center;
  margin-bottom: 2rem;
  position: relative;
  z-index: 1;
}

.logo {
  font-size: 3rem;
  margin-bottom: 1rem;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.brand {
  font-size: 2rem;
  font-weight: 700;
  color: #1A365D;
  margin-bottom: 0.5rem;
}

.tagline {
  color: #4A5568;
  font-size: 1.1rem;
}

.welcome-back {
  text-align: center;
  margin-bottom: 2rem;
}

.welcome-back h2 {
  color: #1A365D;
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.welcome-back p {
  color: #4A5568;
}

.auth-image {
  width: 100%;
  height: 200px;
  margin-bottom: 2rem;
  overflow: hidden;
  border-radius: 1rem;
}

.auth-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  font-weight: 500;
  color: #2D3748;
  margin-bottom: 0.5rem;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 1rem;
  font-size: 1.25rem;
}

input {
  width: 100%;
  padding: 0.875rem 1rem 0.875rem 3rem;
  border: 2px solid #E2E8F0;
  border-radius: 1rem;
  font-size: 1rem;
  color: #1A365D;
  transition: all 0.3s ease;
  background: #F8FAFC;
}

input:focus {
  outline: none;
  border-color: #4F46E5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
  background: white;
}

.auth-button {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
  color: white;
  border: none;
  border-radius: 1rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.auth-button::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    to bottom right,
    rgba(255, 255, 255, 0.2),
    rgba(255, 255, 255, 0)
  );
  transform: rotate(45deg);
  transition: 0.5s;
}

.auth-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
}

.auth-button:hover::after {
  left: 100%;
}

.auth-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.auth-link {
  text-align: center;
  margin-top: 1.5rem;
  color: #4A5568;
}

.link {
  color: #4F46E5;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

.link:hover {
  color: #7C3AED;
}

.error-message {
  background: #FEE2E2;
  color: #DC2626;
  padding: 1rem;
  border-radius: 1rem;
  margin-bottom: 1rem;
  font-size: 0.95rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.error-message::before {
  content: '⚠️';
}

@media (max-width: 640px) {
  .auth-card {
    padding: 2rem;
  }

  .brand {
    font-size: 1.75rem;
  }

  .tagline {
    font-size: 1rem;
  }

  .auth-image {
    height: 150px;
  }
}
</style>
