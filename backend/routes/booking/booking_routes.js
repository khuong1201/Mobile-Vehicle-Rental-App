const express = require('express');
const router = express.Router();
const {
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter
} = require('../../controllers/booking/booking_controller');
const authMiddleware = require('../../middlewares/authMiddleware');
const ownerMiddleware = require('../../middlewares/ownerMiddleware');

router.post('/create-booking',authMiddleware, createBooking);
router.get('/bookings/owner/:ownerId',authMiddleware, ownerMiddleware, getBookingsByOwner);
router.get('/bookings/renter/:renterId', authMiddleware, getBookingsByRenter);

module.exports = router;
