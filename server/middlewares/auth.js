
const jwt = require('jsonwebtoken');
const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token').replace('Bearer ', '');

        if(!token) {
            return res.status(401).json({data: 'Please authenticate'});
        }
        const verified = jwt.verify(token, 'passwordtest');

        if(!verified) {
            return res.status(401).json({data: 'Please authenticate'});
        }
        req.user = verified.id;
        req.token = token;
        next();


    } catch (error) {
        res.status(500).json({error: error.message});
    }
}

module.exports = auth;