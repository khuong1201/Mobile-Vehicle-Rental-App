import AppError from "../utils/app_error.js";

export default class ReviewValidator {
    validateCreate({ vehicleId, rating }) {
        if (!vehicleId) throw new AppError("vehicleId is required", 400);
        if (!rating) throw new AppError("rating is required", 400);
        if (typeof rating !== "number") throw new AppError("rating must be a number", 400);
        if (rating < 1 || rating > 5) throw new AppError("rating must be between 1 and 5", 400);
    }

    validateUpdate({ rating, comment }) {
        if (rating && (rating < 1 || rating > 5)) {
            throw new AppError("Rating must be between 1 and 5", 400);
        }
        if (comment !== undefined && typeof comment !== "string") {
            throw new AppError("Comment must be a string", 400);
        }
        return true;
    }

    validateDelete({ reviewId }) {
        if (!reviewId) throw new AppError("reviewId is required", 400);
    }

    validateGetByVehicle({ vehicleId }) {
        if (!vehicleId) throw new AppError("vehicleId is required", 400);
    }
}
