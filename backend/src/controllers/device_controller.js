import asyncHandler from '../middlewares/async_handler.js'
import AppError from '../utils/app_error.js';
export default class DeviceController {
    constructor(deviceService) {
        this.deviceService = deviceService,

            this.create = asyncHandler(this.create.bind(this));
        this.getDeviceById = asyncHandler(this.getDeviceById.bind(this));
        this.getDeviceByDeviceId = asyncHandler(this.getDeviceByDeviceId.bind(this));
        this.getDevice = asyncHandler(this.getDevice.bind(this));
        this.checkImei = asyncHandler(this.checkImei.bind(this));
        this.updateStatus = asyncHandler(this.updateStatus.bind(this));
        this.updateDevice = asyncHandler(this.updateDevice.bind(this));
        this.deleteDevice = asyncHandler(this.deleteDevice.bind(this))
    }

    async create(req, res) {
        const device = await this.deviceService.createDevice(req.body);
        res.status(201).json({ status: "success", data: device });
    }

    async getDeviceById(req, res) {
        const device = await this.deviceService.getDeviceById(req.params.id);
        if (!device) throw new AppError("device not found", 404);
        res.json({ status: "success", data: device })
    }

    async getDeviceByDeviceId(req, res) {
        const device = await this.deviceService.getDeviceByDeviceId(req.params.deviceId);
        if (!device) throw new AppError("Device not found", 404);
        res.json({ status: "success", data: device })
    }

    async getDevice(req, res) {
        const { vehicleId } = req.params;
        const device = await this.deviceService.getDevice({ vehicleId });
        res.json({ status: "success", data: device })
    }

    async checkImei(req, res) {
        const device = await this.deviceService.checkImei(req.params.imei);
        res.json({ status: "success", data: device });
    }

    async updateStatus(req, res) {
        const updated = await this.deviceService.updateDevice(req.params.deviceId, req.body);
        if (!updated) throw new AppError("Device not found", 404);
        res.json({ status: "success", data: updated })
    }
    async updateDevice(req, res) {
        const updated = await this.deviceService.updateDevice(req.params.deviceId, req.body);
        if (!updated) throw new AppError("Device not found", 404);
        res.json({ status: "success", data: updated });
    }

    async deleteDevice(req, res) {
        await this.deviceService.deleteDevice(req.params.deviceId)
        res.json({ status: "success", message: "Device deleted successfully" });
    }
}
