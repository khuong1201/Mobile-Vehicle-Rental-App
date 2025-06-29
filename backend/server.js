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
const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");
const initDB = require("./init_db");
const { cleanupUnverifiedUsers } = require('./services/auth_service');
const cookieParser = require('cookie-parser');

const app = express();

// Middleware
app.use(express.json());
app.use(cookieParser());
app.use(cors({
    origin: 'http://localhost:5173',
    credentials: true, 
  }));
app.use(
    session({
        secret: process.env.SESSION_SECRET || "your_session_secret",
        resave: false,
        saveUninitialized: false,
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
        app.listen(PORT, () => console.log(`Server đang chạy trên cổng ${PORT}`));
    } catch (err) {
        console.error('Lỗi khi khởi động server:', err);
        process.exit(1);
    }
};

startServer();