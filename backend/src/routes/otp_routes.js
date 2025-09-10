import { Router } from 'express';
import OtpController from '../controllers/otp_controller.js';
import authenticateJWT from '../middlewares/auth_middlerware.js';
import asyncHandler from '../middlewares/async_handler.js';
import OtpService from '../services/otp_service.js';
import getRepositories from '../repositories/index.js';

const { OtpRepository } = await getRepositories();
const service = new OtpService(OtpRepository);
const controller = new OtpController(service);

const router = Router();


router.post(
  '/',
  authenticateJWT,
  asyncHandler(controller.createOtp)
);

router.post(
  '/verify',
  asyncHandler(controller.verifyOtp)
);

export default router;
