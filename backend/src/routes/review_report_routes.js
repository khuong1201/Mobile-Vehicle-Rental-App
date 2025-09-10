import { Router } from 'express';
import ReviewReportController from '../controllers/review_report_controller.js';
import ReviewReportService from '../services/review_report_service.js';
import getRepositories from '../repositories/index.js';
import ReviewReportValidator from '../validators/review_report_validate.js';
import authenticateJWT from '../middlewares/auth_middlerware.js';
import { authorizeRoles } from '../middlewares/role_middlerware.js';

const router = Router();
const { ReviewReportRepository, ReviewRepository } = await getRepositories();
const validator = new ReviewReportValidator();
const reportService = new ReviewReportService(ReviewReportRepository, ReviewRepository, validator);
const reportController = new ReviewReportController(reportService);
router.post('/', authenticateJWT, reportController.createReport);
router.get('/', authenticateJWT, authorizeRoles('admin'), reportController.getReports);
router.patch('/:reviewReportId/status', authenticateJWT, authorizeRoles('admin'), reportController.updateReportStatus);

export default router;