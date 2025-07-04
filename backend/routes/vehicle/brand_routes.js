const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brandController');
const authenticateToken = require('../../middlewares/auth_middleware');
const uploadBrandLogo = require('../../middlewares/multer/uploadBrandLogo');
router.get('/get-all-brand', authenticateToken,uploadBrandLogo.single("images"), brandController.GetAllBrands);
router.get('/get-brand/:brandId', authenticateToken,uploadBrandLogo.single("images"), brandController.GetBrandByBrandId);

module.exports = router;
