const express = require('express');
const User = require('../models/user');
const jwt = require('jsonwebtoken');
const router = express.Router();
const auth = require('../middlewares/auth');

router.post('/api/signup', async (req, res) => {
    try {
        const { email, name, profilePic } = req.body;    
        
        let user = await User.findOne({email: email});

        if (!user) {
            user = new User({
                email,
                name,
                profilePic
            });
            user = await user.save();
        } 

        const token = jwt.sign({id: user._id}, "passwordtest");
        res.json({user, token});
    
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

router.get('/', auth, async (req, res)=> {
    const user = await User.findById(req.user);
    res.json({user, token: req.token});
});

module.exports = router;