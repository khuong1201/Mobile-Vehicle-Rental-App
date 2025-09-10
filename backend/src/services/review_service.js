import AppError from "../utils/app_error.js";

export default class ReviewService {
    constructor(reviewRepo, validator) {
        this.reviewRepo = reviewRepo;
        this.validator = validator;
    }

    async createReview(renterId, payload) {
        this.validator.validateCreate(payload);
        const exitingReview = await this.reviewRepo.findOne({ vehicleId: payload.vehicleId, renterId });

        if (exitingReview) throw new AppError("You have already reviewed this vehicle", 400);
        return this.reviewRepo.create({ ...payload, renterId });
    }

    async getReviewsByVehicle(vehicleId, options) {
        return this.reviewRepo.findByVehicle(vehicleId, options);
    }

    async getReviewsByRenter(renterId, options) {
        return this.reviewRepo.findByRenter(renterId, options);
    }

    async getAverageRating(vehicleId) {
        return this.reviewRepo.getAverageRating(vehicleId);
    }

    async updateReview(renterId, reviewId, payload) {
        this.validator.validateUpdate(payload);

        const review = await this.reviewRepo.findById(reviewId);
        if (!review) throw new AppError("Review not found", 404);

        if (review.renterId.userId.toString() !== renterId.toString()) {
            throw new AppError("Not authorized to update this review", 403);
        }

        return this.reviewRepo.update(reviewId, payload);
    }

    async deleteReview(renterId, reviewId) {
        this.validator.validateDelete({ reviewId });
        const review = await this.reviewRepo.findById(reviewId);
        if (!review) throw new AppError("Review not found", 404);
        if (review.renterId.userId !== renterId) {
            throw new AppError("Not authorized to delete this review", 403);
        }
        return this.reviewRepo.delete(reviewId);
    }
}
