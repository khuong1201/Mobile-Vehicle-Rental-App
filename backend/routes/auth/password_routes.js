const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/auth_controller');

router.post('/request-password-reset', authController.RequestPasswordReset);

router.post('/reset-password', authController.ResetPassword);

module.exports = router;
