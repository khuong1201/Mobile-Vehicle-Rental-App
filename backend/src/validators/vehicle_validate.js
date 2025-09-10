import AppError from "../utils/app_error.js";

export default class VehicleValidator {
  validateCreate(payload) {
    const {
      licensePlate,
      brandId,
      model,
      price,
      yearOfManufacture,
      status,
      location,
      bankAccount,
      vehicleName
    } = payload;

    if (!licensePlate || typeof licensePlate !== "string") {
      throw new AppError("licensePlate is required and must be a string", 400);
    }
    if (!brandId || typeof brandId !== "string") {
      throw new AppError("brandId is required and must be a string", 400);
    }
    if (!model || typeof model !== "string") {
      throw new AppError("model is required and must be a string", 400);
    }
    if (!price || typeof price !== "number" || price < 0) {
      throw new AppError("price is required and must be a positive number", 400);
    }
    if (!vehicleName || typeof vehicleName !== "string") {
      throw new AppError("vehicleName is required and must be a string", 400);
    }

    if (yearOfManufacture && (typeof yearOfManufacture !== "number" || yearOfManufacture < 1900 || yearOfManufacture > new Date().getFullYear())) {
      throw new AppError("Invalid yearOfManufacture. Must be a number between 1900 and the current year.", 400);
    }

    if (status) {
      const allowedStatuses = ["pending", "rejected", "approved"];
      if (!allowedStatuses.includes(status)) {
        throw new AppError(`Invalid status. Allowed: ${allowedStatuses.join(", ")}`, 400);
      }
    }

    if (location) {
      if (typeof location !== "object" || !location.coordinates || !Array.isArray(location.coordinates) || location.coordinates.length !== 2) {
        throw new AppError("location must be an object with a coordinates array of two numbers", 400);
      }
    }

    if (bankAccount) {
      if (typeof bankAccount !== "object" || !bankAccount.accountNumber || !bankAccount.bankName || !bankAccount.accountHolderName) {
        throw new AppError("bankAccount must be an object with accountNumber, bankName, and accountHolderName", 400);
      }
    }
  }

  validateUpdate(payload) {
    const {
      licensePlate,
      model,
      price,
      yearOfManufacture,
      status,
      available,
      location,
      bankAccount,
      vehicleName,
      averageRating,
      reviewCount
    } = payload;

    if (licensePlate !== undefined && typeof licensePlate !== "string") {
      throw new AppError("licensePlate must be a string", 400);
    }
    if (model !== undefined && typeof model !== "string") {
      throw new AppError("model must be a string", 400);
    }
    if (price !== undefined && (typeof price !== "number" || price < 0)) {
      throw new AppError("price must be a positive number", 400);
    }
    if (vehicleName !== undefined && typeof vehicleName !== "string") {
      throw new AppError("vehicleName must be a string", 400);
    }

    if (yearOfManufacture !== undefined && (typeof yearOfManufacture !== "number" || yearOfManufacture < 1900 || yearOfManufacture > new Date().getFullYear())) {
      throw new AppError("Invalid yearOfManufacture. Must be a number between 1900 and the current year.", 400);
    }

    if (status !== undefined) {
      const allowedStatuses = ["pending", "rejected", "approved", "completed", "cancelled"];
      if (!allowedStatuses.includes(status)) {
        throw new AppError(`Invalid status. Allowed: ${allowedStatuses.join(", ")}`, 400);
      }
    }

    if (available !== undefined && typeof available !== "boolean") {
      throw new AppError("available must be a boolean", 400);
    }

    if (averageRating !== undefined && (typeof averageRating !== "number" || averageRating < 0 || averageRating > 5)) {
      throw new AppError("averageRating must be a number between 0 and 5", 400);
    }

    if (reviewCount !== undefined && (typeof reviewCount !== "number" || reviewCount < 0)) {
      throw new AppError("reviewCount must be a non-negative number", 400);
    }

    if (location !== undefined) {
      if (typeof location !== "object" || !location.coordinates || !Array.isArray(location.coordinates) || location.coordinates.length !== 2) {
        throw new AppError("location must be an object with a coordinates array of two numbers", 400);
      }
    }

    if (bankAccount !== undefined) {
      if (typeof bankAccount !== "object" || !bankAccount.accountNumber || !bankAccount.bankName || !bankAccount.accountHolderName) {
        throw new AppError("bankAccount must be an object with accountNumber, bankName, and accountHolderName", 400);
      }
    }
  }
}
