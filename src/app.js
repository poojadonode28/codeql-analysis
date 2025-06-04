const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');
const rateLimit = require('express-rate-limit');
const xss = require('xss');

// Configure rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // Limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.'
});

app.use(express.json());
app.use(limiter); // Apply rate limiting to all routes

// Example endpoint with security fixes
app.post('/api/user', (req, res) => {
    const userData = req.body;
    
    // Fix SQL Injection by using parameterized queries
    // Example using prepared statements (you should use your database library's prepared statements)
    const query = {
        text: 'SELECT * FROM users WHERE id = $1',
        values: [userData.id]
    };
    
    // Fix path traversal by sanitizing and restricting the file path
    const userFilename = userData.filename;
    // Only allow access to specific directory
    const safeDirectory = path.join(__dirname, 'safe_files');
    const safePath = path.join(safeDirectory, path.basename(userFilename));
    
    // Verify the resolved path is within the safe directory
    if (!safePath.startsWith(safeDirectory)) {
        return res.status(403).send('Access denied');
    }

    fs.readFile(safePath, (err, data) => {
        if (err) {
            res.status(500).send('Error reading file');
            return;
        }
        res.send(data);
    });
});

// Fix XSS vulnerability
app.get('/api/message', (req, res) => {
    const userInput = req.query.message;
    // Sanitize user input to prevent XSS
    const sanitizedMessage = xss(userInput);
    res.send(`<div>${sanitizedMessage}</div>`);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
}); 