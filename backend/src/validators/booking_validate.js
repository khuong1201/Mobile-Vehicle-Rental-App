import AppError from "../utils/app_error.js";

export default class BookingValidator {
  validateCreate(payload) {
    const {
      vehicleId,
      pickupDateTime,
      dropoffDateTime,
      pickupLocation,
      dropoffLocation,
    } = payload;

    if (!vehicleId || typeof vehicleId !== "string") {
      throw new AppError("vehicleId is required", 400);
    }

    if (!pickupDateTime || !dropoffDateTime) {
      throw new AppError("pickupDateTime and dropoffDateTime are required", 400);
    }

    const pickup = new Date(pickupDateTime);
    const dropoff = new Date(dropoffDateTime);

    if (isNaN(pickup.getTime()) || isNaN(dropoff.getTime())) {
      throw new AppError("Invalid date format for pickup or dropoff", 400);
    }

    if (dropoff <= pickup) {
      throw new AppError("dropoffDateTime must be after pickupDateTime", 400);
    }

    if (pickup < new Date()) {
      throw new AppError("pickupDateTime cannot be in the past", 400);
    }

    if (pickupLocation && typeof pickupLocation !== "string") {
      throw new AppError("pickupLocation must be a string", 400);
    }

    if (dropoffLocation && typeof dropoffLocation !== "string") {
      throw new AppError("dropoffLocation must be a string", 400);
    }
  }

  validateUpdateStatus(payload) {
    const { status } = payload;
    const allowedStatuses = ["pending", "approved", "rejected", "completed"];

    if (!status || !allowedStatuses.includes(status)) {
      throw new AppError(
        `Invalid status. Allowed: ${allowedStatuses.join(", ")}`,
        400
      );
    }
  }
}
