const express = require("express");
const router = express.Router();
const vehicleController = require("../../controllers/vehicle/vehicleController");
const authenticateToken = require("../../middlewares/auth_middleware");
const adminOrOwnerMiddleware = require("../../middlewares/admin_or_owner_middleware");
const adminMiddleware = require("../../middlewares/admin_middleware");
const uploadVehicle = require("../../middlewares/multer/upload_vehicle");

// Get all vehicles
router.get("/", authenticateToken, vehicleController.GetAllVehicles);

// Get all vehicles with status = pending (admin only)
router.get("/pending", authenticateToken, adminMiddleware, vehicleController.GetVehiclePending);

// Get all unavailable vehicles (available = false)
router.get("/unavailable", authenticateToken, vehicleController.GetUnavailableVehicles);

// Get vehicles by type (Car, Motorbike, Coach, Bike)
router.get("/type/:type", authenticateToken, vehicleController.GetVehicleByType);

// Get vehicle by ID
router.get("/:id", authenticateToken, vehicleController.GetVehicleById);

// Create a new vehicle
router.post("/create-vehicle", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.CreateVehicle);

// Update a vehicle
router.put("/:id", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.UpdateVehicle);

// Delete a vehicle
router.delete("/:id", authenticateToken, adminOrOwnerMiddleware, vehicleController.DeleteVehicle);

// Change vehicle status (admin only)
router.put("/status/:id", authenticateToken, adminMiddleware, vehicleController.ChangeVehicleStatus);

module.exports = router;
