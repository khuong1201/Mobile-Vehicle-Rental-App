// paymentController.js
const mongoose = require("mongoose");
const https = require("https");
const crypto = require("crypto");
require("dotenv").config();

const Booking = require("../../models/booking_model");
const Payment = require("../../models/payment_model");

const createMoMoPayment = async (req, res) => {
  try {
    const {
      bookingId: _id,
      amount,
      orderInfo = "Thanh toán qua MoMo",
      redirectUrl = process.env.MOMO_REDIRECT_URL,
      ipnUrl = process.env.MOMO_IPN_URL,
    } = req.body;

    const booking = await Booking.findOne({ _id });
    if (!booking) {
      return res.status(404).json({ error: "Booking không tồn tại" });
    }

    const partnerCode = process.env.MOMO_PARTNER_CODE;
    const accessKey = process.env.MOMO_ACCESS_KEY;
    const secretKey = process.env.MOMO_SECRET_KEY;
    const requestType = "captureWallet";
    const requestId = partnerCode + new Date().getTime();
    const orderId = requestId;
    const extraData = "";
    const lang = "vi";

    const rawSignature = `accessKey=${accessKey}&amount=${amount}&extraData=${extraData}&ipnUrl=${ipnUrl}&orderId=${orderId}&orderInfo=${orderInfo}&partnerCode=${partnerCode}&redirectUrl=${redirectUrl}&requestId=${requestId}&requestType=${requestType}`;
    const signature = crypto
      .createHmac("sha256", secretKey)
      .update(rawSignature)
      .digest("hex");

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
      hostname: "test-payment.momo.vn",
      port: 443,
      path: "/v2/gateway/api/create",
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(requestBody),
      },
    };

    const momoRequest = https.request(options, (momoRes) => {
      let data = "";
      momoRes.setEncoding("utf8");
      momoRes.on("data", (chunk) => {
        data += chunk;
      });
      momoRes.on("end", async () => {
        const response = JSON.parse(data);
        console.log("MoMo Response:", response);

        if (response.resultCode === 0) {
          // Lưu thông tin thanh toán vào database
          const payment = new Payment({
            paymentId: requestId,
            bookingId: booking._id,
            renterId: booking.renterId,
            amount,
            provider: "MoMo",
            status: "pending",
            payUrl: response.payUrl,
            responseData: response,
          });

          await payment.save();

          return res.status(200).json({
            message: "Yêu cầu thanh toán MoMo được tạo thành công",
            payUrl: response.payUrl,
            paymentId: requestId,
          });
        } else {
          return res.status(400).json({
            error: "Lỗi khi tạo thanh toán MoMo",
            details: response,
          });
        }
      });
    });

    momoRequest.on("error", (e) => {
      console.error(`Lỗi yêu cầu MoMo: ${e.message}`);
      return res.status(500).json({ error: "Lỗi server khi gửi yêu cầu MoMo" });
    });

    momoRequest.write(requestBody);
    momoRequest.end();
  } catch (error) {
    console.error("Lỗi:", error);
    return res.status(500).json({ error: "Lỗi server" });
  }
};

module.exports = { createMoMoPayment };