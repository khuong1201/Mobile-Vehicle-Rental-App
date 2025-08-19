const mongoose = require("mongoose");
const Booking = require("../../models/booking_model");
const User = require("../../models/user_model");
const Vehicle = require("../../models/vehicles/vehicle_model");
const { getTaxRateByOwner } = require("../../utils/revenue");
const convertDate = require("../../utils/convert_date");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const getMonthlyBookings = asyncHandler(async (req, res) => {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59);

  const totalBookings = await Booking.countDocuments({
    createdAt: { $gte: startOfMonth, $lte: endOfMonth },
  });

  res.success("Fetched monthly bookings successfully", { totalBookings }, { code: "MONTHLY_BOOKINGS" });
});

const calculateRentalDays = (pickupDate, dropoffDate) => {
  const pickup = new Date(convertDate(pickupDate));
  const dropoff = new Date(convertDate(dropoffDate));
  const diffTime = dropoff - pickup;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
};

const createBooking = asyncHandler(async (req, res) => {
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
  ) {
    throw new AppError("Missing required booking fields", 400, "MISSING_BOOKING_FIELDS");
  }

  const renter = await User.findById(renterId).select("license");
  if (!renter || !renter.license) {
    throw new AppError("Renter does not have license information", 403, "LICENSE_REQUIRED");
  }

  const approvedLicense = renter.license.find((l) => l.status === "approved");
  if (!approvedLicense) {
    throw new AppError("Renter does not have an approved license", 403, "LICENSE_REQUIRED");
  }

  const vehicle = await Vehicle.findById(vehicleId);
  if (!vehicle || !vehicle.available) {
    throw new AppError("Vehicle is not available for booking", 403, "VEHICLE_NOT_AVAILABLE");
  }

  const pickupDateTime = new Date(`${convertDate(pickupDate)}T${pickupTime}`);
  const dropoffDateTime = new Date(`${convertDate(dropoffDate)}T${dropoffTime}`);

  const totalRentalDays = calculateRentalDays(pickupDate, dropoffDate);

  const now = new Date();
  const month = now.getMonth() + 1;
  const year = now.getFullYear();
  const endTime = new Date(`${convertDate(dropoffDate)}T${dropoffTime}`);
  const parsedBasePrice = parseFloat(basePrice) * totalRentalDays;
  const taxRate = await getTaxRateByOwner(ownerId, month, year);
  const taxAmount = parsedBasePrice * taxRate;
  const totalPrice = parsedBasePrice + taxAmount;

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
    throw new AppError("Booking conflict with existing reservation", 409, "DUPLICATE_BOOKING");
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

  res.success("Booking created successfully", { bookingId: booking._id, booking: booking.toJSON() }, { code: "BOOKING_CREATED" });
});

const getBookingsByOwner = asyncHandler(async (req, res) => {
  await checkExpiredBookings();

  const { ownerId } = req.params;
  if (!mongoose.Types.ObjectId.isValid(ownerId)) {
    throw new AppError("Invalid owner ID", 400, "INVALID_OWNER_ID");
  }

  const bookings = await Booking.find({ ownerId })
    .populate("renterId", "_id fullName email")
    .populate("vehicleId");

  res.success("Fetched bookings by owner", bookings.map((b) => b.toJSON()), { code: "BOOKINGS_BY_OWNER" });
});

const getBookingsByRenter = asyncHandler(async (req, res) => {
  await checkExpiredBookings();

  const { renterId } = req.params;
  if (!mongoose.Types.ObjectId.isValid(renterId)) {
    throw new AppError("Invalid renter ID", 400, "INVALID_RENTER_ID");
  }

  const bookings = await Booking.find({ renterId })
    .populate("vehicleId")
    .populate("ownerId", "_id fullName email");

  res.success("Fetched bookings by renter", bookings.map((b) => b.toJSON()), { code: "BOOKINGS_BY_RENTER" });
});

const checkExpiredBookings = asyncHandler(async () => {
  const now = new Date();
  const expiredBookings = await Booking.find({
    status: "approved",
    endTime: { $lte: now },
  });

  for (const booking of expiredBookings) {
    const vehicle = await Vehicle.findById(booking.vehicleId);
    if (vehicle && !vehicle.available) {
      vehicle.available = true;
      await vehicle.save();
    }

    booking.status = "completed";
    await booking.save();
  }
});

module.exports = {
  checkExpiredBookings,
  getMonthlyBookings,
  createBooking,
  getBookingsByOwner,
  getBookingsByRenter,
};
