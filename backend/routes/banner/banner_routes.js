const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middlewares/auth_middleware');
const adminMiddleware = require('../../middlewares/admin_middleware');
const uploadBanner = require('../../middlewares/multer/upload_banner');
const bannerController = require('../../controllers/banner/banner_controller');

router.get('/get-all-banner', authenticateToken, bannerController.GetAllBanner);
router.post('/create-banner', authenticateToken, adminMiddleware, uploadBanner.single('bannerImage'), bannerController.CreateBanner);
router.put('/update-banner/:id', authenticateToken, adminMiddleware, uploadBanner.single('bannerImage'), bannerController.UpdateBanner);
router.delete('/delete-banner/:id', authenticateToken, adminMiddleware, bannerController.DeleteBanner);

module.exports = router;
