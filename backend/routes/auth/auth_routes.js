const express = require('express');
const router = express.Router();

router.use('/', require('./local_routes'));
router.use('/oauth', require('./oauth_routes'));
router.use('/password', require('./password_routes'));

module.exports = router;
