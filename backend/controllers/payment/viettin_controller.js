require('dotenv').config();
const Vehicle = require('../../models/vehicles/vehicle_model');
const Booking = require('../../models/booking_model');
const Payment = require('../../models/payment_model');
const AppError = require('../../utils/app_error');
const asyncHandler = require('../../utils/async_handler');

const createVietinBankPayment = asyncHandler(async (req, res, next) => {
  const {
    bookingId: _id,
    amount,
    orderInfo = 'Thanh toán qua VietinBank',
  } = req.body;

  if (!_id || !amount) {
    return next(new AppError('Thiếu bookingId hoặc amount', 400, 'MISSING_FIELDS'));
  }

  const booking = await Booking.findById(_id);
  if (!booking) {
    return next(new AppError('Không tìm thấy booking', 404, 'BOOKING_NOT_FOUND'));
  }

  const existingPayment = await Payment.findOne({
    bookingId: _id,
    provider: 'Viettin',
    status: { $in: ['pending', 'success'] },
  });

  if (existingPayment) {
    return res.status(200).json({
      message: 'Đã tồn tại thanh toán VietinBank',
      paymentId: existingPayment.paymentId,
    });
  }

  const requestId = 'VTB' + Date.now();

  const payment = new Payment({
    paymentId: requestId,
    bookingId: booking._id,
    renterId: booking.renterId,
    amount,
    provider: 'Viettin',
    status: 'pending',
    responseData: {
      resultCode: 0,
      message: 'Tạo thanh toán VietinBank',
      orderInfo,
    },
  });

  await payment.save();
  console.log('✅ Tạo thanh toán VietinBank thành công:', payment);

  return res.status(200).json({
    message: 'Tạo thanh toán VietinBank thành công',
    paymentId: requestId,
  });
});

const handleVietinBankIPN = asyncHandler(async (req, res, next) => {
  const { paymentId, resultCode, message = '' } = req.body;

  if (!paymentId) {
    return next(new AppError('Thiếu paymentId', 400, 'MISSING_PAYMENT_ID'));
  }

  const payment = await Payment.findOne({ paymentId });
  if (!payment) {
    return next(new AppError('Không tìm thấy thanh toán', 404, 'PAYMENT_NOT_FOUND'));
  }

  payment.responseData = { ...payment.responseData, ...req.body };

  if (resultCode === 0) {
    payment.status = 'success';
    await payment.save();

    const booking = await Booking.findById(payment.bookingId);
    if (booking && booking.status !== 'approved') {
      booking.status = 'approved';
      await booking.save();
    }

    const vehicle = await Vehicle.findById(booking.vehicleId);
    if (vehicle && vehicle.available !== false) {
      vehicle.available = false;
      await vehicle.save();
    }

    return res.status(200).json({
      message: 'Thanh toán VietinBank thành công',
      paymentId,
    });
  }

  payment.status = 'failed';
  await payment.save();

  return next(new AppError(`Thanh toán thất bại: ${message}`, 400, 'VTB_PAYMENT_FAILED'));
});

module.exports = {
  createVietinBankPayment,
  handleVietinBankIPN,
};
