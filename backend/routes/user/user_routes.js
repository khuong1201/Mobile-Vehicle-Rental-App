const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middlewares/auth_middleware');

router.use(authenticateToken);
router.use('/auth', require('./auth_routes'));
router.use('/profile', require('./profile_routes'));
router.use('/license', require('./license_routes'));
router.use('/address', require('./address_routes'));
router.use('/role', require('./role_routes'));
router.use('/place', require('./place_routes'));
router.use('/revenue', require('./revenue_routes'));

module.exports = router;
