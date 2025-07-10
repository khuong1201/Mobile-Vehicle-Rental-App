const Booking = require("../../models/booking_model");
const User = require("../../models/user_model");
const { getTaxRateByOwner } = require("../../services/user_revenue_service");
const AppError = require("../../utils/app_error");
const convertDate = require("../../utils/convert_date");

const GetMonthlyBookings = async (req, res, next) => {
  try {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const endOfMonth = new Date(
      now.getFullYear(),
      now.getMonth() + 1,
      0,
      23,
      59,
      59
    );
    const totalBookings = await Booking.countDocuments({
      createdAt: { $gte: startOfMonth, $lte: endOfMonth },
    });
    res.json({ totalBookingsThisMonth: totalBookings });
  } catch (err) {
    console.error("Get monthly bookings error:", err);
    next(err);
  }
};
// Helper: Calculate total rental days
const calculateRentalDays = (pickupDate, dropoffDate) => {
  const pickup = new Date(convertDate(pickupDate));
  const dropoff = new Date(convertDate(dropoffDate));
  const diffTime = dropoff - pickup;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 để tính cả ngày bắt đầu
};

const createBooking = async (req, res, next) => {
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

    console.log("📥 Received booking data:", req.body);

    if (
      !vehicleId ||
      !renterId ||
      !ownerId ||
      !pickupDate ||
      !dropoffDate ||
      !pickupTime ||
      !dropoffTime ||
      !pickupLocation ||
      !dropoffLocation ||
      !basePrice
    )
      return next(
        new AppError(
          "Missing required booking fields",
          400,
          "MISSING_BOOKING_FIELDS"
        )
      );
    const renter = await User.findById(renterId).select("license");
    if (!renter || !renter.license) {
      return res
        .status(403)
        .json({ message: "Người thuê không có thông tin bằng lái xe." });
    }
    const approvedLicense = renter.license.find((l) => l.status === "approved");
    if (!approvedLicense)
      return next(
        new AppError(
          "Người thuê không có thông tin bằng lái xe",
          403,
          "LICENSE_REQUIRED"
        )
      );

    const pickupDateTime = new Date(`${convertDate(pickupDate)}T${pickupTime}`);
    const dropoffDateTime = new Date(
      `${convertDate(dropoffDate)}T${dropoffTime}`
    );

    const totalRentalDays = calculateRentalDays(pickupDate, dropoffDate);

    const now = new Date();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();
    const endTime = new Date(`${convertDate(dropoffDate)}T${dropoffTime}`);
    const parsedBasePrice = parseFloat(basePrice) * totalRentalDays;
    const taxRate = await getTaxRateByOwner(ownerId, month, year);
    const taxAmount = parsedBasePrice * taxRate;
    const totalPrice = parsedBasePrice + taxAmount;
    // Trước khi tạo booking mới
    const existingBooking = await Booking.findOne({
      vehicleId,
      status: { $in: ["pending", "approved"] },
      $or: [
        {
          pickupDate: { $lte: dropoffDateTime },
          dropoffDate: { $gte: pickupDateTime },
        },
      ],
    });

    if (existingBooking) {
      return next(
        new AppError(
          "Đã có đơn đặt xe trùng thời gian đang chờ xử lý hoặc đã được duyệt.",
          409,
          "DUPLICATE_BOOKING"
        )
      );
    }

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
      endTime,
      basePrice: parsedBasePrice,
      taxRate,
      taxAmount,
      totalPrice,
      totalRentalDays,
    });

    await booking.save();

    res.status(201).json({
      message: "Booking created successfully.",
      bookingId: booking._id,
      booking: booking.toJSON(),
    });
  } catch (err) {
    next(err);
  }
};

const getBookingsByOwner = async (req, res, next) => {
  try {
    await checkExpiredBookings();
    const { ownerId } = req.params;
    if (!mongoose.Types.ObjectId.isValid(ownerId))
      return next(new AppError("Invalid owner ID", 400, "INVALID_OWNER_ID"));
    const bookings = await Booking.find({ ownerId })
      .populate("renterId", "_id fullName email")
      .populate("vehicleId");
    res.status(200).json(bookings.map((b) => b.toJSON()));
  } catch (err) {
    next(err);
  }
};

const getBookingsByRenter = async (req, res, next) => {
  try {
    await checkExpiredBookings();
    const { renterId } = req.params;
    if (!mongoose.Types.ObjectId.isValid(renterId))
      return next(new AppError("Invalid renter ID", 400, "INVALID_RENTER_ID"));
    const bookings = await Booking.find({ renterId })
      .populate("vehicleId")
      .populate("ownerId", "_id fullName email");
    res.status(200).json(bookings.map((b) => b.toJSON()));
  } catch (err) {
    next(err);
  }
};
const checkExpiredBookings = async () => {
  const now = new Date();
  const expiredBookings = await Booking.find({
    status: "approved",
    endTime: { $lte: now },
  });

  for (const booking of expiredBookings) {
    const vehicle = await vehicle.findById(booking.vehicleId);
    if (vehicle && !vehicle.available) {
      vehicle.available = true;
      await vehicle.save();
    }

    booking.status = "completed";
    await booking.save();
  }
};
module.exports = {
  checkExpiredBookings,
  GetMonthlyBookings,
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter,
};
