const authService = require('../../services/auth_service');
const Register = async (req, res, next) => {
    try {
        const { email, password, fullName } = req.body;
        const user = await authService.registerUser({ email, password, fullName });
        res.status(201).json({ message: 'Registration successful. Please check your email for the OTP.'});
    } catch (err) {
        next(err); 
    }
};
const WebLogin = async (req, res, next) => {
    try {
      const { email, password } = req.body;
      const result = await authService.loginUser({ email, password });
  
      const isProduction = process.env.NODE_ENV === 'production';
  
      res
        .cookie('accessToken', result.accessToken, {
          httpOnly: true,
          secure: isProduction, 
          sameSite: isProduction ? 'None' : 'Lax',
          maxAge: 15 * 60 * 1000, 
        })
        .cookie('refreshToken', result.refreshToken, {
          httpOnly: true,
          secure: isProduction,
          sameSite: isProduction ? 'None' : 'Lax',
          maxAge: 7 * 24 * 60 * 60 * 1000, 
        })
        .json({
          message: 'Đăng nhập thành công',
          user: result.user,
        });
    } catch (err) {
      next(err);
    }
  };
  
const Login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const result = await authService.loginUser({ email, password });
        res.json(result);
    } catch (err) {
      next(err);
    }
};

const Verify = async (req, res, next) => {
    try {
        const { email, otp } = req.body;
        await authService.verifyEmail({ email, otp });
        res.json({ message: 'Email verified successfully' });
        
    } catch (err) {
      next(err);
    }
};

const Refresh = async (req, res, next) => {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
          return next(new AppError('Refresh token required', 400, 'REFRESH_TOKEN_REQUIRED'));
        }
        const result = await authService.refreshAccessToken(refreshToken);
        res.json(result);
    } catch (err) {
      next(err);
    }
};
const RefreshWebToken = async (req, res, next) => {
    try {
      const refreshToken = req.cookies['refreshToken'];
      if (!refreshToken) return next(new AppError('Refresh token required', 400, 'REFRESH_TOKEN_REQUIRED'));
      const result = await authService.refreshAccessToken(refreshToken);
      const isProduction = process.env.NODE_ENV === 'production';
      res.cookie('accessToken', result.accessToken, {
        httpOnly: true,
        secure: isProduction,
        sameSite: isProduction ? 'None' : 'Lax',
        maxAge: 15 * 60 * 1000,
      });
      res.cookie('refreshToken', result.refreshToken, {
        httpOnly: true,
        secure: isProduction,
        sameSite: isProduction ? 'None' : 'Lax',
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });
  
      res.json({
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      });
    } catch (err) {
      next(err);
    }
  };
  
const GoogleLoginEndPoint = async (req, res, next) => {
    try {
      const { googleId, email, fullName, avatar } = req.body;
  
      const result = await authService.googleLoginEndPoint({
        googleId,
        email,
        fullName,
        avatar,
      });
  
      return res.status(200).json({
        success: true,
        ...result,
        message: 'Đăng nhập thành công',
      });
    } catch (err) {
      console.error('🔥 GoogleLoginEndPoint error:', err.message);
      next(err);
    }
  };
const GoogleLogin = async (req, res, next) => {
    try {
        const { idToken } = req.body;
        if (!idToken) return next(new AppError('Google ID token required', 400, 'GOOGLE_ID_TOKEN_REQUIRED'));
        const result = await authService.googleLogin(idToken);
        res.json(result);
    } catch (err) {
        next(err);
    }
};

const Logout = async (req, res, next) => {
    try {
        await authService.logoutUser(req.user.id);
        res.json({ message: 'Logged out successfully' });
    } catch (err) {
        next(err);
    }
};

const RequestPasswordReset = async (req, res, next) => {
    try {
        const { email } = req.body;
        if (!email) return next(new AppError('Email is required', 400, 'EMAIL_REQUIRED'));
        await authService.requestPasswordReset(email);
        res.json({ message: 'Password reset OTP sent to email' });
    } catch (err) {
      next(err);
    }
};

const ResetPassword = async (req, res, next) => {
    try {
        const { email, otp, newPassword } = req.body;
        if (!email || !otp || !newPassword) return next(new AppError('Email, OTP, and new password are required', 400, 'RESET_FIELDS_REQUIRED'));
        await authService.resetPassword({ email, otp, newPassword });
        res.json({ message: 'Password reset successfully' });
    } catch (err) {
      next(err);
    }
};

module.exports = { Register, Login, WebLogin, Verify, Refresh, RefreshWebToken, GoogleLoginEndPoint, GoogleLogin, Logout, RequestPasswordReset, ResetPassword };