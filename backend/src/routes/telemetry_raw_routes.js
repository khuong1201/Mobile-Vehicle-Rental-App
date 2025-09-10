import { Router } from 'express';
import getRepositories from '../repositories/index.js';
import TelemetryRawController from '../controllers/telemetry_raw_controller.js';
import TelemetryRawService from '../services/telemetry_raw_service.js';
import TelemetryRawValidator from '../validators/telemetry_raw_validate.js';
import authDeviceToken from '../middlewares/auth_device_token.js';
import { authorizeRoles } from '../middlewares/role_middlerware.js';
const router = Router();

const { TelemetryRawRepository, TelemetryActiveRepository } = await getRepositories();
const validator = new TelemetryRawValidator();
const service = new TelemetryRawService(TelemetryRawRepository, TelemetryActiveRepository, validator);
const controller = new TelemetryRawController(service);

router.post("/", authDeviceToken, controller.createTeleRaw);
router.get("/:deviceId/recent", authorizeRoles("admin", "owner"), controller.recentTeleRaw);

export default router;
