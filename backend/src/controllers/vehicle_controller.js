import asyncHandler from "../middlewares/async_handler.js";

export default class VehicleController {
    constructor(vehicleService) {
        this.service = vehicleService;

        this.getAllVehicles = asyncHandler(this.getAllVehicles.bind(this));
        this.getUnavailableVehicles = asyncHandler(this.getUnavailableVehicles.bind(this));
        this.getVehicleByType = asyncHandler(this.getVehicleByType.bind(this));
        this.createVehicle = asyncHandler(this.createVehicle.bind(this));
        this.updateVehicle = asyncHandler(this.updateVehicle.bind(this));
        this.deleteVehicle = asyncHandler(this.deleteVehicle.bind(this));
    }

    async getAllVehicles(req, res) {
        const vehicles = await this.service.getAllVehicles();
        res.json({ status: "success", data: vehicles });
    }

    async getUnavailableVehicles(req, res) {
        const vehicles = await this.service.getUnavailableVehicles();
        res.json({ status: "success", data: vehicles });
    }

    async getVehicleByType(req, res) {
        const { type } = req.params;
        const vehicles = await this.service.getVehicleByType(type);
        res.json({ status: "success", data: vehicles });
    }

    async createVehicle(req, res) {
        const ownerId = req.user.userId;
        const files = req.files || [];
        const payload ={
            ...req.body,
            type: req.body.type?.toLowerCase(),
            price: Number(req.body.price),
            yearOfManufacture: Number(req.body.yearOfManufacture),
        }
        const vehicle = await this.service.createVehicleByType(ownerId, payload.type, payload, files);
        res.status(201).json({ status: "success", data: vehicle });
    }

    async updateVehicle(req, res) {
        const ownerId = req.user.userId;
        const files = req.files || [];
        const vehicle = await this.service.updateVehicle(ownerId, req.params.vehicleId, req.body, files);
        res.json({ status: "success", data: vehicle });
    }

    async deleteVehicle(req, res) {
        await this.service.deleteVehicle(req.user.userId, req.params.vehicleId);
        res.json({ status: "success", message: "Vehicle deleted successfully" });
    }
}
