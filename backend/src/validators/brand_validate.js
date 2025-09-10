import AppError from "../utils/app_error.js";

export default class BrandValidator {
  validateCreate({ brandName, file }) {
    if (!brandName || typeof brandName !== "string" || !brandName.trim()) {
      throw new AppError("Brand name is required", 400);
    }
    if (!file) {
      throw new AppError("Brand logo is required", 400);
    }
    return true;
  }

  validateUpdate({ brandName }) {
    if (brandName && (typeof brandName !== "string" || !brandName.trim())) {
      throw new AppError("Brand name must be a valid string", 400);
    }
    return true;
  }

  validateId(id) {
    if (!id || typeof id !== "string") {
      throw new AppError("Invalid brand ID", 400);
    }
    return true;
  }
}
