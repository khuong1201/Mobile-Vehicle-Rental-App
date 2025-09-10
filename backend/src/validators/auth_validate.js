import AppError from "../utils/app_error.js";

export default class AuthValidator {
    validateRegister({ email, password, fullName }) {
      if (!email) throw new AppError("Email is required");
      if (!password) throw new AppError("Password is required");
      if (!fullName) throw new AppError("Full name is required");
    }
  
    validateLogin({ email, password }) {
      if (!email) throw new AppError("Email is required");
      if (!password) throw new AppError("Password is required");
    }
  
    validateOtp({ email, otp }) {
      if (!email) throw new AppError("Email is required");
      if (!otp) throw new AppError("OTP is required");
    }
  
    validateGoogleLogin({ tokenId }) {
      if (!tokenId) throw new AppError("tokenId is required");
    }

    validateLogout({ userId }) {
      if (!userId) throw new AppError("userId is required");
    }
  }
  