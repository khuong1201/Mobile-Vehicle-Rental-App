const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/auth_controller');
const authenticateToken = require('../../middlewares/auth_middleware');

router.post('/register', authController.Register);
router.post('/login', authController.Login);
router.post('/web-login', authController.WebLogin);
router.post('/verify', authController.Verify);

router.post('/refresh-token', authController.Refresh);
router.post('/refresh-web-token', authController.RefreshWebToken);

router.post('/logout', authenticateToken, authController.Logout);

module.exports = router;
