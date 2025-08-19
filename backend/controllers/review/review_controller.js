const asyncHandler = require('../../utils/async_handler');
const AppError = require('../../utils/app_error');
const Review = require('../../models/reivews/review_model');
const ReviewReport = require('../../models/reivews/report_review_model');
const paginate = require('../../utils/paginate');

const getAllReviews = asyncHandler(async (req, res, next) => {
  let { rating, page = 1, limit = 10, sort = "-createdAt" } = req.query;
  page = parseInt(page);
  limit = parseInt(limit);
  rating = rating ? parseInt(rating) : 5;

  const query = { rating };

  const result = await paginate(Review, query, {
    page,
    limit,
    sort,
    populate: [
      { path: "userId", select: "fullName email" },
      { path: "vehicleId", select: "vehicleName brand" },
    ],
  });

  return res.success("Fetched reviews successfully", result);
});

const getReviewById = asyncHandler(async (req, res, next) => {
  const review = await Review.findById(req.params.reviewId)
    .populate({ path: "userId", select: "fullName email" })
    .populate({ path: "vehicleId", select: "vehicleName brand" });

  if (!review) {
    return next(new AppError("Review not found", 404, "REVIEW_NOT_FOUND"));
  }

  return res.success("Fetched review successfully", review);
});

const getReviewsByVehicle = asyncHandler(async (req, res, next) => {
  const { vehicleId } = req.params;
  const { page = 1, limit = 10, sort = "-createdAt" } = req.query;

  const query = { vehicleId };

  const result = await paginate(Review, query, {
    page: parseInt(page),
    limit: parseInt(limit),
    sort,
    populate: [
      { path: "userId", select: "fullName email" },
      { path: "vehicleId", select: "vehicleName brand" },
    ],
  });

  return res.success("Fetched reviews for vehicle", result);
});

const createReview = asyncHandler(async (req, res, next) => {
  const review = await Review.create(req.body);
  const populated = await review.populate([
    { path: "userId", select: "fullName email" },
    { path: "vehicleId", select: "vehicleName brand" },
  ]);

  return res.success("Review created successfully", populated);
});

const updateReview = asyncHandler(async (req, res, next) => {
  const review = await Review.findByIdAndUpdate(req.params.reviewId, req.body, {
    new: true,
    runValidators: true,
  }).populate([
    { path: "userId", select: "fullName email" },
    { path: "vehicleId", select: "vehicleName brand" },
  ]);

  if (!review) {
    return next(new AppError("Review not found", 404, "REVIEW_NOT_FOUND"));
  }

  return res.success("Review updated successfully", review);
});

const deleteReview = asyncHandler(async (req, res, next) => {
  const review = await Review.findByIdAndDelete(req.params.reviewId);
  if (!review) {
    return next(new AppError("Review not found", 404, "REVIEW_NOT_FOUND"));
  }
  return res.success("Review deleted successfully", review);
});

const reportReview = asyncHandler(async (req, res, next) => {
  const { reviewId } = req.params;
  const { reason } = req.body;

  const review = await Review.findById(reviewId);
  if (!review) {
    return next(new AppError("Review not found", 404, "REVIEW_NOT_FOUND"));
  }

  const report = await ReviewReport.create({
    reviewId,
    vehicleId: review.vehicleId,
    ownerId: req.user.id,
    reason,
  });

  return res.success("Review reported successfully", report);
});
const getReportReview = asyncHandler(async (req, res, next) => {
  let { page = 1, limit = 10, sort = "-createdAt", status } = req.query;
  page = parseInt(page);
  limit = parseInt(limit);

  const query = {};
  if (status) query.status = status; 

  const result = await paginate(ReviewReport, query, {
    page,
    limit,
    sort,
    populate: [
      { path: "reviewId", select: "rating comment userId vehicleId" },
      { path: "vehicleId", select: "vehicleName brand" },
      { path: "ownerId", select: "fullName email" },
    ],
  });

  return res.success("Fetched review reports successfully", result);
});

module.exports = {
  getAllReviews,
  getReviewById,
  getReportReview,
  getReviewsByVehicle,
  createReview,
  updateReview,
  deleteReview,
  reportReview,
};
