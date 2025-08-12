const Review = require('../../models/reivews/review_model');
const Vehicle = require('../../models/vehicles/vehicle_model');
const ReviewReport = require('../../models/reivews/report_review_model');
const AppError = require('../../utils/app_error');
const asyncHandler = require('../../utils/async_handler');

const bannedWords = [
  'http',
  'www',
  'promotion',
  'khuyến mãi',
  'sale',
  'mua ngay',
  'giảm giá',
  'zalo',
  'facebook',
];

const createReview = asyncHandler(async (req, res, next) => {
  const { vehicleId, rating, comment } = req.body;
  if (!vehicleId || !rating || !comment) {
    return next(new AppError('Thiếu thông tin đánh giá', 400, 'MISSING_REVIEW_DATA'));
  }

  const renterId = req.user.id || req.user._id;
  const existingReview = await Review.findOne({ vehicleId, renterId });
  if (existingReview) {
    return next(new AppError('Bạn đã đánh giá xe này rồi', 400, 'REVIEW_EXISTS'));
  }

  const isSpam = bannedWords.some((word) => comment.toLowerCase().includes(word));
  if (isSpam) {
    return next(new AppError('Nội dung đánh giá chứa từ cấm hoặc quảng cáo', 400, 'REVIEW_CONTAINS_SPAM'));
  }

  const review = new Review({ vehicleId, renterId, rating, comment });
  await review.save();

  const reviews = await Review.find({ vehicleId });
  const averageRating = reviews.reduce((acc, cur) => acc + cur.rating, 0) / reviews.length;

  await Vehicle.findByIdAndUpdate(vehicleId, { rate: averageRating.toFixed(1) });

  res.status(201).json({ message: 'Review created', review });
});

const getReviewById = asyncHandler(async (req, res, next) => {
  const { reviewId } = req.params;
  const review = await Review.findById(reviewId).populate('renterId', 'fullName email');
  if (!review) {
    return next(new AppError('Không tìm thấy đánh giá', 404, 'REVIEW_NOT_FOUND'));
  }
  res.status(200).json(review);
});

const getReviewsByVehicle = asyncHandler(async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const sort = req.query.sort || '-createdAt';
  const { vehicleId } = req.params;

  const skip = (page - 1) * limit;
  const reviews = await Review.find({ vehicleId })
    .populate('renterId')
    .sort(sort)
    .skip(skip)
    .limit(limit);

  const total = await Review.countDocuments({ vehicleId });

  res.status(200).json({
    reviews,
    total,
    page,
    totalPages: Math.ceil(total / limit),
  });
});

const deleteReview = asyncHandler(async (req, res, next) => {
  const { reviewId } = req.params;
  const userId = req.user._id;

  const review = await Review.findById(reviewId);
  if (!review) {
    return next(new AppError('Đánh giá không tồn tại', 404, 'REVIEW_NOT_FOUND'));
  }

  if (review.renterId.toString() !== userId.toString() && !req.user.isAdmin) {
    return next(new AppError('Không có quyền xoá đánh giá', 403, 'NOT_AUTHORIZED'));
  }

  await review.remove();
  res.status(200).json({ message: 'Review deleted' });
});

const reportReview = asyncHandler(async (req, res, next) => {
  const { reviewId, reason } = req.body;
  const ownerId = req.user._id;

  const review = await Review.findById(reviewId);
  if (!review) {
    return next(new AppError('Đánh giá không tồn tại', 404, 'REVIEW_NOT_FOUND'));
  }

  const vehicle = await Vehicle.findById(review.vehicleId);
  if (!vehicle || vehicle.ownerId.toString() !== ownerId.toString()) {
    return next(new AppError('Bạn không có quyền báo cáo đánh giá này', 403, 'NOT_OWNER'));
  }

  if (!reason || reason.trim() === '') {
    return next(new AppError('Lý do báo cáo không được để trống', 400, 'MISSING_REASON'));
  }

  const existed = await ReviewReport.findOne({ reviewId, ownerId });
  if (existed) {
    return next(new AppError('Bạn đã báo cáo đánh giá này rồi', 400, 'ALREADY_REPORTED'));
  }

  const report = new ReviewReport({
    reviewId,
    vehicleId: review.vehicleId,
    ownerId,
    reason,
  });

  await report.save();
  res.status(201).json({ message: 'The report has been sent to Admin.', report });
});

const getReportedReviews = asyncHandler(async (req, res) => {
  const reports = await ReviewReport.find()
    .populate('reviewId', 'comment rating renterId createdAt')
    .populate('ownerId', 'fullName email')
    .populate('vehicleId', 'name');

  res.status(200).json({ success: true, reports });
});

module.exports = {
  createReview,
  getReviewById,
  getReviewsByVehicle,
  deleteReview,
  reportReview,
  getReportedReviews,
};
