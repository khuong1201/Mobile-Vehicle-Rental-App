import AppError from "../utils/app_error.js";
import { generateDeviceToken, isTokenExpired } from '../utils/jwt.js';

export default class DeviceService {
    constructor(deviceRepo, vehicleRepo, validator) {
        this.deviceRepo = deviceRepo;
        this.vehicleRepo = vehicleRepo;
        this.validator = validator
    }

    async createDevice(payload) {
        this.validator.validateCreate(payload);
        const vehicle = await this.vehicleRepo.findByVehicleId(payload.vehicleId);
        if (!vehicle) throw new AppError("Vehicle not found", 404);
        let existingDevice = await this.deviceRepo.findByImei(payload.imei);
        if (existingDevice) {
            if (existingDevice.deleted) {
                throw new AppError("Device with this IMEI already exists (deleted)", 400);
            } else {
                throw new AppError("Device with this IMEI already exists", 400);
            }
        }
        let device = await this.deviceRepo.create(payload);
        const deviceToken = generateDeviceToken(device);
        device = await this.deviceRepo.update(device.deviceId, { deviceToken });
        return {
            device,
            deviceToken,
        }
    }

    async getDeviceById(id) {
        return this.deviceRepo.findById(id);
    }

    async getDeviceByDeviceId(deviceId) {
        return this.deviceRepo.findByDeviceId(deviceId);
    }

    async checkImei(imei) {
        const device = await this.deviceRepo.findByImei(imei);
        if (!device) throw new AppError("Device not found", 404);

        let deviceToken = device.deviceToken;

        if (!deviceToken || device.status !== "active" || isTokenExpired(deviceToken)) {
            deviceToken = generateDeviceToken(device);
            await this.deviceRepo.update(device.deviceId, { deviceToken, status: "active" });
        }

        return {
            deviceId: device.deviceId,
            deviceToken
        };
    }


    async getDevice(filter) {
        return this.deviceRepo.find(filter);
    }

    async updateStatus(deviceId, status) {
        if (!["active", "inactive"].includes(status)) {
            throw new AppError("Status must be 'active' or 'inactive'", 400);
        }

        return this.deviceRepo.update(deviceId, { status });
    }


    async updateDevice(deviceId, payload) {
        this.validator.validateUpdate(payload);
        const vehicle = await this.vehicleRepo.findByVehicleId(payload.vehicleId);
        if (!vehicle) throw new AppError("Vehicle not found", 404);
        return this.deviceRepo.update(deviceId, payload);
    }

    async deleteDevice(deviceId) {
        return this.deviceRepo.delete(deviceId);
    }
}