const express = require('express');
const router = express.Router();
const {
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter
} = require('../../controllers/booking/booking_controller');

router.post('/bookings', createBooking);
router.get('/bookings/owner/:ownerId', getBookingsByOwner);
router.get('/bookings/renter/:renterId', getBookingsByRenter);

module.exports = router;
