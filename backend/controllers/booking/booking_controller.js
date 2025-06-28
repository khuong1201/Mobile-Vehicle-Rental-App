const Booking = require('../../models/booking_model');
const { getTaxRateByOwner } = require('../../services/user_revenue_service');

const createBooking = async (req, res) => {
  try {
    const {
      vehicleId,
      renterId,
      ownerId, 
      pickupLocation,
      dropoffLocation,
      pickupDate,
      pickupTime,
      dropoffDate,
      dropoffTime,
      basePrice,
    } = req.body;
    cosole.log(req.body); 
    
    const now = new Date();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();

    const taxRate = await getTaxRateByOwner(ownerId, month, year);
    const taxAmount = basePrice * taxRate;
    const totalPrice = basePrice + taxAmount;

    const booking = new Booking({
      vehicleId,
      renterId,
      ownerId,
      pickupLocation,
      dropoffLocation,
      pickupDate,
      pickupTime,
      dropoffDate,
      dropoffTime,
      basePrice,
      taxRate,
      taxAmount,
      totalPrice,
    });

    await booking.save();

    res.status(201).json({
      message: 'Booking created successfully',
      booking: booking.toJSON(), 
    });
  } catch (err) {
    res.status(500).json({
      message: 'Error creating booking',
      error: err.message
    });
  }
};

const getBookingsByOwner = async (req, res) => {
  try {
    const { ownerId } = req.params;
    const bookings = await Booking.find({ ownerId })
      .populate('renterId', '_id fullName email')
      .populate('vehicleId');

    res.status(200).json(bookings.map((b) => b.toJSON()));
  } catch (err) {
    res.status(500).json({
      message: 'Error fetching bookings by owner',
      error: err.message
    });
  }
};

const getBookingsByRenter = async (req, res) => {
  try {
    const { renterId } = req.params;
    const bookings = await Booking.find({ renterId })
      .populate('vehicleId')
      .populate('ownerId', '_id fullName email');

    res.status(200).json(bookings.map((b) => b.toJSON()));
  } catch (err) {
    res.status(500).json({
      message: 'Error fetching bookings by renter',
      error: err.message
    });
  }
};

module.exports = {
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter
};
