const pool = require('../config/db'); // Import the database pool

// Find a user by email
const findByEmail = (email, callback) => {
  pool.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (err) {
      return callback(err, null);
    }
    return callback(null, results);
  });
};

// Create a new user
const create = (userData, callback) => {
  const { fullname, email, password, otp, otp_expires, is_verified } = userData;
  pool.query(
    'INSERT INTO users (fullname, email, password, otp, otp_expires, is_verified) VALUES (?, ?, ?, ?, ?, ?)',
    [fullname, email, password, otp, otp_expires, is_verified],
    (err, results) => {
      if (err) {
        return callback(err, null);
      }
      return callback(null, results);
    }
  );
};

// Update verification status
const updateVerificationStatus = (userId, callback) => {
  pool.query(
    'UPDATE users SET is_verified = ?, otp = NULL, otp_expires = NULL WHERE id = ?',
    [true, userId],
    (err, results) => {
      if (err) {
        return callback(err, null);
      }
      return callback(null, results);
    }
  );
};

// Update OTP
const updateOTP = (userId, otp, otpExpires, callback) => {
  pool.query(
    'UPDATE users SET otp = ?, otp_expires = ? WHERE id = ?',
    [otp, otpExpires, userId],
    (err, results) => {
      if (err) {
        return callback(err, null);
      }
      return callback(null, results);
    }
  );
};

// Update password
const updatePassword = (userId, hashedPassword, callback) => {
  const sql = 'UPDATE users SET password = ? WHERE id = ?';
  pool.query(sql, [hashedPassword, userId], callback);
};

// Find a user by ID
const findById = (userId, callback) => {
  pool.query('SELECT * FROM users WHERE id = ?', [userId], (err, results) => {
    if (err) {
      return callback(err, null);
    }
    return callback(null, results);
  });
};

module.exports = {
  findByEmail,
  create,
  updateVerificationStatus,
  updateOTP,
  findById,
  updatePassword,
};
