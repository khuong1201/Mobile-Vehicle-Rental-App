import asyncHandler from "../middlewares/async_handler.js";

export default class ReviewController {
    constructor(reviewService) {
        this.reviewService = reviewService;

        this.createReview = asyncHandler(this.createReview.bind(this));
        this.getReviewsByVehicle = asyncHandler(this.getReviewsByVehicle.bind(this));
        this.updateReview = asyncHandler(this.updateReview.bind(this));
        this.deleteReview = asyncHandler(this.deleteReview.bind(this));
        this.getAverageRating = asyncHandler(this.getAverageRating.bind(this));
    }

    async createReview(req, res) {
        const renterId = req.user.userId;
        const review = await this.reviewService.createReview(renterId, req.body);
        res.status(201).json({ status: "success", data: review });
    }

    async getReviewsByVehicle(req, res) {
        const vehicleId = req.params.vehicleId;
        const reviews = await this.reviewService.getReviewsByVehicle(vehicleId, req.query);
        res.json({ status: "success", results: reviews.length, data: reviews });
    }

    async getAverageRating(req, res) {
        const vehicleId = req.params.vehicleId;
        const averageRating = await this.reviewService.getAverageRating(vehicleId);
        res.json({ status: "success", data: { vehicleId, averageRating } });
    }
    
    async updateReview(req, res) {
        const renterId = req.user.userId;
        const reviewId = req.params.reviewId;
        const updatedReview = await this.reviewService.updateReview(renterId, reviewId, req.body);
        res.json({ status: "success", data: updatedReview });
    }
    
    async deleteReview(req, res) {
        const renterId = req.user.userId;
        const reviewId = req.params.reviewId;
        await this.reviewService.deleteReview(renterId, reviewId);
        res.json({ status: "success", message: "Review deleted" });
    }
}
