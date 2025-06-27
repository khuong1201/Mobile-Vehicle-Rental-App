const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();
const passport = require('passport');
const authController = require('../../controllers/auth/authController');
const  authenticateToken  = require('../../middlewares/auth_middleware');

router.post('/register', authController.Register);
router.post('/login', authController.Login);
router.post('/web-login', authController.WebLogin);
router.post('/verify', authController.Verify);
router.post('/refresh-token', authController.Refresh);
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));
router.get('/google/callback', 
    passport.authenticate('google', { failureRedirect: '/login' }),
    (req, res) => {
        const user = req.user;
        const token = jwt.sign(
            { id: user._id, userId: user.userId, email: user.email, role: user.role },
            process.env.JWT_SECRET || 'your_jwt_secret',
            { expiresIn: process.env.ACCESS_TOKEN_EXPIRES || '15m' }
        );
        res.redirect(`http://localhost:5000?token=${token}`);
    }
);
router.post('/google-login', authController.GoogleLogin);
router.post('/google-login-endpoint', authController.GoogleLoginEndPoint);
router.post('/logout', authenticateToken, authController.Logout);
router.post('/request-password-reset', authController.RequestPasswordReset);
router.post('/reset-password', authController.ResetPassword);

module.exports = router;