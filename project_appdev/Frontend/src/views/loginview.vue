<template>
  <transition name="fade-scale-slide">
    <section class="login-section" v-if="isVisible">
      <div class="container">
        <!-- Left Section: Image -->
        <div class="image-section"></div>

        <!-- Right Section: Login Form -->
        <div class="login-card shadow rounded-3 p-4">
          <!-- Logo -->
          <div class="text-center mb-4">
            <img
              src="https://media.istockphoto.com/vectors/user-member-vector-icon-for-ui-user-interface-or-profile-face-avatar-vector-id1130884625?k=6&m=1130884625&s=170667a&w=0&h=b4ICEL-2imqnsT-m2tYGxZdxlgD1yKxmoDA-PmPc2-A="
              alt="Logo" class="logo mb-2" />
            <h2 class="fs-4 fw-bold text-primary">Sign In</h2>
          </div>

          <!-- Display Error Message -->
          <div v-if="error" class="alert alert-danger" role="alert">
            {{ error }}
          </div>

          <!-- Login Form -->
          <form @submit.prevent="handleLogin">
            <!-- Email Input -->
            <div class="form-floating mb-3">
              <input type="email" class="form-control" v-model="email" id="email" placeholder="name@example.com"
                required />
              <label for="email">Email</label>
            </div>

            <!-- Password Input -->
            <div class="form-floating mb-3">
              <input type="password" class="form-control" v-model="password" id="password" placeholder="Password"
                required />
              <label for="password">Password</label>
            </div>

            <!-- Log In Button -->
            <div class="d-grid">
              <button class="btn btn-primary btn-lg" type="submit">Log In</button>
            </div>
          </form>

          <!-- Forgot Password and Sign Up Links -->
          <div class="text-center mt-3">
            <router-link to="/forgot-password" class="text-primary small">Forgot Password?</router-link>
          </div>
          <div class="text-center mt-2">
            <span class="small">Don’t have an account? </span>
            <a href="javascript:void(0)" @click="goToSignUp" class="text-primary small">Sign Up</a>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
import axios from "axios";

export default {
  name: "LoginComponent",
  data() {
    return {
      email: "",
      password: "",
      error: null,
      isLoading: false, // Add a loading state
      isVisible: true,
    };
  },
  methods: {
    async handleLogin() {
      this.isLoading = true;
      try {
        const response = await axios.post('http://localhost:5555/login', {
          email: this.email,
          password: this.password,
        }, { withCredentials: true });

        this.isLoading = false;
        const userRole = response.data.role;
        localStorage.setItem('userRole', userRole); // Store role in localStorage

        if (userRole === 'admin') {
          this.$router.push('/admin/dashboard');
        } else if (userRole === 'client') {
          this.$router.push('/home');
        } else {
          this.error = 'Unknown role. Please contact support.';
        }
      } catch (err) {
        this.isLoading = false;
        this.error = err.response?.data?.message || "Login failed. Please try again.";
      }
    }
    ,
    goToSignUp() {
      this.isVisible = false; // Trigger fade-out
      setTimeout(() => {
        this.$router.push("/signup"); // Navigate to the sign-up page
      }, 600); // Matches the transition duration
    },
  },
};
</script>


<style scoped>
/* General Styles */
body {
  font-family: 'Inter', sans-serif;
}

.login-section {
  background: #f7f8fa;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* Adjust layout to include an image on the left */
.container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  max-width: 800px;
  background: #ffffff;
  border-radius: 0.75rem;
  overflow: hidden;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

/* Left Section with Image */
.container .image-section {
  flex: 1;
  background: url('https://i.pinimg.com/736x/04/de/36/04de360b2abb7be10f2f78fcaf800a79.jpg') no-repeat center;
  background-size: cover;
  min-height: 400px;
}

/* Right Section for Form */
.login-card {
  flex: 1;
  max-width: 400px;
  width: 100%;
  padding: 2rem;
}

.logo {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 50%;
}

/* Buttons */
.btn-primary {
  background: #f4511e;
  border: none;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background: #f4511e;
  transform: translateY(-1px);
}

/* Form Labels */
.form-floating>label {
  font-size: 0.85rem;
  color: #6c757d;
}

.form-floating>input:focus {
  border-color: #ffb547;
  box-shadow: 0 0 0 0.2rem rgba(255, 181, 71, 0.25);
}

/* Links */
.text-primary {
  color: #ffb547;
  text-decoration: none;
}

.text-primary:hover {
  color: #ff9f33;
}

/* Alert Box */
.alert {
  font-size: 0.8rem;
  padding: 0.5rem;
  margin-top: 1rem;
  text-align: center;
  background-color: rgba(255, 0, 0, 0.1);
  border: 1px solid rgba(255, 0, 0, 0.2);
  color: #d9534f;
}

/* Enhanced Transition Effect */
.fade-scale-slide-enter-active,
.fade-scale-slide-leave-active {
  transition: opacity 0.6s ease, transform 0.6s ease;
}

.fade-scale-slide-enter,
.fade-scale-slide-leave-to {
  opacity: 0;
  transform: scale(0.95) translateY(30px);
}

/* Mobile Responsiveness */
@media (max-width: 576px) {
  .container {
    flex-direction: column;
  }

  .container .image-section {
    display: none;
    /* Hide the image on smaller screens */
  }

  .login-card {
    max-width: 100%;
    padding: 1.5rem;
  }
}
</style>
