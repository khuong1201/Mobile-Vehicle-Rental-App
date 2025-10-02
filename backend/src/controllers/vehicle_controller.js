import asyncHandler from "../middlewares/async_handler.js";

export default class VehicleController {
  constructor(vehicleService) {
    this.service = vehicleService;

    this.getAllVehicles = asyncHandler(this.getAllVehicles.bind(this));
    this.getVehicleById = asyncHandler(this.getVehicleById.bind(this));
    this.getUnavailableVehicles = asyncHandler(
      this.getUnavailableVehicles.bind(this)
    );
    this.getVehicleByType = asyncHandler(this.getVehicleByType.bind(this));
    this.getVehicleByOwner = asyncHandler(this.getVehicleByOwner.bind(this));
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

  async getVehicleByOwner(req, res) {
    const { userId } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const result = await this.service.getVehicleByOwner(userId, page, limit);
    res.json({
      status: "success",
      data: result.vehicles,
      page: result.page,
      totalPages: result.totalPages,
      total: result.total,
    });
  }

  async getVehicleById(req, res) {
    const vehicle = await this.service.getVehicleById(req.params.vehicleId);
    res.json({ status: "success", data: vehicle });
  }

  async createVehicle(req, res) {
    const ownerId = req.user.userId;
    const files = req.files?.images || [];
    const payload = {
      ...req.body,
      type: req.body.type?.toLowerCase(),
      price: Number(req.body.price),
      yearOfManufacture: Number(req.body.yearOfManufacture),
      images: files,
    };

    if (typeof payload.location === 'string') {
      try {
        payload.location = JSON.parse(payload.location);
      } catch (err) {
        return res.status(400).json({ status: 'error', message: 'Invalid location JSON' });
      }
    }
    
    if (typeof payload.bankAccount === 'string') {
      try {
        payload.bankAccount = JSON.parse(payload.bankAccount);
      } catch (err) {
        return res.status(400).json({ status: 'error', message: 'Invalid bankAccount JSON' });
      }
    }

    const vehicle = await this.service.createVehicleByType(
      ownerId,
      payload.type,
      payload,
      files
    );
    res.status(201).json({ status: "success", data: vehicle });
  }

  async updateVehicle(req, res) {
    const ownerId = req.user.userId;
    const files = req.files || [];
    const vehicle = await this.service.updateVehicle(
      ownerId,
      req.params.vehicleId,
      req.body,
      files
    );
    res.json({ status: "success", data: vehicle });
  }

  async deleteVehicle(req, res) {
    await this.service.deleteVehicle(req.user.userId, req.params.vehicleId);
    res.json({ status: "success", message: "Vehicle deleted successfully" });
  }
}
