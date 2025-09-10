import { Router } from "express";
import NotificationController from "../controllers/notification_controller.js";
import NotificationService from "../services/notification_service.js";
import NotificationValidator from "../validators/notification_validate.js";
import getRepositories from "../repositories/index.js";
import authenticateJWT from "../middlewares/auth_middlerware.js";

const router = Router();

const { NotificationRepository } = await getRepositories();
const validator = new NotificationValidator();
const service = new NotificationService( NotificationRepository, validator);
const controller = new NotificationController(service);

router.use(authenticateJWT);

router.post("/", controller.createNotification);
router.post("/:notificationId/send", controller.sendNotification);
router.patch("/:notificationId/sent", controller.markAsSent);
router.patch("/:notificationId/failed", controller.markAsFailed);
router.patch("/:notificationId/read", controller.markAsRead);

export default router;
