  import AppError from "../utils/app_error.js";

  export default class VehicleService {
    constructor(vehicleRepo, validator, storageAdapter) {
      this.vehicleRepo = vehicleRepo;
      this.validator = validator;
      this.storageAdapter = storageAdapter;
    }

    async uploadImages(ownerId, files = []) {
      if (!files.length) return { urls: [], publicIds: [] };
      const uploaded = await Promise.all(
        files.map(file => this.storageAdapter.upload(file, { folder: `vehicles/${ownerId}` }))
      );
      return {
        urls: uploaded.map(u => u.url),
        publicIds: uploaded.map(u => u.publicId),
      };
    }

    async createVehicleByType(ownerId, type, data, files = []) {
      this.validator.validateCreate(data);
      data.ownerId = ownerId;
    
      const { urls, publicIds } = await this.uploadImages(ownerId, files);
      data.images = urls;
      data.imagePublicIds = publicIds;
    
      delete data.type;
    
      return this.vehicleRepo.createByType(type, data);
    }
    

    async updateVehicle(ownerId, vehicleId, data, files = []) {
      this.validator.validateUpdate(data);
      const vehicle = await this.vehicleRepo.findByVehicleId(vehicleId);
      if (!vehicle) throw new AppError("Vehicle not found", 404);
      if (vehicle.ownerId.toString() !== ownerId) throw new AppError("No permission", 403);

      const { urls, publicIds } = await this.uploadImages(ownerId, files);
      data.images = [...(vehicle.images || []), ...urls];
      data.imagePublicIds = [...(vehicle.imagePublicIds || []), ...publicIds];

      return this.vehicleRepo.update(vehicleId, data);
    }

    async deleteVehicle(ownerId, vehicleId) {
      const vehicle = await this.vehicleRepo.findByVehicleId(vehicleId);
      if (!vehicle) throw new AppError("Vehicle not found", 404);
      if (vehicle.ownerId.toString() !== ownerId) throw new AppError("No permission", 403);

      if (vehicle.imagePublicIds?.length) {
        await Promise.all(vehicle.imagePublicIds.map(id => this.storageAdapter.delete(id)));
      }

      return this.vehicleRepo.delete(vehicleId);
    }

    async getAllVehicles(filter = { available: true }) {
      return this.vehicleRepo.find(filter);
    }

    async getVehicleByOwner(id){
      return this.vehicleRepo.findVehicleByOwnerId(id);
    }
    async getVehicleByType(type) {
      return this.vehicleRepo.find({ type: type });
    }

    async getUnavailableVehicles() {
      return this.vehicleRepo.find({ available: false });
    }
  }
