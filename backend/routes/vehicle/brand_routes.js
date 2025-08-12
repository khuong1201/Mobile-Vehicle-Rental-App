const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brand_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const uploadBrandLogo = require('../../middlewares/multer/uploadBrandLogo');

router.get('/', authenticateToken,uploadBrandLogo.single("images"), brandController.GetAllBrands);
router.get('/:id', authenticateToken,uploadBrandLogo.single("images"), brandController.GetBrandByBrandId);

module.exports = router;
