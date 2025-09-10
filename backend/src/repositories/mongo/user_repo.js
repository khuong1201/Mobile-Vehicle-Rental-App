import UserModel from "../../models/user_model.js";
import IUserRepo from "../interfaces/i_user_repo.js";
import AppError from "../../utils/app_error.js";

export default class UserRepositoryMongo extends IUserRepo {
    async create(data) {
        return await UserModel.create(data);
    }

    async findById(id) {
        return await UserModel.findOne({ userId: id });
    }

    async findByEmail(email) {
        return await UserModel.findOne({ email });
    }

    async getProfile(id) {
        const user = await UserModel.findOne({ userId: id });
        if (!user) throw new AppError("User not found", 404);

        return {
            userId: user.userId,
            fullName: user.fullName,
            email: user.email,
            avatar: user.avatar,
            phoneNumber: user.phoneNumber,
            gender: user.gender,
            dateOfBirth: user.dateOfBirth,
            role: user.role,
            points: user.points,
            addresses: user.addresses.filter(a => !a.deleted),
            license: user.license.filter(l => !l.deleted),
        };
    }

    async updateById(id, payload) {
        return await UserModel.findOneAndUpdate(
            { userId: id },
            payload,
            { new: true }
        );
    }

    async deleteById(userId) {
        return await UserModel.findOneAndDelete({ userId });
    }

    async addLicense(id, data) {
        const user = await UserModel.findOne({ userId: id });
        if (!user) throw new AppError("User not found");
        user.license.push(data);
        await user.save();
        return user.license;
    }

    async updateLicense(userId, licenseId, payload) {
        const user = await UserModel.findOne({ userId });
        if (!user) throw new AppError("User not found");
        const license = user.license.find(l => l.licenseId.toString() === licenseId);
        if (!license) throw new AppError("License not found");

        Object.assign(license, payload);
        await user.save();
        return user.license;
    }

    async deleteLicense(userId, licenseId) {
        const user = await UserModel.findOne({ userId });
        if (!user) throw new AppError("User not found");
        const license = user.license.find(l => l.licenseId.toString() === licenseId);
        if (!license) throw new AppError("License not found");

        license.deleted = true;
        await user.save();
        return user.license;
    }

    async addAddress(userId, addressData) {
        const user = await UserModel.findOne({ userId });
        if (!user) throw new AppError("User not found");
        user.addresses.push(addressData);
        await user.save();
        return user.addresses;
    }

    async updateAddress(userId, addressId, payload) {
        const user = await UserModel.findOne({ userId });
        if (!user) throw new AppError("User not found");
        const address = user.addresses.find(a => a.addressId.toString() === addressId);
        if (!address) throw new AppError("Address not found");

        Object.assign(address, payload);
        await user.save();
        return user.addresses;
    }

    async deleteAddress(userId, addressId) {
        const user = await UserModel.findOne({ userId });
        if (!user) throw new AppError("User not found");
        const address = user.addresses.find(a => a.addressId.toString() === addressId);
        if (!address) throw new AppError("Address not found");

        address.deleted = true;
        await user.save();
        return user.addresses;
    }
}
