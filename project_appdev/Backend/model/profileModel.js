const db = require('../config/db'); // Assuming this is your DB connection

const profileModel = {
    // Get the profile of a user by user ID
    getProfileByUserId: (userId, callback) => {
        const query = 'SELECT * FROM profiles WHERE user_id = ?';
        db.query(query, [userId], (err, result) => {
            if (err) {
                console.error('Error fetching profile:', err);
                return callback(err);
            }
            callback(null, result[0]); // Return the first profile if found
        });
    },

    // Update the profile of a user
    updateProfile: (userId, data, callback) => {
        const { phone, address } = data;
        const query = `
            UPDATE profiles 
            SET phone = ?, address = ? 
            WHERE user_id = ?`;
        db.query(query, [phone, address, userId], (err, result) => {
            if (err) {
                console.error('Error updating profile:', err);
                return callback(err);
            }
            callback(null, result);
        });
    },

    // Create a new profile for a user
    createProfile: (userId, data, callback) => {
        const { phone, address } = data;
        const query = `
            INSERT INTO profiles (user_id, phone, address) 
            VALUES (?, ?, ?)`;
        db.query(query, [userId, phone, address], (err, result) => {
            if (err) {
                console.error('Error creating profile:', err);
                return callback(err);
            }
            callback(null, result);
        });
    },

    // Delete the profile of a user
    deleteProfile: (userId, callback) => {
        const query = 'DELETE FROM profiles WHERE user_id = ?';
        db.query(query, [userId], (err, result) => {
            if (err) {
                console.error('Error deleting profile:', err);
                return callback(err);
            }
            callback(null, result);
        });
    },
};

module.exports = profileModel;
