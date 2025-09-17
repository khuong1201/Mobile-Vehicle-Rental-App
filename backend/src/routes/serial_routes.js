import { Router } from "express";
import getRepositories from "../repositories/index.js";
import SerialService from "../services/serial_service.js";
import SerialController from "../controllers/serial_controller.js";

const router = Router();
const { DeviceRepository } = await getRepositories();

const serialService = new SerialService(DeviceRepository);
const controller = new SerialController(serialService);

router.post("/control", controller.control);

export default router;
