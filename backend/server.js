require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const MongoStore = require("connect-mongo");
const cors = require("cors");
const session = require("express-session");
const passport = require("passport");
const cookieParser = require("cookie-parser");
const cron = require("node-cron");
const responseFormatter = require("./middlewares/response_formatter");
const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");
const initDB = require("./init_db");
const errorHandler = require("./middlewares/error_handler");

const { checkExpiredBookings } = require("./controllers/booking/booking_controller");
const {
  cleanupUnverifiedUsers,
  cleanupExpiredPendingBookings,
  cleanupExpiredPendingPayments
} = require("./services/cleanupdatabase");

const app = express();
app.set("trust proxy", 1);

app.use((req, res, next) => {
  console.log('Request:', { url: req.url, method: req.method, body: req.body, headers: req.headers });
  next();
});

const allowedOrigins =
  process.env.NODE_ENV === "production"
    ? [
        "https://mobile-vehicle-rental-app.onrender.com",
        "http://127.0.0.1:5500",
        "http://127.0.0.1:52515"
      ]
    : [
        "http://localhost:5500",
        "http://127.0.0.1:5500",
        "https://mobile-vehicle-rental-app.onrender.com"
      ];

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Không được phép truy cập (CORS)"));
    }
  },
  credentials: true
};
app.use(cors(corsOptions));
// app.options("*", cors(corsOptions));

app.use(cookieParser());
app.use(express.json());
app.use(responseFormatter);

app.use(
  session({
    secret: process.env.SESSION_SECRET || "your_session_secret",
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
      mongoUrl: process.env.MONGO_URI,
      collectionName: "sessions",
      ttl: 24 * 60 * 60
    }),
    cookie: {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: process.env.NODE_ENV === "production" ? "None" : "Lax",
      maxAge: 24 * 60 * 60 * 1000
    }
  })
);

initializePassport();
app.use(passport.initialize());
app.use(passport.session());

const addRoute = (path, router) => {
  console.log(`Adding route prefix: /${path}`);
  app.use(`/api/${path}`, router);
};

addRoute("auth", require("./routes/auth/auth_routes"));
addRoute("user", require("./routes/user/user_routes"));
addRoute("brands", require("./routes/vehicle/brand_routes"));
addRoute("vehicles", require("./routes/vehicle/vehicle_routes"));
addRoute("banners", require("./routes/banner/banner_routes"));
addRoute("locations", require("./routes/location/location_routes"));
addRoute("google", require("./routes/location/google_map_routes"));
addRoute("reviews", require("./routes/review/review_routes"));
addRoute("admin", require("./routes/admin/admin_routes"));
addRoute("bookings", require("./routes/booking/booking_routes"));
addRoute("payment/momo", require("./routes/payment/momo_routes"));
addRoute("payment/viettin", require("./routes/payment/viettin_routes"));

app.use(errorHandler);

const PORT = process.env.PORT || 5000;
const startServer = async () => {
  try {
    await connectDB();
    await initDB();
    console.log("✅ Khởi tạo dữ liệu hoàn tất.");

    cron.schedule("*/6 * * * *", async () => {
      try {
        await cleanupUnverifiedUsers();
        await checkExpiredBookings();
        console.log("✅ Cron chạy xong lúc", new Date().toLocaleString());
      } catch (err) {
        console.error("❌ Lỗi khi chạy cron:", err);
      }
    });

    cron.schedule("0 * * * *", async () => {
      try {
        await cleanupExpiredPendingPayments();
        console.log("✅ [1 giờ] cleanup payment pending:", new Date().toLocaleString());
      } catch (err) {
        console.error("❌ Lỗi cron 1 giờ:", err);
      }
    });

    cron.schedule("0 2 * * *", async () => {
      try {
        await cleanupExpiredPendingBookings();
        console.log("✅ [Hàng ngày] cleanup booking pending:", new Date().toLocaleString());
      } catch (err) {
        console.error("❌ Lỗi cron hàng ngày:", err);
      }
    });

    app.listen(PORT, "0.0.0.0", () =>
      console.log(`🚀 Server đang chạy trên cổng ${PORT}`)
    );
  } catch (err) {
    console.error("❌ Lỗi khi khởi động server:", err);
    process.exit(1);
  }
};

startServer();
