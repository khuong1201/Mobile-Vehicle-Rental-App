const mongoose = require("mongoose");
const Vehicle = require("../../models/vehicles/vehicle_model");
const Car = require("../../models/vehicles/car_model");
const Motor = require("../../models/vehicles/motor_model");
const Coach = require("../../models/vehicles/coach_model");
const Bike = require("../../models/vehicles/bike_model");

const Brand = require("../../models/vehicles/brand_model");
const {
  deleteFileFromCloudinary,
} = require("../../services/cloudinary_service");
const paginate = require("../../util/paginate");

// Lấy tất cả xe (có phân trang + sort)
const GetAllVehicles = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const sort = req.query.sort || "-createdAt";

    const result = await paginate(
      Vehicle,
      {
        available: true,
        // status: { $nin: ["pending", "rejected"] },
      },
      {
        page,
        limit,
        sort,
        populate: [
          { path: "brand", select: "_id brandId brandName brandLogo" },
          { path: "ownerId", select: "_id fullName email role" },
        ],
      }
    );

    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi lấy danh sách xe",
      error: error.message,
    });
  }
};

// Lấy các xe chưa duyệt
const GetVehiclePending = async (req, res) => {
  try {
    const vehicles = await Vehicle.find({ status: "pending" });
    res.status(200).json(vehicles);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Lỗi khi lấy xe đang chờ duyệt", error: error.message });
  }
};

// Cập nhật trạng thái xe (duyệt/hủy...)
const ChangeVehicleStatus = async (req, res) => {
  try {
    const updated = await Vehicle.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!updated)
      return res.status(404).json({ message: "Không tìm thấy xe để cập nhật" });
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi cập nhật trạng thái xe",
      error: error.message,
    });
  }
};

const CreateVehicle = async (req, res) => {
  try {
    const data = req.body;
    console.log("📥 Dữ liệu xe mới:", data);

    // Lấy và chuẩn hóa type
    const rawType = (data.type || '').toLowerCase();
    if (!['car', 'motor', 'coach', 'bike'].includes(rawType)) {
      return res.status(400).json({ message: "Loại xe không hợp lệ" });
    }

    // Kiểm tra brand
    const brandId = data.brand;
    if (!brandId || !mongoose.Types.ObjectId.isValid(brandId)) {
      return res.status(400).json({ message: "ID thương hiệu không hợp lệ" });
    }

    const brand = await Brand.findById(brandId);
    if (!brand) {
      return res.status(400).json({ message: "Thương hiệu không tồn tại" });
    }

    // Parse location
    let parsedLocation;
    try {
      parsedLocation = typeof data.location === 'string' ? JSON.parse(data.location) : data.location;
    } catch (err) {
      console.warn("⚠️ Lỗi khi parse location:", err.message);
      parsedLocation = undefined;
    }

    // Xử lý ảnh
    const images = req.files?.images || [];
    const imageInfos = images.map(file => ({
      url: file.path,
      publicId: file.filename,
    }));

    // Dữ liệu dùng chung cho tất cả các loại xe
    const baseVehicleData = {
      vehicleName: data.vehicleName || "Default Vehicle",
      licensePlate: data.licensePlate,
      brand: brand._id,
      model: data.model,
      yearOfManufacture: data.yearOfManufacture,
      images: imageInfos.map(i => i.url),
      imagePublicIds: imageInfos.map(i => i.publicId),
      description: data.description,
      location: parsedLocation,
      price: parseFloat(data.price || 0),
      bankAccount: {
        accountNumber: data.accountNumber || '',
        bankName: data.bankName || '',
        accountHolderName: data.accountHolderName || '',
        // routingNumber: data.routingNumber || '',
        // swiftCode: data.swiftCode || '',
      },
      rate: parseFloat(data.rate || 0),
      available: data.available === 'true' || data.available === true,
      status: data.status || 'pending',
      ownerId: req.user.id,
      ownerEmail: req.user.email,
    };

    let vehicle;

    // Tạo từng loại xe theo type
    switch (rawType) {
      case 'car':
        vehicle = await Car.create({
          ...baseVehicleData,
          fuelType: data.fuelType || '',
          transmission: data.transmission || 'Automatic',
          numberOfSeats: parseFloat(data.numberOfSeats || 4),
        });
        break;

      case 'motor':
        vehicle = await Motor.create({
          ...baseVehicleData,
          fuelType: data.fuelType || '',
        });
        break;

      case 'coach':
        vehicle = await Coach.create({
          ...baseVehicleData,
          fuelType: data.fuelType || '',
          transmission: data.transmission || 'Manual',
          numberOfSeats: parseFloat(data.numberOfSeats || 16),
        });
        break;

      case 'bike':
        vehicle = await Bike.create(baseVehicleData);
        break;

      default:
        return res.status(400).json({ message: "Loại xe không hợp lệ" });
    }

    return res.status(201).json(vehicle);
  } catch (error) {
    console.error("🔥 Lỗi khi tạo xe mới:", error);
    return res.status(500).json({
      message: "Lỗi khi tạo xe mới",
      error: error.message,
    });
  }
};
// Cập nhật xe
const UpdateVehicle = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;

    const vehicle = await Vehicle.findById(id);
    if (!vehicle) return res.status(404).json({ message: "Không tìm thấy xe" });

    if (vehicle.ownerId.toString() !== req.user.id)
      return res
        .status(403)
        .json({ message: "Bạn không có quyền cập nhật xe này" });

    let newImages = vehicle.images;
    let newImagePublicIds = vehicle.imagePublicIds;

    if (req.files?.images) {
      if (vehicle.imagePublicIds?.length > 0) {
        for (const publicId of vehicle.imagePublicIds) {
          await deleteFileFromCloudinary(publicId);
        }
      }

      newImages = req.files.images.map((file) => file.path);
      newImagePublicIds = req.files.images.map((file) => file.filename);
    }

    const updated = await Vehicle.findByIdAndUpdate(
      id,
      {
        ...data,
        images: newImages,
        imagePublicIds: newImagePublicIds,
      },
      { new: true }
    );

    res.status(200).json(updated);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Lỗi khi cập nhật xe", error: error.message });
  }
};

