const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middlewares/auth_middleware');
const adminMiddleware = require('../../middlewares/admin_middleware');
const bannerController = require('../../controllers/banner/banner_controller');

router.get('/get-all-banner',authenticateToken,bannerController.GetAllBanner);
router.post('create-banner/:id',authenticateToken,adminMiddleware,bannerController.CreateBanner);
router.put('update-banner',authenticateToken,adminMiddleware,bannerController.UpdateBanner);
router.delete('/delete-brand/:id', authenticateToken, adminMiddleware, bannerController.DeleteBanner);

module.exports = router;
