const { OAuth2Client } = require("google-auth-library");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");
const emailService = require("./email_service");

const generateTokens = (user) => {
    const accessToken = jwt.sign(
        { id: user._id, userId: user.userId, email: user.email, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.ACCESS_TOKEN_EXPIRES || "15m" }
    );

    const refreshToken = jwt.sign(
        { id: user._id, userId: user.userId, email: user.email, role: user.role },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: process.env.REFRESH_TOKEN_EXPIRES || "7d" }
    );

    return { accessToken, refreshToken };
};

const generateOTP = () => {
    return Math.floor(10000 + Math.random() * 90000).toString();
};

const registerUser = async ({ email, password, fullName }) => {
    let user = await User.findOne({ email });
    if (user) {
        throw new Error("Email already exists");
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // OTP hết hạn sau 10 phút

    user = await User.create({
        email,
        passwordHash,
        fullName,
        verified: false,
        otp,
        otpExpires,
        role: "renter",
        points: 0,
    });

    await emailService.sendOTP({ email, otp, purpose: "registration" });

    return user;
};

const loginUser = async ({ email, password }) => {
    const user = await User.findOne({ email });
    if (!user) {
        throw new Error("Invalid credentials");
    }

    if (!user.verified) {
        throw new Error("Please verify your email first");
    }

    if (!user.passwordHash) {
        throw new Error("Please use Google login or reset your password");
    }

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
        throw new Error("Invalid credentials");
    }

    const { accessToken, refreshToken } = generateTokens(user);
    user.refreshToken = refreshToken;
    await user.save();

    return {
        accessToken,
        refreshToken,
        user: {
            id: user._id,
            userId: user.userId,
            email: user.email,
            address: undefined,
            role: user.role,
            fullName: user.fullName,
        },
    };
};

const verifyEmail = async ({ email, otp }) => {
    const user = await User.findOne({ email, otp });
    if (!user) {
        throw new Error("Invalid OTP or email");
    }

    if (user.otpExpires < Date.now()) {
        throw new Error("OTP has expired");
    }

    user.verified = true;
    user.otp = undefined;
    user.otpExpires = undefined;
    await user.save();
    return user;
};

const refreshAccessToken = async (refreshToken) => {
    try {
        const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
        const user = await User.findById(decoded.id);

        if (!user || user.refreshToken !== refreshToken) {
            throw new Error("Invalid refresh token");
        }

        const { accessToken, refreshToken: newRefreshToken } = generateTokens(user);
        user.refreshToken = newRefreshToken;
        await user.save();

        return { accessToken, refreshToken: newRefreshToken };
    } catch (err) {
        throw new Error("Invalid refresh token");
    }
};
const googleLoginEndPoint = async ({ googleId, email, fullName }) => {
    try {
      if (!googleId || !email || !fullName) {
        throw new Error('Google ID, email, and full name are required');
      }
      const normalizedEmail = email.trim().toLowerCase();
      let user = await User.findOne({
        $or: [{ googleId }, { email: normalizedEmail }],
      });
  
      if (user) {
        if (!user.googleId) {
          user.googleId = googleId;
          user.verified = true; 
          await user.save();
        }
      } else {
        user = await User.create({
          googleId,
          fullName: fullName.trim(),
          email: normalizedEmail,
          address: undefined,
          verified: true,
          role: 'renter',
          points: 0,
          license: { approved: false },
        });
      }
      const { accessToken, refreshToken } = generateTokens(user);
      user.refreshToken = refreshToken;
      await user.save();
      return {
        accessToken,
        refreshToken,
        user: {
          googleId: user.googleId,
          fullName: user.fullName,
          email: user.email,
          role: user.role,
          verified: user.verified,
        },
      };
    } catch (err) {
      console.error('Google login error:', err.message);
      throw new Error(`Google login failed: ${err.message}`);
    }
  };
const googleLogin = async (idToken) => {
    try {
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID,
        });
        const payload = ticket.getPayload();
        const { email, name, sub: googleId } = payload;

        let user = await User.findOne({ email });

        if (!user) {
            user = await User.create({
                email,
                fullName: name,
                googleId,
                verified: true,
                role: "renter",
                points: 0,
            });
        } else if (!user.googleId) {
            user.googleId = googleId;
            user.verified = true;
            await user.save();
        }

        const { accessToken, refreshToken } = generateTokens(user);
        user.refreshToken = refreshToken;
        await user.save();

        return {
            accessToken,
            refreshToken,
            user: {
                id: user._id,
                userId: user.userId,
                email: user.email,
                role: user.role,
                fullName: user.fullName,
            },
        };
    } catch (err) {
        throw new Error("Invalid Google token");
    }
};

const logoutUser = async (userId) => {
    try {
        const user = await User.findById(userId);
        if (!user) {
            throw new Error("User not found");
        }

        user.refreshToken = null;
        await user.save();
        return { message: "Logged out successfully" };
    } catch (err) {
        throw new Error(err.message);
    }
};

const requestPasswordReset = async (email) => {
    const user = await User.findOne({ email });
    if (!user) {
        throw new Error("User not found");
    }

    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + 5 * 60 * 1000); // OTP hết hạn sau 5 phút

    user.otp = otp;
    user.otpExpires = otpExpires;
    await user.save();

    await emailService.sendOTP({ email, otp, purpose: "password-reset" });

    return { message: "Password reset OTP sent to email" };
};

const resetPassword = async ({ email, otp, newPassword }) => {
    const user = await User.findOne({ email, otp });
    if (!user) {
        throw new Error("Invalid OTP or email");
    }

    if (user.otpExpires < Date.now()) {
        throw new Error("OTP has expired");
    }

    const passwordHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = passwordHash;
    user.otp = undefined;
    user.otpExpires = undefined;
    user.verified = true;
    await user.save();

    return { message: "Password reset successfully" };
};

const cleanupUnverifiedUsers = async () => {
    try {
        const currentTime = new Date();
        const expiredUsers = await User.find({
            verified: false,
            otpExpires: { $lt: currentTime },
            otp: { $exists: true, $ne: null }
        }).select('email otp otpExpires');

        if (expiredUsers.length > 0) {
            console.log(
                `Tìm thấy ${expiredUsers.length} người dùng không được xác minh với OTP hết hạn:`,
                expiredUsers.map(u => ({
                    email: u.email,
                    otp: u.otp,
                    otpExpires: u.otpExpires
                }))
            );

            // Xóa các tài liệu khớp
            const result = await User.deleteMany({
                verified: false,
                otpExpires: { $lt: currentTime },
                otp: { $exists: true, $ne: null }
            });
            console.log(`Đã xóa ${result.deletedCount} người dùng không được xác minh với OTP hết hạn`);
        } else {
            console.log("Không tìm thấy người dùng nào với OTP hết hạn để xóa.");
        }
    } catch (err) {
        console.error("Lỗi khi dọn dẹp người dùng không được xác minh:", err.message);
    }
};

module.exports = {
    registerUser,
    loginUser,
    verifyEmail,
    refreshAccessToken,
    googleLoginEndPoint,
    googleLogin,
    logoutUser,
    requestPasswordReset,
    resetPassword,
    cleanupUnverifiedUsers,
};