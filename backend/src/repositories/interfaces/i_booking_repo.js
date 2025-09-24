import IRepo from "./i_repo.js";

export default class IBookingRepository extends IRepo {
  async findByUserId(userId) { throw new Error("Not implemented"); }
  async findByVehicleId(vehicleId) { throw new Error("Not implemented"); }
  async findByUserIdWithStatus(userId, statuses) { throw new Error("Not implemented"); }
  async updateStatus(bookingId, status) { throw new Error("Not implemented"); }
  async findExpired(now) { throw new Error("Not implemented"); }
}
