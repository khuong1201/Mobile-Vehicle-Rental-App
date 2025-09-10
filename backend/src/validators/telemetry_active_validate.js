import AppError from "../utils/app_error.js";

export default class TelemetryActiveValidator {
  validateCreate(payload) {
    if (!payload.deviceId) throw new AppError("deviceId is required", 400);
    if (!payload.location?.coordinates) throw new AppError("location.coordinates is required", 400);
    return true;
  }
}
