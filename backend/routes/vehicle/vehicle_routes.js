const express = require('express');
const router = express.Router();
const vehicleController = require('../../controllers/vehicle/vehicleController');
const authenticateToken = require('../../middlewares/auth_middleware');
const adminOrOwnerMiddleware = require('../../middlewares/admin_or_owner_middleware');
const adminMiddleware = require('../../middlewares/admin_middleware')
router.get('/get-vehicle', authenticateToken, vehicleController.GetAllVehicles);

router.post('/create-vehicle', authenticateToken, adminOrOwnerMiddleware, vehicleController.CreateVehicle);

router.put('/vehicle/:id', authenticateToken, adminOrOwnerMiddleware, vehicleController.UpdateVehicle);

router.delete('/vehicle/:id', authenticateToken, adminOrOwnerMiddleware, vehicleController.DeleteVehicle);

router.get('/get-vehicle-pending', authenticateToken, adminMiddleware, vehicleController.GetVehiclePending);

router.put('/vehicle-change-status', authenticateToken, adminMiddleware, vehicleController.ChangeVehicleStatus);

module.exports = router;