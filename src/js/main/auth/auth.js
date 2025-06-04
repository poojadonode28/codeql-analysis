const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// SECURITY ISSUE: Weak secret key generation
const generateSecret = () => {
    return Math.random().toString(36);
};

// SECURITY ISSUE: Weak password hashing
const hashPassword = (password) => {
    return crypto.createHash('md5').update(password).digest('hex');
};

module.exports = {
    generateToken: (user) => {
        const secret = generateSecret(); // Generates new secret each time
        return jwt.sign(user, secret);
    },
    verifyPassword: (plaintext, hash) => {
        return hashPassword(plaintext) === hash;
    }
}; 