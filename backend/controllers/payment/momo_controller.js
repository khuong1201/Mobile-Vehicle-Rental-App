const https = require('https');
const crypto = require('crypto');
require('dotenv').config();
const Vehicle = require('../../models/vehicles/vehicle_model');
const Booking = require('../../models/booking_model');
const Payment = require('../../models/payment_model');
const AppError = require('../../utils/app_error');
const asyncHandler = require('../../utils/async_handler');

const createMoMoPayment = asyncHandler(async (req, res, next) => {
  const {
    bookingId: _id,
    amount,
    orderInfo = 'Thanh toán qua MoMo',
    redirectUrl = process.env.MOMO_REDIRECT_URL,
    ipnUrl = process.env.MOMO_IPN_URL,
  } = req.body;

  if (!_id || !amount) {
    return next(new AppError('Thiếu thông tin bookingId hoặc amount', 400, 'MISSING_FIELDS'));
  }

  const booking = await Booking.findById(_id);
  if (!booking) {
    return next(new AppError('Booking không tồn tại', 404, 'BOOKING_NOT_FOUND'));
  }

  const partnerCode = process.env.MOMO_PARTNER_CODE;
  const accessKey = process.env.MOMO_ACCESS_KEY;
  const secretKey = process.env.MOMO_SECRET_KEY;
  const requestType = 'captureWallet';
  const requestId = partnerCode + Date.now();
  const orderId = requestId;
  const extraData = '';
  const lang = 'vi';

  const rawSignature = `accessKey=${accessKey}&amount=${amount}&extraData=${extraData}&ipnUrl=${ipnUrl}&orderId=${orderId}&orderInfo=${orderInfo}&partnerCode=${partnerCode}&redirectUrl=${redirectUrl}&requestId=${requestId}&requestType=${requestType}`;
  const signature = crypto.createHmac('sha256', secretKey).update(rawSignature).digest('hex');

  const requestBody = JSON.stringify({
    partnerCode,
    accessKey,
    requestId,
    amount: amount.toString(),
    orderId,
    orderInfo,
    redirectUrl,
    ipnUrl,
    extraData,
    requestType,
    signature,
    lang,
  });

  const options = {
    hostname: 'test-payment.momo.vn',
    port: 443,
    path: '/v2/gateway/api/create',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(requestBody),
    },
  };

  const momoRequest = https.request(options, (momoRes) => {
    let data = '';
    momoRes.setEncoding('utf8');
    momoRes.on('data', (chunk) => (data += chunk));
    momoRes.on('end', async () => {
      try {
        const response = JSON.parse(data);
        console.log('MoMo Response:', response);

        if (response.resultCode === 0) {
          const payment = new Payment({
            paymentId: requestId,
            bookingId: booking._id,
            renterId: booking.renterId,
            amount,
            provider: 'MoMo',
            status: 'pending',
            payUrl: response.payUrl,
            responseData: response,
          });

          await payment.save();
          return res.status(200).json({
            message: 'Yêu cầu thanh toán MoMo được tạo thành công',
            payUrl: response.payUrl,
            paymentId: requestId,
          });
        } else {
          return next(new AppError('Lỗi khi tạo thanh toán MoMo', 400, 'MOMO_CREATE_ERROR'));
        }
      } catch (err) {
        return next(err);
      }
    });
  });

  momoRequest.on('error', () => {
    return next(new AppError('Lỗi kết nối đến MoMo', 500, 'MOMO_CONNECTION_ERROR'));
  });

  momoRequest.write(requestBody);
  momoRequest.end();
});

const handleMoMoIPN = asyncHandler(async (req, res, next) => {
  const { resultCode, requestId, message } = req.body;

  console.log('📥 IPN từ MoMo:', req.body);

  const payment = await Payment.findOne({ paymentId: requestId });
  if (!payment) {
    return next(new AppError('Không tìm thấy thanh toán với requestId', 404, 'PAYMENT_NOT_FOUND'));
  }

  if (resultCode === 0) {
    payment.status = 'success';
    payment.responseData = req.body;
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

    return res.status(200).json({ message: 'Thanh toán thành công từ MoMo' });
  }

  payment.status = 'failed';
  payment.responseData = req.body;
  await payment.save();
  return next(new AppError(`Thanh toán thất bại: ${message}`, 400, 'PAYMENT_FAILED'));
});

module.exports = {
  createMoMoPayment,
  handleMoMoIPN,
};
