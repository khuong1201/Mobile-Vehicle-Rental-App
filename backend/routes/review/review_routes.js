const express = require("express");
const router = express.Router();
const {
  createReview,
  getReviewsByVehicle,
  deleteReview,
  reportReview
} = require("../../controllers/review/review_controller");
const authMiddleware = require("../../middlewares/auth_middleware");
const ownerMiddleware = require("../../middlewares/owner_middleware");
const reviewLimiter = require("../../middlewares/review_rate_limit");

router.post("/", authMiddleware, reviewLimiter, createReview);

router.get("/vehicle/:vehicleId", getReviewsByVehicle);

router.delete("/:reviewId", authMiddleware, deleteReview);

router.post("/:reviewId/report", authMiddleware, ownerMiddleware, reportReview);

module.exports = router;
