const Review = require("../../models/reivews/review_model");
const Vehicle = require("../../models/vehicles/vehicle_model");
const ReviewReport = require("../../models/reivews/report_review_model");

const bannedWords = [
  "http",
  "www",
  "promotion",
  "khuyến mãi",
  "sale",
  "mua ngay",
  "giảm giá",
  "zalo",
  "facebook",
];
const CreateReview = async (req, res) => {
  try {
    const { vehicleId, rating, comment } = req.body;
    const renterId = req.user.id || req.user._id;
    console.log(`data ${vehicleId}, ${rating}, comment: ${comment} `);
    const existingReview = await Review.findOne({ vehicleId, renterId });
    if (existingReview) {
      return res
        .status(400)
        .json({ message: "You have already rated this car." });
    }

    const isSpam = bannedWords.some((word) =>
      comment.toLowerCase().includes(word)
    );
    if (isSpam) {
      return res
        .status(400)
        .json({
          message: "Review content contains prohibited words or advertising.",
        });
    }

    const review = new Review({
      vehicleId,
      renterId,
      rating,
      comment,
    });

    await review.save();

    const reviews = await Review.find({ vehicleId });
    const averageRating =
      reviews.reduce((acc, cur) => acc + cur.rating, 0) / reviews.length;

    await Vehicle.findByIdAndUpdate(vehicleId, {
      rate: averageRating.toFixed(1),
    });

    res.status(201).json({ message: "Review created", review });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
};
const GetReviewById = async (req, res) => {
  try {
    const { reviewId } = req.params;

    const review = await Review.findById(reviewId).populate("renterId", "fullName email");
    if (!review) {
      return res.status(404).json({ message: "Review not found" });
    }

    res.status(200).json(review);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch review" });
  }
};

const GetReviewsByVehicle = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const sort = req.query.sort || "-createdAt";
    const { vehicleId } = req.params;

    // ✅ Tính skip
    const skip = (page - 1) * limit;

    // ✅ Lấy danh sách reviews phân trang
    const reviews = await Review.find({ vehicleId })
      .populate("renterId")
      .sort(sort)
      .skip(skip)
      .limit(limit);

    // ✅ Đếm tổng số review
    const total = await Review.countDocuments({ vehicleId });

    // ✅ Trả kết quả
    res.status(200).json({
      reviews,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    });
  } catch (err) {
    console.error("Lỗi khi lấy reviews:", err);
    res.status(500).json({ message: "Failed to fetch reviews" });
  }
};


const DeleteReview = async (req, res) => {
  try {
    const { reviewId } = req.params;
    const userId = req.user._id;

    const review = await Review.findById(reviewId);

    if (!review) return res.status(404).json({ message: "Review not found" });

    if (review.renterId.toString() !== userId.toString() && !req.user.isAdmin) {
      return res.status(403).json({ message: "Not authorized" });
    }

    await review.remove();

    res.status(200).json({ message: "Review deleted" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error deleting review" });
  }
};
const ReportReview = async (req, res) => {
  try {
    const { reviewId, reason } = req.body;
    const ownerId = req.user._id;

    const review = await Review.findById(reviewId);
    if (!review) {
      return res.status(404).json({ message: "Review does not exist." });
    }

    const vehicle = await Vehicle.findById(review.vehicleId);
    if (!vehicle || vehicle.ownerId.toString() !== ownerId.toString()) {
      return res
        .status(403)
        .json({ message: "You do not have permission to report this review." });
    }

    const existed = await ReviewReport.findOne({ reviewId, ownerId });
    if (existed) {
      return res
        .status(400)
        .json({ message: "You have already reported this review." });
    }
    if (!reason || reason.trim() === "") {
      return res
        .status(400)
        .json({ message: "Reason for reporting is required." });
    }
    const report = new ReviewReport({
      reviewId,
      vehicleId: review.vehicleId,
      ownerId,
      reason,
    });

    await report.save();
    res.status(201).json({ message: "The report has been sent to Admin.", report });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};
const GetReportedReviews = async (req, res) => {
  try {
    const reports = await ReviewReport.find()
      .populate("reviewId", "comment rating renterId createdAt")
      .populate("ownerId", "fullName email")
      .populate("vehicleId", "name");

    res.status(200).json({ success: true, reports });
  } catch (err) {
    console.error("Error fetching reported reviews:", err);
    res.status(500).json({ success: false, message: "Server error", error: err.message });
  }
};

module.exports = {
  GetReportedReviews,
  CreateReview,
  GetReviewsByVehicle,
  DeleteReview,
  ReportReview,
  GetReviewById,
};
