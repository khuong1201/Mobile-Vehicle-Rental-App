import IReviewReportRepository from "../interfaces/i_review_report_repo.js";
import ReviewReport from "../../models/review_report_model.js";

export default class ReviewReportRepositoryMongo extends IReviewReportRepository {
    async create(data) {
        return ReviewReport.create(data);
    }

    async findById(reviewReportId) {
        return ReviewReport.findOne({ reviewReportId, deleted: false })
            .populate({ 
                path: "reporterId", 
                model: "User", 
                localField: "reporterId", 
                foreignField: "userId", 
                select: "fullName email" 
            })
            .populate({ 
                path: "reviewId", 
                model: "Review", 
                localField: "reviewId", 
                foreignField: "reviewId" 
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
        return ReviewReport.find({...filter, deleted: false })
            .populate({ 
                path: "reporterId", 
                model: "User", 
                localField: "reporterId", 
                foreignField: "userId", 
                select: "fullName" 
            })
            .populate({ 
                path: "reviewId", 
                model: "Review", 
                localField: "reviewId", 
                foreignField: "reviewId" 
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

    async update(reviewReportId, data) {
        return ReviewReport.findOneAndUpdate({ reviewReportId }, data, { new: true });
    }

    async delete(reviewReportId) {
        return ReviewReport.findOneAndUpdate(
            { reviewReportId },
            { deleted: true },
            { new: true }
        );
    }

    async findByReview(reviewId, options = {}) {
        return this.find({ reviewId }, options);
    }

    async findByVehicle(vehicleId, options = {}) {
        return this.find({ vehicleId }, options);
    }
}