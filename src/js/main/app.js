const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');
const jwt = require('jsonwebtoken');

app.use(express.json());

// SECURITY ISSUE 1: Hardcoded secret
const JWT_SECRET = 'mysecretkey123';

// SECURITY ISSUE 2: SQL Injection vulnerability
app.get('/api/users/:id', (req, res) => {
    const query = `SELECT * FROM users WHERE id = ${req.params.id}`;
    // Execute query...
    res.send('Query executed');
});

// SECURITY ISSUE 3: Path Traversal vulnerability
app.get('/api/files/:filename', (req, res) => {
    const filePath = path.join(__dirname, req.params.filename);
    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.status(500).send('Error reading file');
            return;
        }
        res.send(data);
    });
});

// SECURITY ISSUE 4: XSS vulnerability
app.get('/api/message', (req, res) => {
    const userInput = req.query.message;
    res.send(`<div>${userInput}</div>`);
});

// SECURITY ISSUE 5: Weak JWT implementation
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;
    // No password hashing
    if (username && password) {
        const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
}); 