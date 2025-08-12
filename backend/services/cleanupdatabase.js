const User = require("../models/user_model");           
const Booking = require("../models/booking_model");    
const Payment = require("../models/payment_model");   

const cleanupUnverifiedUsers = async () => {
  try {
    const currentTime = new Date();
    const expiredUsers = await User.find({
      verified: false,
      otpExpires: { $lt: currentTime },
      otp: { $exists: true, $ne: null },
    }).select("email otp otpExpires");

    if (expiredUsers.length > 0) {
      console.log(
        `Tìm thấy ${expiredUsers.length} người dùng không được xác minh với OTP hết hạn:`,
        expiredUsers.map((u) => ({
          email: u.email,
          otp: u.otp,
          otpExpires: u.otpExpires,
        }))
      );

      const result = await User.deleteMany({
        verified: false,
        otpExpires: { $lt: currentTime },
        otp: { $exists: true, $ne: null },
      });
      console.log(
        `Đã xóa ${result.deletedCount} người dùng không được xác minh với OTP hết hạn`
      );
    } else {
      console.log("Không tìm thấy người dùng nào với OTP hết hạn để xóa.");
    }
  } catch (err) {
    console.error(
      "Lỗi khi dọn dẹp người dùng không được xác minh:",
      err.message
    );
  }
};
const cleanupExpiredPendingBookings = async () => {
  try {
    const cutoffDate = new Date(Date.now() - 24 * 60 * 60 * 1000); 
    const expiredBookings = await Booking.find({
      status: "pending",
      createdAt: { $lt: cutoffDate },
    });

    if (expiredBookings.length > 0) {
      console.log(`🗑️ Đang xóa ${expiredBookings.length} bookings quá hạn...`);
      const result = await Booking.deleteMany({
        status: "pending",
        createdAt: { $lt: cutoffDate },
      });
      console.log(`✅ Đã xóa ${result.deletedCount} bookings`);
    } else {
      console.log("📭 Không có booking pending nào quá hạn.");
    }
  } catch (err) {
    console.error("❌ Lỗi khi dọn dẹp booking:", err.message);
  }
};
const cleanupExpiredPendingPayments = async () => {
  try {
    const cutoffDate = new Date(Date.now() - 24 * 60 * 60 * 1000); // 24 giờ trước
    const expiredPayments = await Payment.find({
      status: "pending",
      createdAt: { $lt: cutoffDate },
    });

    if (expiredPayments.length > 0) {
      console.log(`🗑️ Đang xóa ${expiredPayments.length} payments quá hạn...`);
      const result = await Payment.deleteMany({
        status: "pending",
        createdAt: { $lt: cutoffDate },
      });
      console.log(`✅ Đã xóa ${result.deletedCount} payments`);
    } else {
      console.log("📭 Không có payment pending nào quá hạn.");
    }
  } catch (err) {
    console.error("❌ Lỗi khi dọn dẹp payment:", err.message);
  }
};
module.exports = { cleanupUnverifiedUsers, cleanupExpiredPendingBookings, cleanupExpiredPendingPayments };