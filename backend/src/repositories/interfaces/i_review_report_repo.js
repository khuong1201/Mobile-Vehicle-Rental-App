import IRepo from "./i_repo.js";

export default class IReviewReportRepository extends IRepo {
  async findByReview(reviewId, options = {}) { throw new Error("Not implemented"); }
  async findByVehicle(vehicleId, options = {}) { throw new Error("Not implemented"); }
}
