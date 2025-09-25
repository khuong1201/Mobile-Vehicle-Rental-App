import IVehicleRepo from "../interfaces/i_vehicle_repo.js";
import VehicleModel from "../../models/vehicle_model.js";
import CarModel from "../../models/car_model.js";
import MotorModel from "../../models/motor_model.js";
import CoachModel from "../../models/coach_model.js";
import BikeModel from "../../models/bike_model.js";
import AppError from "../../utils/app_error.js";

const MODEL_MAP = {
    car: CarModel,
    motor: MotorModel,
    coach: CoachModel,
    bike: BikeModel,
};
export default class VehicleRepositoryMongo extends IVehicleRepo {
    async create(data) {
        return await VehicleModel.create(data);
    }

    async createByType(type, data) {
        const model = MODEL_MAP[type.toLowerCase()];
        if (!model) {
            throw new AppError(`Invalid vehicle type: ${type}`, 400);
        }
        return await model.create(data);
    }

    async findByVehicleId(id) {
        const vehicle = await VehicleModel.findOne({ vehicleId: id, deleted: false });
        if (!vehicle) throw new AppError("Vehicle not found", 404);
        return vehicle;
    }

    async find(filter = {}, options = {}) {
        const query = { deleted: false, ...filter };
        return await VehicleModel.find(query, null, options).lean();
    }


    async update(id, data) {
        const vehicle = await VehicleModel.findOneAndUpdate(
            { vehicleId: id, deleted: false },
            data,
            { new: true }
        );
        if (!vehicle) throw new AppError("Vehicle not found", 404);
        return vehicle;
    }

    async delete(id) {
        const vehicle = await VehicleModel.findOneAndUpdate(
            { vehicleId: id, deleted: false },
            { deleted: true },
            { new: true }
        );
        if (!vehicle) throw new AppError("Vehicle not found", 404);
        return vehicle;
    }

    async findByType(type) {
        return await VehicleModel.find({ type, deleted: false, available: true });
    }

    async findUnavailable() {
        return await VehicleModel.find({ available: false, deleted: false });
    }
}
