import {Router} from "express";
import authenticateJWT from "../middlewares/auth_middlerware.js";
import DeviceController from "../controllers/device_token_controller.js";
import DeviceTokenService from "../services/device_token_service.js";
import DeviceValidator from "../validators/device_token_validate.js"
import getRepositories from "../repositories/index.js";

const router = Router();
const { UserRepository } = await getRepositories();
const validator = new DeviceValidator();
const deviceService = new DeviceTokenService(UserRepository, validator);
const deviceController = new DeviceController(deviceService);

router.use(authenticateJWT);

router.post("/register", deviceController.register);
router.post("/remove", deviceController.remove);

export default router;
