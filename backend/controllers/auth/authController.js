const authService = require('../../services/auth_service');

const register = async (req, res) => {
    try {
        const { email, password, fullName } = req.body;
        const user = await authService.registerUser({ email, password, fullName });
        res.status(201).json({ message: 'Registration successful. Please check your email for the OTP.'});
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const result = await authService.loginUser({ email, password });
        res.json(result);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const verify = async (req, res) => {
    try {
        const { email, otp } = req.body;
        await authService.verifyEmail({ email, otp });
        res.json({ message: 'Email verified successfully' });
        
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const refresh = async (req, res) => {
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

const googleLogin = async (req, res) => {
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

const logout = async (req, res) => {
    try {
        await authService.logoutUser(req.user.id);
        res.json({ message: 'Logged out successfully' });
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const requestPasswordReset = async (req, res) => {
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

const resetPassword = async (req, res) => {
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

module.exports = { register, login, verify, refresh, googleLogin, logout, requestPasswordReset, resetPassword };