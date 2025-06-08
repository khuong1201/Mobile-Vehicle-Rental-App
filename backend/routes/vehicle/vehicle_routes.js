const express = require('express');
const router = express.Router();
const vehicleController = require('../../controllers/vehicle/vehicleController');

// Lấy tất cả xe
router.get('/', vehicleController.getAllVehicles);

// Thêm xe mới
router.post('/', vehicleController.createVehicle);

// Sửa xe theo ID
router.put('/:id', vehicleController.updateVehicle);

// Xóa xe theo ID
router.delete('/:id', vehicleController.deleteVehicle);

module.exports = router;