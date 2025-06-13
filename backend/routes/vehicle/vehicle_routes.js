const express = require('express');
const router = express.Router();
const vehicleController = require('../../controllers/vehicle/vehicleController');
const authenticateToken = require('../../middlewares/auth_middleware');
const AdminOrOwnerMiddleware = require('../../middlewares/admin_or_owner_middleware');
// Lấy tất cả xe
router.get('/get-vehicle', authenticateToken, vehicleController.getAllVehicles);

// Thêm xe mới
router.post('/create-vehicle', authenticateToken, AdminOrOwnerMiddleware, vehicleController.createVehicle);

// Sửa xe theo ID
router.put('/cehicle/:id', authenticateToken, AdminOrOwnerMiddleware, vehicleController.updateVehicle);

// Xóa xe theo ID
router.delete('/vehicle/:id', authenticateToken, AdminOrOwnerMiddleware, vehicleController.deleteVehicle);

module.exports = router;