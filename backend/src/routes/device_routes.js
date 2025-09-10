import { Router } from 'express';
import DeviceService from '../services/device_service.js';
import DeviceController from '../controllers/device_controller.js';
import getRepositories from '../repositories/index.js';
import DeviceValidator from '../validators/device_validate.js';
import authenticateJWT from "../middlewares/auth_middlerware.js";
import { authorizeRoles } from '../middlewares/role_middlerware.js';


const router = Router();
const { DeviceRepository, VehicleRepository } = await getRepositories();
const validator = new DeviceValidator();
const deviceService = new DeviceService(DeviceRepository, VehicleRepository, validator)
const deviceController = new DeviceController(deviceService);

router.use(authenticateJWT);
router.use(authorizeRoles("admin", "owner"));
router.post("/", deviceController.create);
router.get("/", deviceController.getDevice);
// router.get("/:id", deviceController.getDeviceById);
router.get("/:deviceId", deviceController.getDeviceByDeviceId);
router.patch("/:deviceId", deviceController.updateDevice);
router.delete("/:deviceId", deviceController.deleteDevice);

export default router;