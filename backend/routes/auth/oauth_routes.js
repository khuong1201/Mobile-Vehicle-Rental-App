const express = require('express');
const router = express.Router();
const passport = require('passport');
const authController = require('../../controllers/auth/auth_controller');

router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

router.get(
  '/google/callback',
  passport.authenticate('google', { failureRedirect: '/login' }),
  authController.googleOAuthCallback
);

router.post('/google-login', authController.googleLogin);
router.post('/google-login-endpoint', authController.googleLoginEndpoint);

module.exports = router;
