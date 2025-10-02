import AppError from "../utils/app_error.js";
import { bookingTransitions } from "../state/booking_transitions.js";
export default class BookingService {
  constructor(bookingRepo, vehicleRepo, bookingValidator, notificationService) {
    this.bookingRepo = bookingRepo;
    this.vehicleRepo = vehicleRepo;
    this.validator = bookingValidator;
    this.notificationService = notificationService;
  }

  async createBooking(userId, payload) {
    this.validator.validateCreate(payload);

    const vehicle = await this.vehicleRepo.findByVehicleId(payload.vehicleId);
    if (!vehicle) throw new AppError("Vehicle not found", 404);
    if (!vehicle.available) throw new AppError("Vehicle not available", 400);

    const pickup = new Date(payload.pickupDateTime);
    const dropoff = new Date(payload.dropoffDateTime);
    if (dropoff <= pickup)
      throw new AppError("Dropoff must be after pickup", 400);

    const days = Math.ceil((dropoff - pickup) / (1000 * 60 * 60 * 24));
    const basePrice = vehicle.price * days;
    const taxRate = vehicle.taxRate || 0;
    const taxAmount = basePrice * taxRate;
    const totalPrice = basePrice + taxAmount;

    const booking = await this.bookingRepo.create({
      ...payload,
      renterId: userId,
      ownerId: vehicle.ownerId,
      basePrice,
      taxRate,
      taxAmount,
      totalPrice,
      status: "pending",
    });

    await this.notificationService.createNotification({
      userId: vehicle.ownerId,
      channel: "push",
      subject: "New booking request",
      body: `You have a new booking request for your vehicle ${vehicle.vehicleName}.`,
      destination: null,
      meta: { bookingId: booking.bookingId, vehicleId: vehicle.vehicleId },
      pushPayload: {
        type: "bookingByRental",
        bookingId: booking.bookingId,
        vehicleId: vehicle.vehicleId,
      },
    });

    return booking;
  }

  async getBookingById(id) {
    return this.bookingRepo.findByBookingId(id);
  }


  async getUserBookings(userId, status, page = 1, limit = 10) {
    return this.bookingRepo.findByUserId(userId, status, page, limit);
  }

  async getVehicleBookings(vehicleId, user) {
    const vehicle = await this.vehicleRepo.findById(vehicleId);
    if (!vehicle) throw new AppError("Vehicle not found", 404);

    if (
      ["admin"].includes(user.role) ||
      vehicle.ownerId.toString() === user.userId.toString()
    ) {
      return this.bookingRepo.findByVehicleId(vehicleId);
    }
    throw new AppError("Not authorized", 403);
  }

  async getActiveBookings(userId) {
    return this.bookingRepo.findByUserIdWithStatus(userId, [
      "approved",
      "active",
    ]);
  }

  async getPastBookings(userId) {
    return this.bookingRepo.findByUserIdWithStatus(userId, [
      "completed",
      "rejected",
      "cancelled",
      "expired",
    ]);
  }

  async updateBookingStatus(bookingId, status, userId) {
    const booking = await this.bookingRepo.findByBookingId(bookingId);
    if (!booking) throw new AppError("Booking not found", 404);

    const currentStatus = booking.status;
    const transitions = bookingTransitions[currentStatus] || {};
    const transitionRule = transitions[status];

    if (!transitionRule) {
      throw new AppError(
        `Cannot transition from ${currentStatus} to ${status}`,
        400
      );
    }

    if (
      transitionRule.role === "owner" &&
      booking.ownerId.toString() !== userId.toString()
    ) {
      throw new AppError("Not authorized", 403);
    }
    if (
      transitionRule.role === "renter" &&
      booking.renterId.toString() !== userId.toString()
    ) {
      throw new AppError("Not authorized", 403);
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
    const booking = await this.updateBookingStatus(
      bookingId,
      "approved",
      ownerId
    );
    await this.notificationService.createNotification({
      userId: booking.renterId,
      channel: "push",
      subject: "Booking approved",
      body: `Your booking for vehicle ${booking.vehicleId} has been approved.`,
      destination: null,
      meta: { bookingId: booking._id },
    });
    return booking;
  }

  async rejectBooking(bookingId, ownerId) {
    const booking = await this.updateBookingStatus(
      bookingId,
      "rejected",
      ownerId
    );

    await this.notificationService.createNotification({
      userId: booking.renterId,
      channel: "push",
      subject: "Booking rejected",
      body: `Your booking for vehicle ${booking.vehicleId} has been rejected.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    return booking;
  }

  async cancelBooking(bookingId, renterId) {
    const booking = await this.updateBookingStatus(
      bookingId,
      "cancelled",
      renterId
    );

    await this.notificationService.createNotification({
      userId: booking.ownerId,
      channel: "push",
      subject: "Booking cancelled",
      body: `The booking for your vehicle ${booking.vehicleId} has been cancelled by renter.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    return booking;
  }

  async startBooking(bookingId, ownerId) {
    const booking = await this.updateBookingStatus(
      bookingId,
      "active",
      ownerId
    );

    await this.notificationService.createNotification({
      userId: booking.renterId,
      channel: "push",
      subject: "Trip started",
      body: `Your trip for vehicle ${booking.vehicleId} has officially started.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    return booking;
  }

  async completeBooking(bookingId, ownerId) {
    const booking = await this.updateBookingStatus(
      bookingId,
      "completed",
      ownerId
    );

    await this.notificationService.createNotification({
      userId: booking.renterId,
      channel: "push",
      subject: "Booking completed",
      body: `Your booking for vehicle ${booking.vehicleId} has been marked as completed.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    return booking;
  }

  async expireBooking(bookingId) {
    const booking = await this.updateBookingStatus(
      bookingId,
      "expired",
      "system"
    );

    await this.notificationService.createNotification({
      userId: booking.renterId,
      channel: "push",
      subject: "Booking expired",
      body: `Your booking for vehicle ${booking.vehicleId} has expired because the pickup time passed.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    await this.notificationService.createNotification({
      userId: booking.ownerId,
      channel: "push",
      subject: "Booking expired",
      body: `The booking for your vehicle ${booking.vehicleId} has expired because the renter did not start in time.`,
      destination: null,
      meta: { bookingId: booking._id },
    });

    await this.vehicleRepo.update(booking.vehicleId, { available: true });
    return booking;
  }

  async deleteBooking(userId, bookingId) {
    const booking = await this.bookingRepo.findByBookingId(bookingId);
    if (!booking) throw new AppError("Booking not found", 404);

    if (
      booking.renterId.toString() !== userId &&
      booking.ownerId.toString() !== userId
    ) {
      throw new AppError("Not authorized to delete this booking", 403);
    }

    await this.bookingRepo.delete(bookingId);
    return true;
  }
}
