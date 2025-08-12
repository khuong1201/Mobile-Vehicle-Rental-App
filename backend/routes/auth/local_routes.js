const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/auth_controller');
const authenticateToken = require('../../middlewares/auth_middleware');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/web-login', authController.webLogin);
router.post('/verify', authController.verify);

router.post('/refresh-token', authController.refreshToken);
router.post('/refresh-web-token', authController.refreshWebToken);

router.post('/logout', authenticateToken, authController.logout);

module.exports = router;
