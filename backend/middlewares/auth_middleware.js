const jwt = require('jsonwebtoken');
const User = require('../models/user_model');
require('dotenv').config();

module.exports = async function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) {
    console.log('No token provided');
    return res.status(401).json({ error: 'Access token missing' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log('Decoded token:', decoded);
    
    const user = await User.findById(decoded.id);
    if (!user) {
      console.log('User not found for id:', decoded.id);
      return res.status(404).json({ error: 'User not found' });
    }

    req.user = decoded;
    next();
  } catch (err) {
    console.error('JWT Verify Error:', err.name, err.message);
    return res.status(403).json({ error: 'Invalid or expired token' });
  }
};