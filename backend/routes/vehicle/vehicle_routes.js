const express = require("express");
const router = express.Router();
const vehicleController = require("../../controllers/vehicle/vehicle_controller");
const authenticateToken = require("../../middlewares/auth_middleware");
const adminOrOwnerMiddleware = require("../../middlewares/admin_or_owner_middleware");
const uploadVehicle = require("../../middlewares/multer/upload_vehicle");

router.use(authenticateToken);

router.get("/", vehicleController.getAllVehicles);

router.get("/unavailable", vehicleController.getUnavailableVehicles);

router.get("/type/:type", vehicleController.getVehicleByType);

router.post("/", adminOrOwnerMiddleware, uploadVehicle, vehicleController.createVehicle);

router.put("/:id", adminOrOwnerMiddleware, uploadVehicle, vehicleController.updateVehicle);

router.delete("/:id", adminOrOwnerMiddleware, vehicleController.deleteVehicle);

module.exports = router;
