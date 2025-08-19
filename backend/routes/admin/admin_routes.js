const express = require('express');
const router = express.Router();

const adminController = require('../../controllers/admin/admin_controller');
const adminMiddleware = require('../../middlewares/admin_middleware');
const vehicleController = require('../../controllers/vehicle/vehicle_controller');
const reviewController = require('../../controllers/review/review_controller');
const brandController = require('../../controllers/vehicle/brand_controller');
const bookingController = require('../../controllers/booking/booking_controller');
const authenticateWeb = require('../../middlewares/admin_middleware');

router.use(authenticateWeb, adminMiddleware);

router.delete('/users/account', adminController.deleteAccount);
router.get('/users', adminController.getAllUsers);
router.get('/users/unapproved-licenses', adminController.getUsersWithUnapprovedLicenses);
router.post('/users/:id/approve-license', adminController.approveLicense);
router.post('/users/:id/reject-license', adminController.rejectLicense);
router.get('/users/:id/profile', adminController.getUser);
router.get('/users/total', adminController.getTotalUsers);

router.get('/vehicles', vehicleController.getAllVehiclesForAdmin);
router.put('/vehicles/:id/status', vehicleController.changeVehicleStatus);
router.get('/vehicles/pending', vehicleController.getVehiclePending);
router.delete('/vehicles/:id', vehicleController.deleteVehicle);

router.get('/brands', brandController.getAllBrands);
router.post('/brands', brandController.createBrand);
router.put('/brands/:id', brandController.updateBrand);
router.delete('/brands/:id', brandController.deleteBrand);

router.get('/reviews/reports', reviewController.getReportReview);
router.delete('/reviews/:id', reviewController.deleteReview);

router.get('/bookings/monthly', bookingController.getMonthlyBookings);

module.exports = router;
