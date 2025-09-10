import { Router } from "express";
import authenticateJWT from "../middlewares/auth_middlerware.js";
import uploadVehicle from "../middlewares/upload_vehicle.js";
import VehicleController from "../controllers/vehicle_controller.js";
import VehicleService from "../services/vehicle_service.js";
import VehicleValidator from "../validators/vehicle_validate.js";
import getRepositories from "../repositories/index.js";
import CloudinaryAdapter from "../adapters/storage/cloudinary_adapter.js";
import { authorizeRoles } from '../middlewares/role_middlerware.js';

const router = Router();

const { VehicleRepository } = await getRepositories();

const validator = new VehicleValidator();
const storageAdapter = new CloudinaryAdapter("vehicles");
const vehicleService = new VehicleService( VehicleRepository, validator, storageAdapter);
const vehicleController = new VehicleController(vehicleService);


router.use(authenticateJWT);

router.get("/", vehicleController.getAllVehicles);
router.get("/unavailable", vehicleController.getUnavailableVehicles);
router.get("/type/:type", vehicleController.getVehicleByType);
router.get("/:userId", vehicleController.getVehicleByOwner);

router.post(
    "/",
    authorizeRoles('admin', 'owner'),
    uploadVehicle,
    vehicleController.createVehicle
);

router.patch(
    "/:vehicleId",
    authorizeRoles('admin', 'owner'),
    uploadVehicle,
    vehicleController.updateVehicle
);

router.delete(
    "/:vehicleId",
    authorizeRoles('admin', 'owner'),
    vehicleController.deleteVehicle
);

export default router;