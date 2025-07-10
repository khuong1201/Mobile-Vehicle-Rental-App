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
const errorHandler = require("./middlewares/error_handler");
const { checkExpiredBookings }  = require('./controllers/booking/booking_controller');
const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");
const initDB = require("./init_db");
const { cleanupUnverifiedUsers } = require('./services/auth_service');
const cookieParser = require('cookie-parser');

const app = express();
app.set('trust proxy', 1);
console.log("🌱 NODE_ENV:", process.env.NODE_ENV);
const allowedOrigins = process.env.NODE_ENV === "production"
  ? ['https://mobile-vehicle-rental-app.onrender.com', 'http://127.0.0.1:5500']
  : ['http://localhost:5500', 'http://127.0.0.1:5500', 'https://mobile-vehicle-rental-app.onrender.com'];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.error(`Blocked by CORS: ${origin}`);
      callback(new Error("Không được phép truy cập (CORS)"));
    }
  },
  credentials: true
};
app.use(cors(corsOptions));
app.options(/.*/, cors(corsOptions));

app.use(cookieParser());
app.use(express.json());

app.use(
    session({
        secret: process.env.SESSION_SECRET || "your_session_secret",
        resave: false,
        saveUninitialized: false,
        cookie: {
            secure: process.env.NODE_ENV === "production" ? true : false, 
            httpOnly: true,
            sameSite: process.env.NODE_ENV === "production" ? "None" : "Lax",
          }
    })
);
app.use(passport.session());
app.use(passport.initialize());

app.use((err, req, res, next) => {
  console.error("❌ Error middleware:", err.stack); 
  res.status(err.status || 500).json({ error: err.message });
});
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

app.use(errorHandler);
// Initialize Passport
initializePassport();

const PORT = process.env.PORT || 5000;
const startServer = async () => {
    try {
        await connectDB(); 
        await initDB();   
        console.log('Khởi tạo dữ liệu hoàn tất.');
        cron.schedule('*/6 * * * *', async () => {
          try {
            await cleanupUnverifiedUsers();
            await checkExpiredBookings();
            console.log('✅ Cron chạy xong lúc', new Date().toLocaleString());
          } catch (err) {
            console.error('❌ Lỗi khi chạy cron:', err);
          }
        });
        app.listen(PORT,'0.0.0.0', () => console.log(`Server đang chạy trên cổng ${PORT}`));
    } catch (err) {
        console.error('Lỗi khi khởi động server:', err);
        process.exit(1);
    }
};

startServer();