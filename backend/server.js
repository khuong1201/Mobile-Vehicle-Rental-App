const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const session = require("express-session");
const passport = require("passport");
require("dotenv").config();

const authRoutes = require("./routes/auth/auth_routes");
const userRoutes = require("./routes/user/user_routes");
const brandRoutes = require("./routes/vehicle/brand_routes");
const vehicleRoutes = require("./routes/vehicle/vehicle_routes");

const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");
const initDB  = require("./init_db");
const app = express();

// Middleware
app.use(express.json());
app.use(cors());
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

// Initialize Passport
initializePassport();

const PORT = process.env.PORT || 5000;
const startServer = async () => {
  try {
    await connectDB(); // Kết nối MongoDB
    await initDB();    // Khởi tạo dữ liệu
    console.log('Khởi tạo dữ liệu hoàn tất.');

    // Khởi động server
    app.listen(PORT, () => console.log('Server running on port 5000'));
  } catch (err) {
    console.error('Lỗi khi khởi động server:', err);
    process.exit(1);
  }
};

startServer();