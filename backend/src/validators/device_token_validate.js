import AppError from "../utils/app_error.js";

export default class DeviceValidator {
  validateRegisterToken(token) {
    if (!token || typeof token !== "string") {
      throw new AppError("Device token must be a non-empty string", 400);
    }
  }

  validateRemoveToken(token) {
    if (!token || typeof token !== "string") {
      throw new AppError("Device token must be a non-empty string", 400);
    }
  }
}
