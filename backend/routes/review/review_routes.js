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

router.post("/create-review", authMiddleware,reviewLimiter, reviewController.CreateReview);

router.get("/:vehicleId", reviewController.GetReviewsByVehicle);

router.delete("/:reviewId", authMiddleware, reviewController.DeleteReview);

router.post("/report", authMiddleware,ownerMiddleware, reviewController.ReportReview);

module.exports = router;
