<template>
  <div class="auth-page">
    <div class="auth-container">
      <div class="auth-card">
        <div class="brand-section">
          <div class="logo">📝</div>
          <h1 class="brand">Join Our Community</h1>
          <p class="tagline">Get ready for the new school year!</p>
        </div>

        <div class="auth-image">
          <img src="https://img.freepik.com/free-vector/hand-drawn-back-school-pattern_23-2149464866.jpg" alt="School Supplies Pattern" />
        </div>

        <form @submit.prevent="register" class="auth-form" v-if="!showOtpVerification">
          <div class="form-group">
            <label for="fullname">Full Name</label>
            <div class="input-wrapper">
              <span class="input-icon">👤</span>
              <input
                type="text"
                id="fullname"
                v-model="fullname"
                required
                placeholder="Enter your full name"
                autocomplete="name"
              />
            </div>
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
                placeholder="Create a password"
                autocomplete="new-password"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="confirm-password">Confirm Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔐</span>
              <input
                type="password"
                id="confirm-password"
                v-model="confirmPassword"
                required
                placeholder="Confirm your password"
                autocomplete="new-password"
              />
            </div>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Creating Account...' : 'Start Shopping' }}
          </button>

          <p class="auth-link">
            Already have an account? 
            <router-link to="/login" class="link">Sign in here</router-link>
          </p>
        </form>

        <!-- OTP Verification Form -->
        <form @submit.prevent="verifyOTP" class="auth-form" v-else>
          <div class="verification-section">
            <div class="verification-icon">✨</div>
            <h2>Verify Your Email</h2>
            <p>We've sent a code to your email</p>
          </div>

          <div class="form-group">
            <label for="otp">Enter OTP Code</label>
            <div class="input-wrapper">
              <span class="input-icon">🔢</span>
              <input
                type="text"
                id="otp"
                v-model="otpCode"
                required
                placeholder="Enter 6-digit OTP"
                maxlength="6"
                pattern="[0-9]{6}"
                inputmode="numeric"
              />
            </div>
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Verifying...' : 'Verify OTP' }}
          </button>

          <div class="resend-section">
            <p class="resend-text">
              Didn't receive the code?
              <button 
                @click="resendOTP" 
                class="resend-button" 
                :disabled="resendTimer > 0 || isLoading"
              >
                {{ resendTimer > 0 ? `Resend in ${resendTimer}s` : 'Resend OTP' }}
              </button>
            </p>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

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

.verification-section {
  text-align: center;
  margin-bottom: 2rem;
}

.verification-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  animation: sparkle 1.5s ease-in-out infinite;
}

@keyframes sparkle {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.8; transform: scale(1.1); }
}

.verification-section h2 {
  color: #1A365D;
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.verification-section p {
  color: #4A5568;
}

.resend-section {
  text-align: center;
  margin-top: 1.5rem;
}

.resend-button {
  background: none;
  border: none;
  color: #4F46E5;
  font-weight: 500;
  cursor: pointer;
  padding: 0;
  margin-left: 0.5rem;
}

.resend-button:disabled {
  color: #A0AEC0;
  cursor: not-allowed;
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

<script>
import axios from 'axios';

export default {
  name: 'RegisterView',
  data() {
    return {
      fullname: '',
      email: '',
      password: '',
      confirmPassword: '',
      otpCode: '',
      error: null,
      isLoading: false,
      showOtpVerification: false,
      resendTimer: 0,
      resendInterval: null
    }
  },

  methods: {
    async register() {
      if (this.password !== this.confirmPassword) {
        this.error = "Passwords do not match";
        return;
      }

      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/register', {
          fullname: this.fullname,
          email: this.email,
          password: this.password
        });

        if (response.status === 200) {
          this.showOtpVerification = true;
          this.startResendTimer();
        }
      } catch (err) {
        console.error('Registration error:', err);
        this.error = err.response?.data?.message || "Registration failed. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    async verifyOTP() {
      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/verify-otp', {
          email: this.email,
          otp: this.otpCode
        });

        if (response.status === 200) {
          // Show success message
          alert('Email verified successfully! You can now log in.');
          // Redirect to login page
          this.$router.push('/login');
        }
      } catch (err) {
        console.error('OTP verification error:', err);
        this.error = err.response?.data?.message || "Verification failed. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    async resendOTP() {
      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/resend-otp', {
          email: this.email
        });

        if (response.status === 200) {
          alert('New OTP has been sent to your email.');
          this.startResendTimer();
        }
      } catch (err) {
        console.error('Resend OTP error:', err);
        this.error = err.response?.data?.message || "Failed to resend OTP. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    startResendTimer() {
      this.resendTimer = 60; // 60 seconds cooldown
      this.resendInterval = setInterval(() => {
        if (this.resendTimer > 0) {
          this.resendTimer--;
        } else {
          clearInterval(this.resendInterval);
        }
      }, 1000);
    }
  },

  beforeDestroy() {
    if (this.resendInterval) {
      clearInterval(this.resendInterval);
    }
  }
}
</script>