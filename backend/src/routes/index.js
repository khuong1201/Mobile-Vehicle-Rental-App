import express from 'express';

import userRoutes from './user_routes.js';
import authRoutes from './auth_routes.js';
import otpRoutes from './otp_routes.js';
import notificationRoutes from './notification_routes.js';
import vehicleRoutes from './vehicle_routes.js';
import brandRoutes from './brand_routes.js';
import bookingRoutes from './booking_routes.js';
import reviewRoutes from './review_routes.js';
import reviewReportRoutes from './review_report_routes.js';
import bannerRoutes from './banner_routes.js';
import deviceRoutes from './device_routes.js';
import deviceTokenRoutes from './device_token_routes.js'
import telemetryActiveRoutes from './telemetry_active_routes.js';
import telemetryRawRoutes from './telemetry_raw_routes.js';
// import paymentRoutes from './payment.routes.js';

const router = express.Router();

router.use('/users', userRoutes);
router.use('/auth', authRoutes);
router.use('/otps', otpRoutes);
router.use('/notifications', notificationRoutes);
router.use('/vehicles', vehicleRoutes);
router.use('/brands', brandRoutes);
router.use('/bookings', bookingRoutes);
router.use('/reviews', reviewRoutes);
router.use('/review-reports', reviewReportRoutes);
router.use('/banners', bannerRoutes);
router.use('/devices', deviceRoutes);
router.use('/device-token', deviceTokenRoutes);
router.use('/telemetry-active', telemetryActiveRoutes);
router.use('/telemetry-raw', telemetryRawRoutes);
// router.use('/payments', paymentRoutes);


export default router;
