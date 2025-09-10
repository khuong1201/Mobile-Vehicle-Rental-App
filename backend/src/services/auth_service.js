import jwt from "jsonwebtoken";
import env from "../config/env.js";
import { OAuth2Client } from "google-auth-library";
import { hash, compare } from "../utils/hash.js";
import otpUtil from "../utils/otp_genarate.js";
import AppError from "../utils/app_error.js";
import { generateAccessToken, generateRefreshToken } from '../utils/jwt.js';

export default class UserAuthService {
  constructor(userRepo, otpService, notificationService, AuthValidator) {
    this.userRepo = userRepo;
    this.otpService = otpService;
    this.notificationService = notificationService;
    this.googleClient = new OAuth2Client(env.GOOGLE_CLIENT_ID);
    this.validator = AuthValidator;
  }

  async register(payload) {
    const { email, password, fullName } = payload;
    this.validator.validateRegister({ email, password, fullName });
    const existingUser = await this.userRepo.findByEmail(email);
    if (existingUser) throw new AppError("Email exists", 409);
    const hashedPassword = await hash(password, 10);
    const user = await this.userRepo.create({
      email,
      fullName,
      passwordHash: hashedPassword,
      role: "renter",
      verified: false,
    });
    try {
      const otp = otpUtil.generateOtp();
      await this.otpService.createOtp(email, otp);
      const notification = await this.notificationService.createNotification({
        userId: user.userId,
        channel: "email",
        destination: email,
        subject: "Your OTP Code",
        body: `Your OTP code is ${otp}`,
      });
      await this.notificationService.sendNotification(notification);
    } catch (err) {
      await this.userRepo.deleteById(user.userId);
      throw new AppError(`Registration failed: ${err.message}`, 500);
    }
    return { message: "User registered, please check email for OTP" };
  }

  async login(email, password) {
    this.validator.validateLogin({ email, password });
    const user = await this.userRepo.findByEmail(email);
    if (!user) throw new AppError("User not found", 404);
    if (!user.verified) throw new AppError("User not verified", 403);
    const isValid = await compare(password, user.passwordHash);
    if (!isValid) throw new AppError("Invalid password", 401);
    const data = await this.userRepo.getProfile(user.userId);

    const refreshToken = generateRefreshToken(user);
    await this.userRepo.updateById(user.userId, { refreshToken });
    return {
      data,
      accessToken: generateAccessToken(user),
      refreshToken,
    };
  }

  async verifyOtp(email, otpCode) {
    this.validator.validateOtp({ email, otp: otpCode });
    const user = await this.userRepo.findByEmail(email);
    if (!user) throw new AppError("User not found", 404);
    await this.otpService.verifyOtp(email, otpCode);
    user.verified = true;
    await this.userRepo.updateById(user.userId, user);
    return { message: "User verified successfully" };
  }

  async googleLogin(tokenId) {
    this.validator.validateGoogleLogin({ tokenId });
    const ticket = await this.googleClient.verifyIdToken({
      idToken: tokenId,
      audience: env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { email, name, sub: googleId, picture } = payload;
    let user = await this.userRepo.findByEmail(email);
    if (!user) {
      user = await this.userRepo.create({
        email,
        fullName: name,
        googleId,
        avatar: picture,
        role: "renter",
        verified: true,
      });
    }
    const refreshToken = generateRefreshToken(user);
    await this.userRepo.updateById(user.userId, { refreshToken });
    return {
      user,
      accessToken: generateAccessToken(user),
      refreshToken,
    };
  }

  async logout(userId) {
    this.validator.validateLogout({ userId });
    await this.userRepo.updateById(userId, { refreshToken: null });
    return { message: "User logged out successfully" };
  }

  async refreshToken(refreshToken) {
    if (!refreshToken) throw new AppError("Refresh token required", 400);
    const decoded = jwt.verify(refreshToken, env.JWT_REFRESH_SECRET);
    const user = await this.userRepo.findById(decoded.userId);
    if (!user) throw new AppError("User not found", 404);
    if (user.refreshToken !== refreshToken)
      throw new AppError("Invalid refresh token", 401);
    const newRefreshToken = generateRefreshToken(user);
    await this.userRepo.updateById(user.userId, { refreshToken: newRefreshToken });
    return {
      accessToken: generateAccessToken(user),
      refreshToken: newRefreshToken,
    };
  }
}
