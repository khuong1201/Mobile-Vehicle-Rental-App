const authService = require('../../services/auth_service');
const User = require('../../models/user_model');
const Register = async (req, res) => {
    try {
        const { email, password, fullName } = req.body;
        const user = await authService.registerUser({ email, password, fullName });
        res.status(201).json({ message: 'Registration successful. Please check your email for the OTP.'});
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};
const WebLogin = async (req, res) => {
    try {
      const { email, password } = req.body;
      const result = await authService.loginUser({ email, password });
  
      res
        .cookie('accessToken', result.accessToken, {
          httpOnly: true,
          secure: false, // Đặt true nếu dùng HTTPS
          sameSite: 'Lax',
          maxAge: 15 * 60 * 1000, // 15 phút
        })
        .cookie('refreshToken', result.refreshToken, {
          httpOnly: true,
          secure: false,
          sameSite: 'Lax',
          maxAge: 7 * 24 * 60 * 60 * 1000, // 7 ngày
        })
        .json({
          message: 'Đăng nhập thành công',
          user: result.user,
        });
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  };
  
const Login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const result = await authService.loginUser({ email, password });
        res.json(result);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const Verify = async (req, res) => {
    try {
        const { email, otp } = req.body;
        await authService.verifyEmail({ email, otp });
        res.json({ message: 'Email verified successfully' });
        
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const Refresh = async (req, res) => {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
            return res.status(400).json({ message: 'Refresh token required' });
        }
        const result = await authService.refreshAccessToken(refreshToken);
        res.json(result);
    } catch (err) {
        res.status(401).json({ message: err.message });
    }
};
const GoogleLoginEndPoint = async (req, res) => {
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
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }
  };
const GoogleLogin = async (req, res) => {
    try {
        const { idToken } = req.body;
        if (!idToken) {
            return res.status(400).json({ message: 'Google ID token required' });
        }
        const result = await authService.googleLogin(idToken);
        res.json(result);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const Logout = async (req, res) => {
    try {
        await authService.logoutUser(req.user.id);
        res.json({ message: 'Logged out successfully' });
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const RequestPasswordReset = async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({ message: 'Email is required' });
        }
        await authService.requestPasswordReset(email);
        res.json({ message: 'Password reset OTP sent to email' });
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const ResetPassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        if (!email || !otp || !newPassword) {
            return res.status(400).json({ message: 'Email, OTP, and new password are required' });
        }
        await authService.resetPassword({ email, otp, newPassword });
        res.json({ message: 'Password reset successfully' });
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

module.exports = { Register, Login, WebLogin, Verify, Refresh, GoogleLoginEndPoint, GoogleLogin, Logout, RequestPasswordReset, ResetPassword };