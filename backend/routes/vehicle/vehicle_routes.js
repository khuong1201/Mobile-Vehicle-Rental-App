const express = require("express");
const router = express.Router();
const vehicleController = require("../../controllers/vehicle/vehicleController");
const authenticateToken = require("../../middlewares/auth_middleware");
const adminOrOwnerMiddleware = require("../../middlewares/admin_or_owner_middleware");
const uploadVehicle = require("../../middlewares/multer/upload_vehicle");

// Get all vehicles
router.get("/", authenticateToken, vehicleController.GetAllVehicles);


// Get all unavailable vehicles (available = false)
router.get("/unavailable", authenticateToken, vehicleController.GetUnavailableVehicles);

// Get vehicles by type (Car, Motorbike, Coach, Bike)
router.get("/type/:type", authenticateToken, vehicleController.GetVehicleByType);

// Create a new vehicle
router.post("/create-vehicle", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.CreateVehicle);
// router.post("/create-vehicle", authenticateToken, uploadVehicle, vehicleController.CreateVehicle);

// Update a vehicle
router.put("/:id", authenticateToken, adminOrOwnerMiddleware, uploadVehicle, vehicleController.UpdateVehicle);

// Delete a vehicle
router.delete("/:id", authenticateToken, adminOrOwnerMiddleware, vehicleController.DeleteVehicle);



module.exports = router;
