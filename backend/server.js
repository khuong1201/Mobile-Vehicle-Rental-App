const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const session = require("express-session");
const passport = require("passport");
require("dotenv").config();
const authRoutes = require("./routes/auth/auth_routes");
const userRoutes = require("./routes/user/user_routes");
const { connectDB } = require("./config/database");
const { initializePassport } = require("./config/passport");

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

// Initialize Passport
initializePassport();

// Connect to MongoDB
connectDB();

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
