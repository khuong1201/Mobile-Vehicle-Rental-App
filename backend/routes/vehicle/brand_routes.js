const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brandController');
const authenticateToken = require('../../middlewares/auth_middleware');
const AdminMiddleware = require('../../middlewares/Admin_middleware');


router.get('/get-all-brand', authenticateToken, brandController.getAllBrands);
router.post('/create-brand', authenticateToken, AdminMiddleware, brandController.createBrand);
router.put('/update-brand/:id', authenticateToken, AdminMiddleware, brandController.updateBrand);
router.delete('/delete-brand/:id', authenticateToken, AdminMiddleware, brandController.deleteBrand);
router.get('/get-brand/:brandId', authenticateToken, brandController.getBrandByBrandId);

module.exports = router;
