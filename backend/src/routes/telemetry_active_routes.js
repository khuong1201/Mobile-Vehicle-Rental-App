import { Router } from 'express';
import getRepositories from '../repositories/index.js';
import TelemetryActiveController from '../controllers/telemetry_active_controller.js';
import TelemetryActiveService from '../services/telemetry_active_service.js';
import TelemetryActiveValidator from '../validators/telemetry_active_validate.js';
import authenticateJWT from '../middlewares/auth_middlerware.js';
import { authorizeRoles } from '../middlewares/role_middlerware.js';

const router = Router();
const { TelemetryActiveRepository } = await getRepositories();
const validator = new TelemetryActiveValidator();
const service = new TelemetryActiveService(TelemetryActiveRepository, validator);
const controller = new TelemetryActiveController(service);

router.use(authenticateJWT);

router.get("/:deviceId/latest", authorizeRoles("admin","owner"), controller.latestTeleActive);
router.get("/:deviceId/route", authorizeRoles("admin","owner"), controller.routeTeleActive);
router.get("/nearby/search", authorizeRoles("admin","owner"), controller.nearbyTeleActive);

export default router;