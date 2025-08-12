const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middlewares/auth_middleware');
const adminMiddleware = require('../../middlewares/admin_middleware');
const uploadBanner = require('../../middlewares/multer/upload_banner');
const bannerController = require('../../controllers/banner/banner_controller');

router.get('/', authenticateToken, bannerController.getAllBanner);
router.post('/', authenticateToken, adminMiddleware, uploadBanner.single('bannerImage'), bannerController.createBanner);
router.put('/:id', authenticateToken, adminMiddleware, uploadBanner.single('bannerImage'), bannerController.updateBanner);
router.delete('/:id', authenticateToken, adminMiddleware, bannerController.deleteBanner);

module.exports = router;
