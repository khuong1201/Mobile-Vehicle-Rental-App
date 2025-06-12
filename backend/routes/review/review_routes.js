const express = require("express");
const router = express.Router();
const reviewController = require("../../controllers/review/review_controller");
const authMiddleware = require("../../middlewares/auth_middleware");
const adminMiddleware = require("../../middlewares/admin_middleware");
const ownerMiddleware = require("../../middlewares/owner_middleware");
const rateLimit = require("express-rate-limit");

const reviewLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 5,
    message: "You have submitted too many values, please try again later."
  });

router.post("/", authMiddleware,reviewLimiter, reviewController.createReview);

router.get("/:vehicleId", reviewController.getReviewsByVehicle);

router.delete("/:reviewId", authMiddleware, adminMiddleware, reviewController.deleteReview);

router.post("/report", authMiddleware,ownerMiddleware, reviewController.reportReview);

module.exports = router;
