import AppError from "../utils/app_error.js";

export default class TelemetryRawValidator {
  validateCreate(payload) {
    if (!payload.deviceId) throw new AppError("deviceId is required", 400);
    if (!payload.payload) throw new AppError("payload is required", 400);
    return true;
  }
}
