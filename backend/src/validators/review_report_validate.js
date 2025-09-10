import AppError from "../utils/app_error.js";

export default class ReviewReportValidator {
  validateCreate({ reviewId, reason }) {
    if (!reviewId) throw new AppError("reviewId is required", 400);
    if (!reason || reason.trim() === "") throw new AppError("reason is required", 400);
  }

  validateUpdateStatus({ status }) {
    const validStatuses = ["pending", "reviewed", "rejected"];
    if (!status) throw new AppError("status is required", 400);
    if (!validStatuses.includes(status)) {
      throw new AppError("Invalid status", 400);
    }
  }
}
