import Otp from "../../models/otp_model.js";
import IOtpRepo from "../interfaces/i_otp_repo.js";

export default class OtpRepositoryMongo extends IOtpRepo  {
    constructor() {
        super();
        this.model = Otp;
    }

    async create(data){
        return this.model.create(data);
    }
    async findById(id) {
        return Otp.findOne({ otpId: id }).lean();
    }
    async find(filter = {}, options = {}) {
        const query = Otp.find(filter);
        if (options.skip) query.skip(options.skip);
        if (options.limit) query.limit(options.limit);
        if (options.sort) query.sort(options.sort);
        return query.lean();
    }
    
    async update(id,data){
        return this.model.findOneAndUpdate({ otpId: id }, data, { new: true }).lean();
    }
    
    async delete(id) {
        return this.model.findOneAndDelete({ otpId: id }).lean();
    }
    async findValidOtp(userIdentifier) {
        return this.model.findOne({
            userIdentifier,
            expiresAt: {$gt: new Date()}}
        ).lean();
    }
}