import AppError from "../utils/app_error.js";

export default class DeviceValidator {
  validateCreate(payload) {
    const { imei, vehicleId } = payload;
    if (!imei || typeof imei !== "string" || imei.trim() === "") {
      throw new AppError("IMEI is required and must be a non-empty string.", 400);
    }
    if (vehicleId !== undefined && typeof vehicleId !== "string") {
      throw new AppError("Vehicle ID must be a string.", 400);
    }
    return true;
  }

  validateUpdate(payload) {
    if (!payload || typeof payload !== "object" || Object.keys(payload).length === 0) {
      throw new AppError("Update payload is required and must be a non-empty object.", 400);
    }
    const { imei, simNumber, vehicleId, status, deleted } = payload;
    if (imei !== undefined && typeof imei !== "string") {
      throw new AppError("IMEI must be a string.", 400);
    }
    if (simNumber !== undefined && typeof simNumber !== "string") {
      throw new AppError("SIM number must be a string.", 400);
    }
    if (vehicleId !== undefined && typeof vehicleId !== "string") {
      throw new AppError("Vehicle ID must be a string.", 400);
    }
    const validStatuses = ["active", "inactive"];
    if (status !== undefined && (!validStatuses.includes(status) || typeof status !== "string")) {
      throw new AppError("Status must be either 'active' or 'inactive'.", 400);
    }
    if (deleted !== undefined && typeof deleted !== "boolean") {
      throw new AppError("Deleted status must be a boolean.", 400);
    }
    return true;
  }
}