// Xóa xe
const DeleteVehicle = async (req, res) => {
  try {
    const vehicle = await Vehicle.findById(req.params.id);
    if (!vehicle)
      return res.status(404).json({ message: "Không tìm thấy xe để xóa" });

    if (vehicle.ownerId.toString() !== req.user.id && req.user.role !== "admin")
      return res.status(403).json({ message: "Bạn không có quyền xóa xe này" });

    if (vehicle.imagePublicIds?.length > 0) {
      for (const publicId of vehicle.imagePublicIds) {
        await deleteFileFromCloudinary(publicId);
      }
    }

    await Vehicle.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: "Xóa xe thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi xóa xe", error: error.message });
  }
};

// Lấy xe theo type (có phân trang)
const GetVehicleByType = async (req, res) => {
  try {
    const { type } = req.params;
    const allowed = ["Car", "Motorbike", "Coach", "Bike"];
    if (!allowed.includes(type)) {
      return res.status(400).json({ message: "Loại xe không hợp lệ" });
    }

    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const sort = req.query.sort || "-createdAt";

    const result = await paginate(
      Vehicle,
      { type, available: true, status: { $nin: ["pending", "rejected"] } },
      {
        page,
        limit,
        sort,
        populate: [
          { path: "brandId" },
          { path: "ownerId", select: "_id fullName email role" },
        ],
      }
    );

    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({
      message: "Lỗi khi lấy xe theo loại",
      error: error.message,
    });
  }
};

// ✅ MỚI: Lấy xe không khả dụng (available: false)
const GetUnavailableVehicles = async (req, res) => {
  try {
    const vehicles = await Vehicle.find({ available: false });
    res.status(200).json(vehicles);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Lỗi khi lấy xe không khả dụng", error: error.message });
  }
};

module.exports = {
  GetAllVehicles,
  CreateVehicle,
  UpdateVehicle,
  DeleteVehicle,
  GetVehiclePending,
  ChangeVehicleStatus,
  GetVehicleByType,
  GetUnavailableVehicles,
};
