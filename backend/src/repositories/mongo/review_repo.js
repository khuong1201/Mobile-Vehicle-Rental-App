import IReviewRepository from "../interfaces/i_review_repo.js";
import Review from "../../models/review_model.js";

export default class ReviewRepositoryMongo extends IReviewRepository {
    async create(data) {
        return Review.create(data);
    }

    async findById(reviewId) {
        return Review.findOne({ reviewId, deleted: false })
            .populate({
                path: "renterId",
                model: "User",
                localField: "renterId",
                foreignField: "userId",
                select: "fullName email"
            })
            .populate({
                path: "vehicleId",
                model: "Vehicle",
                localField: "vehicleId",
                foreignField: "vehicleId",
                select: "vehicleName licensePlate"
            });
    }

    async findOne(filter) {
        return Review.findOne({...filter, deleted: false})
            .populate({
                path: "renterId",
                model: "User",
                localField: "renterId",
                foreignField: "userId",
                select: "fullName"
            })
            .populate({
                path: "vehicleId",
                model: "Vehicle",
                localField: "vehicleId",
                foreignField: "vehicleId",
                select: "vehicleName"
            });
    }

    async find(filter = {}, options = {}) {
        const { skip = 0, limit = 10, sort = { createdAt: -1 } } = options;
        return Review.find({...filter, deleted: false})
            .populate({
                path: "renterId",
                model: "User",
                localField: "renterId",
                foreignField: "userId",
                select: "fullName"
            })
            .populate({
                path: "vehicleId",
                model: "Vehicle",
                localField: "vehicleId",
                foreignField: "vehicleId",
                select: "vehicleName"
            })
            .skip(skip)
            .limit(limit)
            .sort(sort);
    }

    async update(reviewId, data) {
        return Review.findOneAndUpdate({ reviewId }, data, { new: true });
    }

    async delete(reviewId) {
        return Review.findOneAndUpdate(
            { reviewId },
            { deleted: true },
            { new: true }
        )
    }

    async findByVehicle(vehicleId, options = {}) {
        return this.find({ vehicleId }, options);
    }

    async findByRenter(renterId, options = {}) {
        return this.find({ renterId }, options);
    }

    async getAverageRating(vehicleId) {
        const result = await Review.aggregate([
            { $match: { vehicleId, deleted: false } },
            { $group: { _id: "$vehicleId", avgRating: { $avg: "$rating" }, count: { $sum: 1 } } }
        ]);
        return result[0] || { avgRating: 0, count: 0 };
    }
}
