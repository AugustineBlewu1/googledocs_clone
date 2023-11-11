const express = require('express');

const router = express.Router();

router.post('/api/signup', async (req, res) => {
    try {
        const { email, name, profilePic } = req.body;    
    } catch (error) {
        
    }
});