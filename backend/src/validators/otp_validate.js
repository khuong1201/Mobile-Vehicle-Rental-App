import AppError from "../utils/app_error.js";

export default class OtpValidator {
  validateCreate({ identifier, code }) {
    if (!identifier) throw new AppError("User identifier is required");
    if (!code) throw new AppError("OTP code is required");
  }

  validateVerify({ identifier, code }) {
    if (!identifier) throw new AppError("User identifier is required");
    if (!code) throw new AppError("OTP code is required");
  }
}