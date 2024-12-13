const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const userModel = require('../../model/userModel');
const profileController = require('./profileController');

// Function to generate OTP
const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const userController = {
  // User Registration
  registrationHandler: async (req, res) => {
    const { fullname, email, password } = req.body;

    userModel.findByEmail(email, async (err, users) => {
      if (err) return res.status(500).json({ message: 'Error checking user.' });
      if (users.length > 0) return res.status(400).json({ message: 'This email is already registered.' });

      try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const otp = generateOTP();
        const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // OTP expires in 10 minutes

        userModel.create({ 
          fullname, 
          email, 
          password: hashedPassword,
          otp,
          otp_expires: otpExpires,
          is_verified: false 
        }, async (err, result) => {
          if (err) return res.status(500).json({ message: 'Error registering user.' });

          // Create initial profile with user data
          const userId = result.insertId;
          await profileController.createInitialProfile(userId, { fullname, email });

          // Send OTP email
          const mailOptions = {
            from: 'margatheostore@gmail.com',
            to: email,
            subject: 'Email Verification OTP',
            text: `Your OTP for email verification is: ${otp}\nThis OTP will expire in 10 minutes.`,
            html: `
              <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #4f46e5;">Verify Your Email</h2>
                <p>Thank you for registering! Please use the following OTP to verify your email address:</p>
                <div style="background-color: #f3f4f6; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
                  <h1 style="color: #4f46e5; letter-spacing: 5px; margin: 0;">${otp}</h1>
                </div>
                <p style="color: #64748b;">This OTP will expire in 10 minutes.</p>
                <p style="color: #64748b;">If you didn't request this verification, please ignore this email.</p>
              </div>
            `
          };

          const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
              user: 'margatheostore@gmail.com',
              pass: 'hsrl eygy mygn fbhm',
            },
          });

          transporter.sendMail(mailOptions, (err, info) => {
            if (err) {
              console.log('Error sending email:', err);
              return res.status(500).json({ message: 'Error sending verification email.' });
            }
            console.log('Verification email sent:', info.response);
            res.status(200).json({ message: 'Registration successful. Please check your email for OTP verification.' });
          });
        });
      } catch (err) {
        return res.status(500).json({ message: 'Error hashing password.' });
      }
    });
  },

  // Verify OTP
  verifyOTP: async (req, res) => {
    const { email, otp } = req.body;

    userModel.findByEmail(email, async (err, users) => {
      if (err) return res.status(500).json({ message: 'Error finding user.' });
      if (users.length === 0) return res.status(404).json({ message: 'User not found.' });

      const user = users[0];
      const now = new Date();
      const otpExpires = new Date(user.otp_expires);

      if (user.is_verified) {
        return res.status(400).json({ message: 'Email is already verified.' });
      }

      if (now > otpExpires) {
        return res.status(400).json({ message: 'OTP has expired. Please request a new one.' });
      }

      if (user.otp !== otp) {
        return res.status(400).json({ message: 'Invalid OTP.' });
      }

      // Update user verification status
      userModel.updateVerificationStatus(user.id, (err) => {
        if (err) return res.status(500).json({ message: 'Error verifying email.' });
        res.status(200).json({ message: 'Email verified successfully. You can now log in.' });
      });
    });
  },

  // Resend OTP
  resendOTP: async (req, res) => {
    const { email } = req.body;

    userModel.findByEmail(email, async (err, users) => {
      if (err) return res.status(500).json({ message: 'Error finding user.' });
      if (users.length === 0) return res.status(404).json({ message: 'User not found.' });

      const user = users[0];
      if (user.is_verified) {
        return res.status(400).json({ message: 'Email is already verified.' });
      }

      // Generate new OTP
      const otp = generateOTP();
      const otpExpires = new Date(Date.now() + 10 * 60 * 1000);

      // Update user with new OTP
      userModel.updateOTP(user.id, otp, otpExpires, async (err) => {
        if (err) return res.status(500).json({ message: 'Error updating OTP.' });

        // Send new OTP email
        const mailOptions = {
          from: 'margatheostore@gmail.com',
          to: email,
          subject: 'New Email Verification OTP',
          text: `Your new OTP for email verification is: ${otp}\nThis OTP will expire in 10 minutes.`,
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #4f46e5;">New Verification OTP</h2>
              <p>You requested a new OTP. Please use the following code to verify your email address:</p>
              <div style="background-color: #f3f4f6; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
                <h1 style="color: #4f46e5; letter-spacing: 5px; margin: 0;">${otp}</h1>
              </div>
              <p style="color: #64748b;">This OTP will expire in 10 minutes.</p>
              <p style="color: #64748b;">If you didn't request this verification, please ignore this email.</p>
            </div>
          `
        };

        const transporter = nodemailer.createTransport({
          service: 'Gmail',
          auth: {
            user: 'margatheostore@gmail.com',
            pass: 'hsrl eygy mygn fbhm',
          },
        });

        transporter.sendMail(mailOptions, (err, info) => {
          if (err) {
            console.log('Error sending email:', err);
            return res.status(500).json({ message: 'Error sending verification email.' });
          }
          console.log('New verification email sent:', info.response);
          res.status(200).json({ message: 'New OTP has been sent to your email.' });
        });
      });
    });
  },

  // Forgot Password Request
  forgotPassword: async (req, res) => {
    const { email } = req.body;

    userModel.findByEmail(email, async (err, users) => {
      if (err) return res.status(500).json({ message: 'Error finding user.' });
      if (users.length === 0) return res.status(404).json({ message: 'No account found with this email.' });

      const user = users[0];
      const otp = generateOTP();
      const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

      // Update user with password reset OTP
      userModel.updateOTP(user.id, otp, otpExpires, async (err) => {
        if (err) return res.status(500).json({ message: 'Error updating OTP.' });

        // Send OTP email
        const mailOptions = {
          from: 'margatheostore@gmail.com',
          to: email,
          subject: 'Password Reset OTP',
          text: `Your OTP for password reset is: ${otp}\nThis OTP will expire in 10 minutes.`,
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #4f46e5;">Password Reset</h2>
              <p>You requested to reset your password. Use the following OTP code:</p>
              <div style="background-color: #f3f4f6; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
                <h1 style="color: #4f46e5; letter-spacing: 5px; margin: 0;">${otp}</h1>
              </div>
              <p style="color: #64748b;">This OTP will expire in 10 minutes.</p>
              <p style="color: #64748b;">If you didn't request this password reset, please ignore this email.</p>
            </div>
          `
        };

        const transporter = nodemailer.createTransport({
          service: 'Gmail',
          auth: {
            user: 'margatheostore@gmail.com',
            pass: 'hsrl eygy mygn fbhm',
          },
        });

        transporter.sendMail(mailOptions, (err, info) => {
          if (err) {
            console.log('Error sending email:', err);
            return res.status(500).json({ message: 'Error sending OTP email.' });
          }
          console.log('Password reset OTP sent:', info.response);
          res.status(200).json({ message: 'Password reset OTP has been sent to your email.' });
        });
      });
    });
  },

  // Reset Password with OTP
  resetPassword: async (req, res) => {
    const { email, otp, newPassword } = req.body;

    userModel.findByEmail(email, async (err, users) => {
      if (err) return res.status(500).json({ message: 'Error finding user.' });
      if (users.length === 0) return res.status(404).json({ message: 'User not found.' });

      const user = users[0];
      const now = new Date();
      const otpExpires = new Date(user.otp_expires);

      if (now > otpExpires) {
        return res.status(400).json({ message: 'OTP has expired. Please request a new one.' });
      }

      if (user.otp !== otp) {
        return res.status(400).json({ message: 'Invalid OTP.' });
      }

      try {
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        userModel.updatePassword(user.id, hashedPassword, (err) => {
          if (err) return res.status(500).json({ message: 'Error updating password.' });
          
          // Clear OTP after successful password reset
          userModel.updateOTP(user.id, null, null, (err) => {
            if (err) console.error('Error clearing OTP:', err);
          });

          res.status(200).json({ message: 'Password has been reset successfully. You can now login with your new password.' });
        });
      } catch (err) {
        return res.status(500).json({ message: 'Error hashing password.' });
      }
    });
  },

  // Login remains the same but checks for is_verified
  loginHandler: async (req, res) => {
    const { email, password } = req.body;
    console.log("Login attempt for:", email);

    userModel.findByEmail(email, async (err, users) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ message: "Internal server error" });
      }

      if (users.length === 0) {
        return res.status(401).json({ message: "This account is not registered." });
      }

      const user = users[0];

      try {
        const match = await bcrypt.compare(password, user.password);
        if (!match) {
          return res.status(401).json({ message: "Invalid password." });
        }

        if (!user.is_verified) {
          return res.status(401).json({ 
            message: "Please verify your email before logging in.",
            needsVerification: true,
            email: user.email
          });
        }

        req.session.userId = user.id;
        req.session.role = user.role || 'client';
        req.session.email = user.email;

        req.session.save((err) => {
          if (err) {
            console.error("Session save error:", err);
            return res.status(500).json({ message: "Error saving session" });
          }

          res.status(200).json({
            message: "Login successful",
            role: user.role || 'client',
            email: user.email,
            redirectPath: user.role === 'admin' ? '/admin/dashboard' : '/dashboard'
          });
        });

      } catch (error) {
        console.error("Login error:", error);
        res.status(500).json({ message: "Error during login" });
      }
    });
  },

  // Email Verification
  verifyEmail: (req, res) => {
    const { token } = req.query;

    userModel.findByVerificationToken(token, (err, users) => {
      if (err) {
        console.error('Error finding user by verification token:', err);
        return res.status(500).send('Internal error occurred.');
      }
      if (users.length === 0) {
        return res.status(400).send('Invalid or expired verification token.');
      }

      const user = users[0];

      userModel.updateVerificationStatus(user.id, (err) => {
        if (err) {
          console.error('Error updating verification status:', err);
          return res.status(500).send('Error verifying email.');
        }
        res.send('Your email has been verified! You may now log in.');
      });
    });
  },

  // Profile Handler
  profileHandler: (req, res) => {
    const userId = req.session.userId;

    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    userModel.findById(userId, (err, users) => {
      if (err || users.length === 0) return res.status(404).json({ message: 'User not found' });

      const user = users[0];
      return res.status(200).json({
        user: {
          fullname: user.fullname,
          email: user.email,
        },
      });
    });
  },
};

module.exports = userController;
