const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brand_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const uploadBrandLogo = require('../../middlewares/multer/uploadBrandLogo');

router.get('/', authenticateToken,uploadBrandLogo.single("images"), brandController.getAllBrands);
router.get('/:id', authenticateToken,uploadBrandLogo.single("images"), brandController.getBrandByBrandId);

module.exports = router;
