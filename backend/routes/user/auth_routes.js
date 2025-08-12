const express = require('express');
const router = express.Router();
const userAuthController = require('../../controllers/user/change_password_controller');

router.post('/change-password', userAuthController.changePassword);

module.exports = router;