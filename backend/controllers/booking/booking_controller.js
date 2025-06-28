const Booking = require('../../models/booking_model');
const { getTaxRateByOwner } = require('../../services/user_revenue_service');

// Helper: Convert "DD/MM/YYYY" => "YYYY-MM-DD"
const convertDate = (str) => {
  const [day, month, year] = str.split('/');
  return `${year}-${month}-${day}`;
};

// Helper: Calculate total rental days
const calculateRentalDays = (pickupDate, dropoffDate) => {
  const pickup = new Date(convertDate(pickupDate));
  const dropoff = new Date(convertDate(dropoffDate));
  const diffTime = dropoff - pickup;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 để tính cả ngày bắt đầu
};

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
      note,
    } = req.body;

    console.log("📥 Received booking data:", req.body);

    if (!vehicleId || !renterId || !ownerId || !pickupDate || !dropoffDate || !pickupTime || !dropoffTime || !basePrice) {
      return res.status(400).json({ message: 'Missing required booking fields.' });
    }
    const renter = await User.findById(renterId).select('license');
    if (!renter || !renter.license) {
      return res.status(403).json({ message: 'Người thuê không có thông tin bằng lái xe.' });
    }
    if (renter.license.status !== 'approved') {
      return res.status(403).json({ 
        message: 'Bằng lái xe chưa được phê duyệt. Vui lòng cập nhật và xác minh bằng lái trước khi đặt xe.' 
      });
    }
    // 📅 Convert dates to ISO format
    const pickupDateTime = new Date(`${convertDate(pickupDate)}T${pickupTime}`);
    const dropoffDateTime = new Date(`${convertDate(dropoffDate)}T${dropoffTime}`);

    // Calculate total rental days
    const totalRentalDays = calculateRentalDays(pickupDate, dropoffDate);

    const now = new Date();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();

    const parsedBasePrice = parseFloat(basePrice) * totalRentalDays; // Adjust basePrice for total days
    const taxRate = await getTaxRateByOwner(ownerId, month, year);
    const taxAmount = parsedBasePrice * taxRate;
    const totalPrice = parsedBasePrice + taxAmount;

    const booking = new Booking({
      vehicleId,
      renterId,
      ownerId,
      pickupLocation,
      dropoffLocation,
      pickupDate: pickupDateTime,
      pickupTime,
      dropoffDate: dropoffDateTime,
      dropoffTime,
      basePrice: parsedBasePrice,
      taxRate,
      taxAmount,
      totalPrice,
      totalRentalDays, // Add to booking model
      note,
    });

    await booking.save();

    res.status(201).json({
      message: 'Booking created successfully.',
      booking: booking.toJSON(),
    });
  } catch (err) {
    console.error("🔥 Error creating booking:", err.message);
    console.error("📛 Stack trace:", err.stack);
    res.status(500).json({
      message: 'Error creating booking.',
      error: err.message,
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
      message: 'Error fetching bookings for owner.',
      error: err.message,
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
      message: 'Error fetching bookings for renter.',
      error: err.message,
    });
  }
};

module.exports = {
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter,
};