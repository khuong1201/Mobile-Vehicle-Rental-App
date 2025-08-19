const express = require("express");
const router = express.Router();
const {
  getAllReviews,
  getReviewsByVehicle,
  getReviewById,
  createReview,
  updateReview,
  deleteReview,
  reportReview
} = require("../../controllers/review/review_controller");

const authMiddleware = require("../../middlewares/auth_middleware");
const ownerMiddleware = require("../../middlewares/owner_middleware");
const reviewLimiter = require("../../middlewares/review_rate_limit");

router.get("/", getAllReviews);

router.get("/vehicle/:vehicleId", getReviewsByVehicle);

router.get("/:reviewId", getReviewById);

router.post("/", authMiddleware, reviewLimiter, createReview);

router.put("/:reviewId", authMiddleware, ownerMiddleware, updateReview);

router.delete("/:reviewId", authMiddleware, ownerMiddleware, deleteReview);

router.post("/:reviewId/report", authMiddleware, ownerMiddleware, reportReview);

module.exports = router;
