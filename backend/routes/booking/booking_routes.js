const express = require('express');
const router = express.Router();
const {
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter
} = require('../../controllers/booking/booking_controller');
const authMiddleware = require('../../middlewares/auth_middleware');
const adminOrOwnerMiddleware = require('../../middlewares/admin_or_owner_middleware');

router.post('/create-booking',authMiddleware, createBooking);
router.get('/bookings/owner/:ownerId',adminOrOwnerMiddleware ,getBookingsByOwner);
router.get('/bookings/renter/:renterId', authMiddleware, getBookingsByRenter);

module.exports = router;