import IBookingRepository from "../interfaces/i_booking_repo.js";
import Booking from "../../models/booking_model.js";
import AppError from "../../utils/app_error.js";

export default class BookingRepositoryMongo extends IBookingRepository {
  async findByBookingId(bookingId) {
    return Booking.findOne({ bookingId, deleted: false });
  }

  async find(filter = {}, options = {}) {
    return Booking.find({ ...filter, deleted: false }, null, options);
  }

  async create(data) {
    return Booking.create(data);
  }

  async update(id, data) {
    return Booking.findOneAndUpdate({ bookingId: id, deleted: false }, data, {
      new: true,
    });
  }

  async delete(id) {
    return Booking.findOneAndUpdate(
      { bookingId: id },
      { deleted: true },
      { new: true }
    );
  }

  async findByUserId(userId, status, page = 1, limit = 10) {
    const query = { renterId: userId };
    if (status) query.status = status;

    const allResults = await this.find(query); 

    const total = allResults.length;
    const totalPages = Math.ceil(total / limit);
    const skip = (page - 1) * limit;

    const results = allResults.slice(skip, skip + limit);

    return {
      results,
      total,
      page,
      limit,
      totalPages,
    };
  }

  async findByVehicleId(vehicleId) {
    return this.find({ vehicleId });
  }

  async findByUserIdWithStatus(userId, statuses) {
    return this.find({
      renterId: userId,
      status: { $in: statuses },
    });
  }

  async findExpired(now) {
    return Booking.find({
      status: { $in: ["pending", "approved"] },
      pickupDateTime: { $lt: now },
      deleted: false,
    }).lean();
  }

  async updateStatus(bookingId, status) {
    const booking = await Booking.findOneAndUpdate(
      { bookingId, deleted: false },
      { status },
      { new: true }
    );
    if (!booking) throw new AppError("Booking not found", 404);
    return booking;
  }
}
