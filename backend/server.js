const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const session = require("express-session");
const passport = require("passport");
require("dotenv").config();
const cron = require('node-cron');
const authRoutes = require("./routes/auth/auth_routes");
const userRoutes = require("./routes/user/user_routes");
const brandRoutes = require("./routes/vehicle/brand_routes");
const vehicleRoutes = require("./routes/vehicle/vehicle_routes");
const bannerRoutes = require("./routes/banner/banner_routes");
const locationRoutes = require("./routes/location/location_routes");
const googleMapsRoutes = require("./routes/location/google_map_routes");
const reviewRoutes = require("./routes/review/review_routes");
const adminRoutes = require("./routes/admin/admin_routes");
const bookingRoutes = require("./routes/booking/booking_routes");
const momoRoutes = require("./routes/payment/momo_routes");
const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");
const initDB = require("./init_db");
const { cleanupUnverifiedUsers } = require('./services/auth_service');
const cookieParser = require('cookie-parser');

const app = express();

// Middleware
app.use(express.json());
app.use(cookieParser());

const allowedOrigins = process.env.NODE_ENV === "production"
  ? ['https://mobile-vehicle-rental-app.onrender.com','http://127.0.0.1:5500']
  : ['http://localhost:5500', 'http://127.0.0.1:5500','https://mobile-vehicle-rental-app.onrender.com'];

app.use(cors({
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.error(`Blocked by CORS: ${origin}`);
      callback(new Error("Không được phép truy cập (CORS)"));
    }
  },
  credentials: true,
}));

  
app.use(
    session({
        secret: process.env.SESSION_SECRET || "your_session_secret",
        resave: false,
        saveUninitialized: false,
        cookie: {
            secure: process.env.NODE_ENV === "production", 
            httpOnly: true,
            sameSite: "lax",
          }
    })
);
app.use(passport.initialize());
app.use(passport.session());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use('/api/brands', brandRoutes);
app.use('/api/vehicles', vehicleRoutes);
app.use('/api/banners',bannerRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/google', googleMapsRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/payment', momoRoutes);
// Initialize Passport
initializePassport();

const PORT = process.env.PORT || 5000;
const startServer = async () => {
    try {
        await connectDB(); // Kết nối MongoDB
        await initDB();    // Khởi tạo dữ liệu
        console.log('Khởi tạo dữ liệu hoàn tất.');
        // Lên lịch cron job để ghi log người dùng không được xác minh (chạy mỗi giờ)
        cron.schedule('*/6 * * * *', () => {
            console.log('Chạy tác vụ dọn dẹp người dùng không được xác minh...');
            cleanupUnverifiedUsers();
        });
        console.log('Cron job để ghi log người dùng không được xác minh đã được lên lịch.');

        // Khởi động server
        app.listen(PORT,'0.0.0.0', () => console.log(`Server đang chạy trên cổng ${PORT}`));
    } catch (err) {
        console.error('Lỗi khi khởi động server:', err);
        process.exit(1);
    }
};

startServer();