import AppError from "../utils/app_error.js";

export default class BookingService {
  constructor(bookingRepo, vehicleRepo, bookingValidator) {
    this.bookingRepo = bookingRepo;
    this.vehicleRepo = vehicleRepo;
    this.validator = bookingValidator;
  }

  async createBooking(userId, payload) {
    this.validator.validateCreate(payload);

    const vehicle = await this.vehicleRepo.findByVehicleId(payload.vehicleId);
    if (!vehicle) throw new AppError("Vehicle not found", 404);
    if (!vehicle.available) throw new AppError("Vehicle not available", 400);

    const pickup = new Date(payload.pickupDateTime);
    const dropoff = new Date(payload.dropoffDateTime);
    if (dropoff <= pickup) throw new AppError("Dropoff must be after pickup", 400);

    const days = Math.ceil((dropoff - pickup) / (1000 * 60 * 60 * 24));
    const basePrice = vehicle.price * days;
    const taxRate = vehicle.taxRate || 0;
    const taxAmount = basePrice * taxRate;
    const totalPrice = basePrice + taxAmount;

    return this.bookingRepo.create({
      ...payload,
      renterId: userId,
      ownerId: vehicle.ownerId,
      basePrice,
      taxRate,
      taxAmount,
      totalPrice,
      status: "pending"
    });
  }

  async getBookingById(id) {
    return this.bookingRepo.findByBookingId(id);
  }

  async getUserBookings(userId) {
    return this.bookingRepo.findByUserId(userId);
  }

  async getVehicleBookings(vehicleId, user) {
    const vehicle = await this.vehicleRepo.findById(vehicleId);
    if (!vehicle) throw new AppError("Vehicle not found", 404);
  
    if (["admin"].includes(user.role) || vehicle.ownerId.toString() === user.userId.toString()) {
      return this.bookingRepo.findByVehicleId(vehicleId);
    }
    throw new AppError("Not authorized", 403);
  }  

  async getActiveBookings(userId) {
    return this.bookingRepo.findByUserIdWithStatus(userId, ["approved", "active"]);
  }

  async getPastBookings(userId) {
    return this.bookingRepo.findByUserIdWithStatus(userId, [
      "completed", "rejected", "cancelled", "expired"
    ]);
  }

  async updateBookingStatus(bookingId, status, userId) {
    const booking = await this.bookingRepo.findByBookingId(bookingId);
    if (!booking) throw new AppError("Booking not found", 404);

    const validStatuses = ["pending", "approved", "active", "completed", "cancelled", "rejected"];
    if (!validStatuses.includes(status)) {
      throw new AppError("Invalid status", 400);
    }

    if (status === "approved" || status === "rejected") {
      if (booking.ownerId.toString() !== userId.toString()) throw new AppError("Not authorized", 403);
      if (booking.status !== "pending") throw new AppError("Booking not pending", 400);
    } else if (status === "cancelled") {
      if (booking.renterId.toString() !== userId.toString()) throw new AppError("Not authorized", 403);
      if (["completed", "active"].includes(booking.status)) {
        throw new AppError("Cannot cancel an active or completed booking", 400);
      }
    } else if (status === "active") {
      if (booking.ownerId.toString() !== userId.toString()) throw new AppError("Not authorized", 403);
      if (booking.status !== "approved") throw new AppError("Booking not approved", 400);
    } else if (status === "completed") {
      if (booking.ownerId.toString() !== userId.toString()) throw new AppError("Not authorized", 403);
      if (booking.status !== "active") throw new AppError("Booking not active", 400);
    }

    const updated = await this.bookingRepo.updateStatus(bookingId, status);

    if (["cancelled", "rejected", "completed"].includes(status)) {
      await this.vehicleRepo.update(booking.vehicleId, { available: true });
    }
    if (status === "approved") {
      await this.vehicleRepo.update(booking.vehicleId, { available: false });
    }

    return updated;
  }

  async approveBooking(bookingId, ownerId) {
    return this.updateBookingStatus(bookingId, "approved", ownerId);
  }

  async rejectBooking(bookingId, ownerId) {
    return this.updateBookingStatus(bookingId, "rejected", ownerId);
  }

  async cancelBooking(bookingId, renterId) {
    return this.updateBookingStatus(bookingId, "cancelled", renterId);
  }

  async startBooking(bookingId, ownerId) {
    return this.updateBookingStatus(bookingId, "active", ownerId);
  }

  async completeBooking(bookingId, ownerId) {
    return this.updateBookingStatus(bookingId, "completed", ownerId);
  }

  async deleteBooking(userId, bookingId) {
    const booking = await this.bookingRepo.findByBookingId(bookingId);
    if (!booking) throw new AppError("Booking not found", 404);

    if (booking.renterId.toString() !== userId && booking.ownerId.toString() !== userId) {
      throw new AppError("Not authorized to delete this booking", 403);
    }

    await this.bookingRepo.delete(bookingId);
    return true;
  }
}
