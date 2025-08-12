const jwt = require('jsonwebtoken');
const authService = require('../../services/auth_service');
const AppError = require('../../utils/app_error');
const asyncHandler = require('../../utils/async_handler');

const setAuthCookies = (res, { accessToken, refreshToken }) => {
  const isProduction = process.env.NODE_ENV === 'production';
  res.cookie('accessToken', accessToken, {
    httpOnly: true,
    secure: isProduction,
    sameSite: isProduction ? 'None' : 'Lax',
    maxAge: 15 * 60 * 1000,
  });
  res.cookie('refreshToken', refreshToken, {
    httpOnly: true,
    secure: isProduction,
    sameSite: isProduction ? 'None' : 'Lax',
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });
};

const register = asyncHandler(async (req, res) => {
  const { email, password, fullName } = req.body;
  await authService.registerUser({ email, password, fullName });
  res.status(201).json({ message: 'Registration successful. Please check your email for the OTP.' });
});

const webLogin = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const result = await authService.loginUser({ email, password });
  setAuthCookies(res, result);
  res.json({ message: 'Đăng nhập thành công', user: result.user });
});

const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const result = await authService.loginUser({ email, password });
  res.json(result);
});

const verify = asyncHandler(async (req, res) => {
  const { email, otp } = req.body;
  await authService.verifyEmail({ email, otp });
  res.json({ message: 'Email verified successfully' });
});

const refreshToken = asyncHandler(async (req, res, next) => {
  const { refreshToken } = req.body;
  if (!refreshToken) return next(new AppError('Refresh token required', 400, 'REFRESH_TOKEN_REQUIRED'));
  const result = await authService.refreshAccessToken(refreshToken);
  res.json(result);
});

const refreshWebToken = asyncHandler(async (req, res, next) => {
  const refreshToken = req.cookies['refreshToken'];
  if (!refreshToken) return next(new AppError('Refresh token required', 400, 'REFRESH_TOKEN_REQUIRED'));
  const result = await authService.refreshAccessToken(refreshToken);
  setAuthCookies(res, result);
  res.json(result);
});

const googleLoginEndpoint = asyncHandler(async (req, res) => {
  const { googleId, email, fullName, avatar } = req.body;
  const result = await authService.googleLoginEndPoint({ googleId, email, fullName, avatar });
  res.status(200).json({ success: true, ...result, message: 'Đăng nhập thành công' });
});

const googleLogin = asyncHandler(async (req, res, next) => {
  const { idToken } = req.body;
  if (!idToken) return next(new AppError('Google ID token required', 400, 'GOOGLE_ID_TOKEN_REQUIRED'));
  const result = await authService.googleLogin(idToken);
  res.json(result);
});

const googleOAuthCallback = asyncHandler(async (req, res, next) => {
  const user = req.user;
  if (!user) return next(new AppError('Google OAuth thất bại', 401, 'OAUTH_FAILED'));

  const token = jwt.sign(
    { id: user._id, userId: user.userId, email: user.email, role: user.role },
    process.env.JWT_SECRET || 'your_jwt_secret',
    { expiresIn: process.env.ACCESS_TOKEN_EXPIRES || '15m' }
  );

  const redirectUrl = `${process.env.CLIENT_URL || 'http://localhost:5000'}?token=${token}`;
  res.redirect(redirectUrl);
});

const logout = asyncHandler(async (req, res) => {
  await authService.logoutUser(req.user.id);
  res.json({ message: 'Logged out successfully' });
});

const requestPasswordReset = asyncHandler(async (req, res, next) => {
  const { email } = req.body;
  if (!email) return next(new AppError('Email is required', 400, 'EMAIL_REQUIRED'));
  await authService.requestPasswordReset(email);
  res.json({ message: 'Password reset OTP sent to email' });
});

const resetPassword = asyncHandler(async (req, res, next) => {
  const { email, otp, newPassword } = req.body;
  if (!email || !otp || !newPassword)
    return next(new AppError('Email, OTP, and new password are required', 400, 'RESET_FIELDS_REQUIRED'));
  await authService.resetPassword({ email, otp, newPassword });
  res.json({ message: 'Password reset successfully' });
});

module.exports = {
  register,
  login,
  webLogin,
  verify,
  refreshToken,
  refreshWebToken,
  googleLoginEndpoint,
  googleLogin,
  googleOAuthCallback,
  logout,
  requestPasswordReset,
  resetPassword,
};
