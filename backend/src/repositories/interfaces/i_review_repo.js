import IRepo from "./i_repo.js";

export default class IReviewRepository extends IRepo {
  async findByVehicle(vehicleId, options = {}) { throw new Error("Not implemented"); }
  async findByRenter(renterId, options = {}) { throw new Error("Not implemented"); }
  async getAverageRating(vehicleId) { throw new Error("Not implemented"); }
}