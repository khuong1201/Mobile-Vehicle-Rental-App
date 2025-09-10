import AppError from "../utils/app_error.js";
import { generateDeviceToken } from '../utils/jwt.js';

export default class DeviceService{
    constructor( deviceRepo,vehicleRepo, validator){
        this.deviceRepo = deviceRepo;
        this.vehicleRepo = vehicleRepo;
        this.validator = validator
    }
    
    async createDevice(payload){
        this.validator.validateCreate(payload);
        const vehicle = await this.vehicleRepo.findByVehicleId(payload.vehicleId);
        if(!vehicle) throw new AppError("Vehicle not found", 404);
        let device = await this.deviceRepo.create(payload);
        const deviceToken = generateDeviceToken(device);
        device = await this.deviceRepo.update(device.deviceId, { deviceToken });
        return { 
            device,
            deviceToken,
        }
    }

    async getDeviceById(id){
        return this.deviceRepo.findById(id);
    }

    async getDeviceByDeviceId(deviceId){
        return this.deviceRepo.findByDeviceId(deviceId);
    }

    async getDevice(filter = {}){
        return this.deviceRepo.find(filter);
    }

    async updateDevice(deviceId,payload){
        this.validator.validateUpdate(payload);
        const vehicle = await this.vehicleRepo.findById(payload.vehicleId);
        if(!vehicle) throw new AppError("Vehicle not found", 404);
        return this.deviceRepo.update(deviceId,payload);
    }

    async deleteDevice(deviceId){
        return this.deviceRepo.delete(deviceId);
    }
}