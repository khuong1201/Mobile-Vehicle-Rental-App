const express = require('express');
const router = express.Router();
const passport = require('passport');
const authController = require('../../controllers/auth/auth_controller');

router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

router.get(
  '/google/callback',
  passport.authenticate('google', { failureRedirect: '/login' }),
  authController.GoogleOAuthCallback
);

router.post('/google-login', authController.GoogleLogin);
router.post('/google-login-endpoint', authController.GoogleLoginEndPoint);

module.exports = router;
