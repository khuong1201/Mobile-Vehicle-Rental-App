// controllers/booking_controller.js
import AppError from "../utils/app_error.js";
import asyncHandler from "../middlewares/async_handler.js";

export default class BookingController {
  constructor(bookingService) {
    this.bookingService = bookingService;

    // bind methods
    this.createBooking = asyncHandler(this.createBooking.bind(this));
    this.getBookingById = asyncHandler(this.getBookingById.bind(this));
    this.getUserBookings = asyncHandler(this.getUserBookings.bind(this));
    this.getVehicleBookings = asyncHandler(this.getVehicleBookings.bind(this));
    this.getActiveBookings = asyncHandler(this.getActiveBookings.bind(this));
    this.getPastBookings = asyncHandler(this.getPastBookings.bind(this));
    this.updateBookingStatus = asyncHandler(this.updateBookingStatus.bind(this));
    this.approveBooking = asyncHandler(this.approveBooking.bind(this));
    this.rejectBooking = asyncHandler(this.rejectBooking.bind(this));
    this.cancelBooking = asyncHandler(this.cancelBooking.bind(this));
    this.startBooking = asyncHandler(this.startBooking.bind(this));
    this.completeBooking = asyncHandler(this.completeBooking.bind(this));
    this.deleteBooking = asyncHandler(this.deleteBooking.bind(this));
  }

  async createBooking(req, res) {
    const renterId = req.user.userId;
    const booking = await this.bookingService.createBooking(renterId, req.body);
    res.status(201).json({ status: "success", data: booking });
  }

  async getBookingById(req, res) {
    const booking = await this.bookingService.getBookingById(req.params.bookingId);
    if (!booking) throw new AppError("Booking not found", 404);
    res.json({ status: "success", data: booking });
  }

  async getUserBookings(req, res) {
    const bookings = await this.bookingService.getUserBookings(req.user.userId);
    res.json({ status: "success", results: bookings.length, data: bookings });
  }

  async getVehicleBookings(req, res) {
    const bookings = await this.bookingService.getVehicleBookings(req.params.vehicleId, req.user);
    res.json({ status: "success", results: bookings.length, data: bookings });
  }

  async getActiveBookings(req, res) {
    const bookings = await this.bookingService.getActiveBookings(req.user.userId);
    res.json({ status: "success", results: bookings.length, data: bookings });
  }

  async getPastBookings(req, res) {
    const bookings = await this.bookingService.getPastBookings(req.user.userId);
    res.json({ status: "success", results: bookings.length, data: bookings });
  }

  async updateBookingStatus(req, res) {
    const updated = await this.bookingService.updateBookingStatus(
      req.params.bookingId,
      req.body.status, 
      req.user.userId
    );
    res.json({ status: "success", data: updated });
  }

  async approveBooking(req, res) {
    const booking = await this.bookingService.approveBooking(
      req.params.bookingId,
      req.user.userId
    );
    res.json({ status: "success", data: booking });
  }

  async rejectBooking(req, res) {
    const booking = await this.bookingService.rejectBooking(
      req.params.bookingId,
      req.user.userId
    );
    res.json({ status: "success", data: booking });
  }

  async cancelBooking(req, res) {
    const booking = await this.bookingService.cancelBooking(
      req.params.bookingId,
      req.user.userId
    );
    res.json({ status: "success", data: booking });
  }

  async startBooking(req, res) {
    const booking = await this.bookingService.startBooking(
      req.params.bookingId,
      req.user.userId
    );
    res.json({ status: "success", data: booking });
  }

  async completeBooking(req, res) {
    const booking = await this.bookingService.completeBooking(
      req.params.bookingId,
      req.user.userId
    );
    res.json({ status: "success", data: booking });
  }

  async deleteBooking(req, res) {
    await this.bookingService.deleteBooking(req.user.userId, req.params.bookingId);
    res.json({ status: "success", message: "Booking deleted successfully" });
  }
}
