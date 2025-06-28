const express = require('express');
const router = express.Router();

const adminController = require('../../controllers/admin/admin_user_controller');
const adminMiddleware = require('../../middlewares/admin_middleware');
const vehicleController = require('../../controllers/vehicle/vehicleController');
const reviewController = require('../../controllers/review/review_controller');
const brandController = require('../../controllers/vehicle/brandController');
const authenticateWeb = require('../../middlewares/auth_web_middleware');

router.delete('/delete-account', authenticateWeb,adminMiddleware, adminController.DeleteAccount);
router.get('/get-all-user', authenticateWeb, adminMiddleware, adminController.GetAllUsers);
router.get('/get-users-with-unapproved-licenses', authenticateWeb, adminMiddleware, adminController.GetUsersWithUnapprovedLicenses);
router.post('/approve-license', authenticateWeb, adminMiddleware, adminController.ApproveLicense);
router.post('/reject-license', authenticateWeb, adminMiddleware, adminController.RejectLicense);
router.get('/get-user-profile/:id', authenticateWeb, adminMiddleware, adminController.GetUser);
router.get('/get-admin-profile', authenticateWeb, adminMiddleware, adminController.GetAdminProfile);
router.put("/status/:id", authenticateWeb, adminMiddleware, vehicleController.ChangeVehicleStatus);
router.get("/pending", authenticateWeb, adminMiddleware, vehicleController.GetVehiclePending);
router.get('/get-all-banner', brandController.GetAllBrands);
router.post('/create-brand', authenticateWeb, adminMiddleware, brandController.CreateBrand);
router.put('/update-brand/:id', authenticateWeb, adminMiddleware, brandController.UpdateBrand);
router.delete('/delete-brand/:id', authenticateWeb, adminMiddleware, brandController.DeleteBrand);
router.get("/all-vehicles", authenticateWeb, adminMiddleware, vehicleController.GetAllVehicles);
router.get("/review/:id", authenticateWeb, adminMiddleware, reviewController.GetReviewById);
router.delete("/delete-review/:id", authenticateWeb, adminMiddleware, reviewController.DeleteReview);
module.exports = router;