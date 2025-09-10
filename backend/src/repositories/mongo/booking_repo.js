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
    return Booking.findOneAndUpdate(
      { bookingId: id, deleted: false },
      data,
      { new: true }
    );
  }

  async delete(id) {
    return Booking.findOneAndUpdate(
      { bookingId: id },
      { deleted: true },
      { new: true }
    );
  }

  async findByUserId(userId) {
    return this.find({ renterId: userId });
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
