import { Router } from 'express';
import ReviewController from '../controllers/review_controller.js';
import ReviewService from '../services/review_service.js';
import getRepositories from '../repositories/index.js';
import ReviewValidator from '../validators/review_validate.js';
import authenticateJWT from '../middlewares/auth_middlerware.js';

const router = Router();

const { ReviewRepository } = await getRepositories();
const validator = new ReviewValidator();
const reviewService = new ReviewService(ReviewRepository, validator);
const reviewController = new ReviewController(reviewService);

router.post('/', authenticateJWT, reviewController.createReview);
router.get('/vehicle/:vehicleId', reviewController.getReviewsByVehicle);
router.patch('/:reviewId', authenticateJWT, reviewController.updateReview);
router.delete('/:reviewId', authenticateJWT, reviewController.deleteReview);
router.get('/vehicle/:vehicleId/average-rating', reviewController.getAverageRating);

export default router;