const Vehicle = require("../../models/vehicles/vehicle_model");
const Brand = require("../../models/vehicles/brand_model");

const GetAllVehicles = async (req, res) => {
  try {
    const vehicles = await Vehicle.find()
      .populate("brandId")
      .populate({ path: "ownerId", select: "_id fullName email role" });
    res.status(200).json(vehicles);
  } catch (error) {
    res.status(500).json({ message: "Error fetching vehicle list", error });
  }
};

const GetVehicleById = async (req, res) => {
  try {
    const vehicle = await Vehicle.findById(req.params.id)
      .populate({ path: "brandId", select: "brandId" })
      .populate({ path: "ownerId", select: "_id fullName email role" });
    if (!vehicle) return res.status(404).json({ message: "Vehicle not found" });
    res.status(200).json(vehicle);
  } catch (error) {
    res.status(500).json({ message: "Error fetching vehicle", error });
  }
};

const GetVehiclePending = async (req, res) => {
  try {
    const vehicles = await Vehicle.find({ status: "pending" });
    res.status(200).json(vehicles);
  } catch (error) {
    res.status(500).json({ message: "Error fetching pending vehicles", error });
  }
};

const ChangeVehicleStatus = async (req, res) => {
  try {
    const updated = await Vehicle.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!updated) return res.status(404).json({ message: "Vehicle not found for update" });
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({ message: "Error updating vehicle status", error });
  }
};

const CreateVehicle = async (req, res) => {
  try {
    const data = req.body;

    const brand = await Brand.findById(data.brand);
    if (!brand) return res.status(400).json({ message: "Invalid brand" });

    const vehicle = await Vehicle.create(data);
    res.status(201).json(vehicle);
  } catch (error) {
    res.status(500).json({ message: "Error creating new vehicle", error });
  }
};

const UpdateVehicle = async (req, res) => {
  try {
    const updated = await Vehicle.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!updated)
      return res.status(404).json({ message: "Vehicle not found for update" });
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({ message: "Error updating vehicle", error });
  }
};

const DeleteVehicle = async (req, res) => {
  try {
    const deleted = await Vehicle.findByIdAndDelete(req.params.id);
    if (!deleted)
      return res.status(404).json({ message: "Vehicle not found for deletion" });
    res.status(200).json({ message: "Vehicle deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting vehicle", error });
  }
};

module.exports = {
  GetAllVehicles,
  GetVehicleById,
  CreateVehicle,
  UpdateVehicle,
  DeleteVehicle,
  GetVehiclePending,
  ChangeVehicleStatus,
};
