const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brandController');
const authenticateToken = require('../../middlewares/auth_middleware');
const adminMiddleware = require('../../middlewares/admin_middleware');

router.get('/get-all-brand', authenticateToken, brandController.GetAllBrands);
router.post('/create-brand', authenticateToken, adminMiddleware, brandController.CreateBrand);
router.put('/update-brand/:id', authenticateToken, adminMiddleware, brandController.UpdateBrand);
router.delete('/delete-brand/:id', authenticateToken, adminMiddleware, brandController.DeleteBrand);
router.get('/get-brand/:brandId', authenticateToken, brandController.GetBrandByBrandId);

module.exports = router;
