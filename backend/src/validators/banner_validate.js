import AppError from "../utils/app_error.js";

export default class BannerValidator {
  validateCreate(payload) {
    const { bannerName } = payload;
    if (!bannerName || typeof bannerName !== "string" || bannerName.trim() === "") {
      throw new AppError("Banner name is required and must be a non-empty string", 400);
    }
    return true;
  }

  validateUpdate(payload) {
    if (payload.bannerName && (typeof payload.bannerName !== "string" || payload.bannerName.trim() === "")) {
      throw new AppError("Banner name must be a non-empty string", 400);
    }
    return true;
  }
}
