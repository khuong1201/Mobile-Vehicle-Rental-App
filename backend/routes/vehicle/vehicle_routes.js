const express = require("express");
const router = express.Router();
const vehicleController = require("../../controllers/vehicle/vehicle_controller");
const authenticateToken = require("../../middlewares/auth_middleware");
const adminOrOwnerMiddleware = require("../../middlewares/admin_or_owner_middleware");
const uploadVehicle = require("../../middlewares/multer/upload_vehicle");

router.get("/", authenticateToken, vehicleController.GetAllVehicles);

router.get("/unavailable", authenticateToken, vehicleController.GetUnavailableVehicles);

router.get("/type/:type", authenticateToken, vehicleController.GetVehicleByType);

router.post("/", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.CreateVehicle);

router.put("/:id", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.UpdateVehicle);

router.delete("/:id", authenticateToken, adminOrOwnerMiddleware, vehicleController.DeleteVehicle);

module.exports = router;
