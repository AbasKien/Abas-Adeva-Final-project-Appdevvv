<template>
  <div class="auth-page">
    <div class="auth-container">
      <div class="auth-card">
        <div class="brand-section">
          <h1 class="brand">Margatheo Store</h1>
          <p class="tagline" v-if="!showForgotPassword && !showResetPassword">Welcome back! Please login to your account.</p>
          <p class="tagline" v-else-if="showForgotPassword">Reset your password</p>
          <p class="tagline" v-else>Enter OTP to reset password</p>
        </div>

        <!-- Main Login Form -->
        <form @submit.prevent="handleLogin" class="auth-form" v-if="!showForgotPassword && !showResetPassword">
          <div class="form-group">
            <label for="email">Email Address</label>
            <div class="input-wrapper">
              <span class="input-icon">📧</span>
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
              <span class="input-icon">🔒</span>
              <input
                type="password"
                id="password"
                v-model="password"
                required
                placeholder="Enter your password"
                autocomplete="current-password"
              />
            </div>
            <button type="button" @click="showForgotPassword = true" class="forgot-password-link">
              Forgot Password?
            </button>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Logging in...' : 'Login' }}
          </button>

          <p class="auth-link">
            Don't have an account? 
            <router-link to="/signup" class="link">Sign up here</router-link>
          </p>
        </form>

        <!-- Forgot Password Form -->
        <form @submit.prevent="handleForgotPassword" class="auth-form" v-if="showForgotPassword && !showResetPassword">
          <div class="form-group">
            <h3 class="form-subtitle">Reset Password</h3>
            <p class="form-description">Enter your email address and we'll send you an OTP to reset your password.</p>
            <div class="input-wrapper">
              <span class="input-icon">📧</span>
              <input
                type="email"
                id="reset-email"
                v-model="email"
                required
                placeholder="Enter your email"
                autocomplete="email"
              />
            </div>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Sending OTP...' : 'Send Reset OTP' }}
          </button>

          <button type="button" @click="cancelReset" class="back-button">
            Back to Login
          </button>
        </form>

        <!-- Reset Password Form -->
        <form @submit.prevent="handleResetPassword" class="auth-form" v-if="showResetPassword">
          <div class="form-group">
            <h3 class="form-subtitle">Reset Your Password</h3>
            <p class="form-description">Enter the OTP sent to {{ email }}</p>
            
            <div class="input-wrapper">
              <span class="input-icon">🔢</span>
              <input
                type="text"
                id="reset-otp"
                v-model="otpCode"
                required
                placeholder="Enter 6-digit OTP"
                maxlength="6"
                pattern="[0-9]{6}"
                inputmode="numeric"
              />
            </div>
          </div>

          <div class="form-group">
            <div class="input-wrapper">
              <span class="input-icon">🔒</span>
              <input
                type="password"
                id="new-password"
                v-model="newPassword"
                required
                placeholder="Enter new password"
                autocomplete="new-password"
              />
            </div>
          </div>

          <div class="form-group">
            <div class="input-wrapper">
              <span class="input-icon">🔐</span>
              <input
                type="password"
                id="confirm-new-password"
                v-model="confirmNewPassword"
                required
                placeholder="Confirm new password"
                autocomplete="new-password"
              />
            </div>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button type="submit" class="auth-button" :disabled="isLoading">
            {{ isLoading ? 'Resetting Password...' : 'Reset Password' }}
          </button>

          <div class="resend-section">
            <button type="button" @click="resendOTP" class="resend-button" :disabled="isLoading || resendTimer > 0">
              {{ resendTimer > 0 ? `Resend OTP in ${resendTimer}s` : 'Resend OTP' }}
            </button>
          </div>

          <button type="button" @click="cancelReset" class="back-button">
            Back to Login
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'LoginView',
  data() {
    return {
      email: '',
      password: '',
      otpCode: '',
      newPassword: '',
      confirmNewPassword: '',
      error: null,
      isLoading: false,
      showForgotPassword: false,
      showResetPassword: false,
      resendTimer: 0,
      resendInterval: null
    }
  },

  methods: {
    async handleLogin() {
      if (!this.email || !this.password) {
        this.error = "Please fill in all fields";
        return;
      }

      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/login', {
          email: this.email,
          password: this.password
        }, {
          withCredentials: true // Enable cookies for session
        });

        if (response.data.needsVerification) {
          this.error = response.data.message;
          return;
        }

        // Store user data in localStorage
        localStorage.setItem('userEmail', response.data.email);
        localStorage.setItem('userRole', response.data.role || 'client');
        localStorage.setItem('token', response.data.token); // Store the actual JWT token
        localStorage.setItem('isLoggedIn', 'true');

        // Redirect based on role
        const role = response.data.role || 'client';
        if (role === 'admin') {
          await this.$router.push('/admin/dashboard');
        } else {
          await this.$router.push('/home');
        }
      } catch (err) {
        console.error('Login error:', err);
        this.error = err.response?.data?.message || "Login failed. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    async handleForgotPassword() {
      if (!this.email) {
        this.error = "Please enter your email address";
        return;
      }

      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/forgot-password', {
          email: this.email
        });

        if (response.status === 200) {
          this.showForgotPassword = false;
          this.showResetPassword = true;
          this.startResendTimer();
          alert('OTP has been sent to your email.');
        }
      } catch (err) {
        console.error('Forgot password error:', err);
        this.error = err.response?.data?.message || "Failed to send reset OTP. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    async handleResetPassword() {
      if (!this.otpCode || !this.newPassword || !this.confirmNewPassword) {
        this.error = "Please fill in all fields";
        return;
      }

      if (this.newPassword !== this.confirmNewPassword) {
        this.error = "Passwords do not match";
        return;
      }

      if (this.newPassword.length < 6) {
        this.error = "Password must be at least 6 characters long";
        return;
      }

      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/reset-password', {
          email: this.email,
          otp: this.otpCode,
          newPassword: this.newPassword
        });

        if (response.status === 200) {
          // Store the email temporarily for login
          const tempEmail = this.email;
          
          // Reset the form and show success message
          alert('Password has been reset successfully. Please login with your new password.');
          this.resetForm();
          this.showResetPassword = false;
          
          // Set the email back for easier login
          this.email = tempEmail;
          this.password = '';
        }
      } catch (err) {
        console.error('Reset password error:', err);
        this.error = err.response?.data?.message || "Failed to reset password. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },

    resetForm() {
      this.password = '';
      this.otpCode = '';
      this.newPassword = '';
      this.confirmNewPassword = '';
      this.error = null;
    },

    cancelReset() {
      this.resetForm();
      this.email = '';
      this.showForgotPassword = false;
      this.showResetPassword = false;
      if (this.resendInterval) {
        clearInterval(this.resendInterval);
      }
      this.resendTimer = 0;
    },

    async resendOTP() {
      this.isLoading = true;
      this.error = null;

      try {
        const response = await axios.post('http://localhost:5555/forgot-password', {
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
      this.resendTimer = 60;
      if (this.resendInterval) {
        clearInterval(this.resendInterval);
      }
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

<style scoped>
.auth-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  font-family: "Poppins", sans-serif;
}

.auth-container {
  width: 100%;
  max-width: 440px;
}

.auth-card {
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
  position: relative;
}

.auth-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #4f46e5, #7c3aed);
  border-radius: 20px 20px 0 0;
}

.brand-section {
  text-align: center;
  margin-bottom: 2rem;
}

.brand {
  font-size: 2rem;
  font-weight: 700;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 0.5rem;
}

.tagline {
  color: #64748b;
  font-size: 0.95rem;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 600;
  color: #1a202c;
  font-size: 0.95rem;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 1rem;
  font-size: 1.2rem;
}

input {
  width: 100%;
  padding: 0.75rem 1rem 0.75rem 3rem;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  font-size: 1rem;
  color: #1a202c;
  transition: all 0.3s ease;
  background: #f8fafc;
}

input:focus {
  border-color: #4f46e5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
  outline: none;
}

.auth-button {
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  color: white;
  padding: 1rem;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 1rem;
}

.auth-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2);
}

.auth-link {
  text-align: center;
  color: #64748b;
  font-size: 0.95rem;
  margin-top: 1rem;
}

.link {
  color: #4f46e5;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.link:hover {
  color: #7c3aed;
}

.otp-hint {
  color: #64748b;
  font-size: 0.875rem;
  margin-top: 0.5rem;
  text-align: center;
}

.resend-button {
  background: transparent;
  border: none;
  color: #4f46e5;
  padding: 0.5rem;
  margin-top: 1rem;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.resend-button:hover:not(:disabled) {
  color: #7c3aed;
  text-decoration: underline;
}

.resend-button:disabled {
  color: #94a3b8;
  cursor: not-allowed;
}

.forgot-password-link {
  color: #4f46e5;
  font-size: 0.875rem;
  text-align: right;
  background: none;
  border: none;
  padding: 0;
  cursor: pointer;
  display: block;
  margin-left: auto;
  margin-top: 0.5rem;
  transition: color 0.3s ease;
}

.forgot-password-link:hover {
  color: #7c3aed;
  text-decoration: underline;
}

.back-button {
  background: transparent;
  border: none;
  color: #64748b;
  padding: 0.5rem;
  margin-top: 1rem;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
  width: 100%;
}

.back-button:hover {
  color: #1a202c;
}

.form-subtitle {
  color: #1a202c;
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  text-align: center;
}

.form-description {
  color: #64748b;
  font-size: 0.875rem;
  text-align: center;
  margin-bottom: 1.5rem;
}

@media (max-width: 640px) {
  .auth-page {
    padding: 1rem;
  }

  .auth-card {
    padding: 2rem;
  }

  .brand {
    font-size: 1.75rem;
  }
}
</style>
