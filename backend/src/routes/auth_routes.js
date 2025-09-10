import { Router } from 'express';
import AuthController from '../controllers/auth_controller.js';
import getRepositories from '../repositories/index.js';
import UserAuthService from '../services/auth_service.js';
import AuthValidator from '../validators/auth_validate.js';
import authenticateJWT  from '../middlewares/auth_middlerware.js';
import OtpService from '../services/otp_service.js';
import NotificationService from '../services/notification_service.js';
import OtpValidator from '../validators/otp_validate.js';
import NoticationValidator from '../validators/notification_validate.js';

const router = Router();

const { UserRepository, NotificationRepository, OtpRepository } = await getRepositories();
const otpValidator = new OtpValidator();
const otpService = new OtpService(OtpRepository, otpValidator);
const notificationValidator = new NoticationValidator();
const notificationService = new NotificationService(NotificationRepository, notificationValidator);
const authValidator = new AuthValidator();
const authService = new UserAuthService(UserRepository, otpService, notificationService, authValidator);
const controller = new AuthController(authService);

router.post('/register', controller.register);
router.post('/login', controller.login);
router.post('/google-login', controller.googleLogin);
router.post('/verify-otp', controller.verifyOtp);
router.post('/logout', authenticateJWT, controller.logout);
router.post('/refresh-token', controller.refeshToken);

export default router;