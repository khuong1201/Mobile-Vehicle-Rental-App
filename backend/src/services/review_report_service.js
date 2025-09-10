import AppError from "../utils/app_error.js";

export default class ReviewReportService {
  constructor(reportRepo, reviewRepo, validator) {
    this.reportRepo = reportRepo;
    this.reviewRepo = reviewRepo;
    this.validator = validator;
  }

  async createReport(reporterId, payload) {
    this.validator.validateCreate(payload);

    const review = await this.reviewRepo.findById(payload.reviewId);
    if (!review) throw new AppError("Review not found", 404);

    return this.reportRepo.create({
      ...payload,
      reporterId,
      vehicleId: review.vehicleId,
    });
  }

  async getReports(options) {
    return this.reportRepo.find({}, options);
  }

  async updateReportStatus(reviewReportId, status) {
    this.validator.validateUpdateStatus({ status });
    return this.reportRepo.update(reviewReportId, { status });
  }
}