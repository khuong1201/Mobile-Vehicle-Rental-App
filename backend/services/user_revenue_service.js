const Booking = require('../models/booking_model');

const GetRevenueByOwner = async (ownerId, month, year) => {
  const now = new Date();
  const selectedMonth = month || now.getMonth() + 1;
  const selectedYear = year || now.getFullYear();

  const startOfMonth = new Date(selectedYear, selectedMonth - 1, 1);
  const endOfMonth = new Date(selectedYear, selectedMonth, 0, 23, 59, 59, 999);

  const bookings = await Booking.find({
    onwerId: ownerId,
    createdAt: { $gte: startOfMonth, $lte: endOfMonth },
    status: 'approved'
  });

  const revenueByVehicle = {};
  let totalRevenue = 0;

  for (const booking of bookings) {
    const vehicleId = booking.vehicleId.toString();
    const amount = booking.totalPrice || 0;

    if (!revenueByVehicle[vehicleId]) {
      revenueByVehicle[vehicleId] = { revenue: 0, bookings: 0 };
    }

    revenueByVehicle[vehicleId].revenue += amount;
    revenueByVehicle[vehicleId].bookings += 1;
    totalRevenue += amount;
  }

  const taxRate = totalRevenue > 10000000 ? 0.1 : 0.05;

  return {
    totalRevenue,
    taxRate,
    totalBookings: bookings.length,
    month: selectedMonth,
    year: selectedYear,
    revenueByVehicle
  };
};

const getTaxRateByOwner = async (ownerId, month, year) => {
  const revenue = await GetRevenueByOwner(ownerId, month, year);
  return revenue.taxRate;
};

module.exports = { GetRevenueByOwner, getTaxRateByOwner };