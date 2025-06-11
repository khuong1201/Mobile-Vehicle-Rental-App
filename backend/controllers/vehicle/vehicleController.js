const Vehicle = require('../../models/vehicles/vehicle_model');
const Brand = require('../../models/vehicles/brand_model')

// GET /api/vehicles
const getAllVehicles = async (req, res) => {
  try {
    const vehicles = await Vehicle.find().populate('brand').populate('ownerId');
    res.status(200).json(vehicles);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách xe', error });
  }
};

// GET /api/vehicles/:id
const getVehicleById = async (req, res) => {
  try {
    const vehicle = await Vehicle.findById(req.params.id).populate('brand').populate('ownerId');
    if (!vehicle) return res.status(404).json({ message: 'Không tìm thấy xe' });
    res.status(200).json(vehicle);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy xe', error });
  }
};

// POST /api/vehicles
const createVehicle = async (req, res) => {
  try {
    const data = req.body;

    // Kiểm tra brand có tồn tại không
    const brand = await Brand.findById(data.brand);
    if (!brand) return res.status(400).json({ message: 'Brand không hợp lệ' });
    
    const vehicle = await Vehicle.create(data);
    res.status(201).json(vehicle);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi tạo xe mới', error });
  }
};

// PUT /api/vehicles/:id
const updateVehicle = async (req, res) => {
  try {
    const updated = await Vehicle.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: 'Không tìm thấy xe để cập nhật' });
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật xe', error });
  }
};

// DELETE /api/vehicles/:id
const deleteVehicle = async (req, res) => {
  try {
    const deleted = await Vehicle.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Không tìm thấy xe để xóa' });
    res.status(200).json({ message: 'Đã xóa xe thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi xóa xe', error });
  }
};
module.exports = {
  getAllVehicles,
  getVehicleById,
  createVehicle,
  updateVehicle,
  deleteVehicle
};
