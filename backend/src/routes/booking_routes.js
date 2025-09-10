import { Router } from "express";
import BookingController from "../controllers/booking_controller.js";
import BookingService from "../services/booking_service.js";
import getRepositories from "../repositories/index.js";
import BookingValidator from "../validators/booking_validate.js";
import authenticateJWT from "../middlewares/auth_middlerware.js";
import { authorizeRoles } from '../middlewares/role_middlerware.js';
const router = Router();

const { VehicleRepository, BookingRepository } = await getRepositories();
const validator = new BookingValidator();
const bookingService = new BookingService(
  BookingRepository,
  VehicleRepository,
  validator
);
const bookingController = new BookingController(bookingService);

router.get("/user/me", authenticateJWT, bookingController.getUserBookings);
router.get("/user/active/me", authenticateJWT, bookingController.getActiveBookings);
router.get("/user/past/me", authenticateJWT, bookingController.getPastBookings);


router.get("/vehicle/:vehicleId", authenticateJWT, authorizeRoles("admin", "owner"), bookingController.getVehicleBookings);

router.post("/", authenticateJWT, bookingController.createBooking);
router.get("/:bookingId", authenticateJWT, bookingController.getBookingById);
router.delete("/:bookingId", authenticateJWT, bookingController.deleteBooking);

router.patch("/:bookingId/status", authenticateJWT, bookingController.updateBookingStatus);
router.patch("/:bookingId/cancel", authenticateJWT, bookingController.cancelBooking);
router.patch("/:bookingId/approve", authenticateJWT, authorizeRoles("admin", "owner"), bookingController.approveBooking);
router.patch("/:bookingId/reject", authenticateJWT, authorizeRoles("admin", "owner"), bookingController.rejectBooking);
router.patch("/:bookingId/start", authenticateJWT, authorizeRoles("admin", "owner"), bookingController.startBooking);
router.patch("/:bookingId/complete", authenticateJWT, authorizeRoles("admin", "owner"), bookingController.completeBooking);

export default router;
