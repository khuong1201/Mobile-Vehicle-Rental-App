const mongoose = require('mongoose');
const Vehicle = require("../../models/vehicles/vehicle_model");
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
      { available: true,
        status: { $nin: ["pending", "rejected"] }, 
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
    res
      .status(500)
      .json({
        message: "Lỗi khi cập nhật trạng thái xe",
        error: error.message,
      });
  }
};

// Tạo xe mới
const CreateVehicle = async (req, res) => {
  try {
    const data = req.body;

    // const brand = await Brand.findById(data.brandId);
    // if (!brand)
    //   return res.status(400).json({ message: "Thương hiệu không hợp lệ" });

   let brandId = data.brandId;

    // Nếu brand là một object, lấy _id từ đó
    if (data.brand && data.brand._id) {
      brandId = data.brand._id;
      console.log("Parsed brandId:", brandId);
    }

    brandId = String(brandId);
    if (!mongoose.Types.ObjectId.isValid(brandId)) {
      return res.status(400).json({ message: "ID thương hiệu không hợp lệ" });
    }
    const brand = await Brand.findById(brandId);
    if (!brand) {
      return res.status(400).json({ message: "Thương hiệu không tồn tại" });
    }

    const images = req.files?.images
      ? req.files.images.map((file) => ({
          url: file.path,
          publicId: file.filename,
        }))
      : [];

    const vehicleData = {
      ...data,
      brand: brand._id,
      ownerId: req.user.id,
      images: images.map((img) => img.url),
      imagePublicIds: images.map((img) => img.publicId),
    };

    const vehicle = await Vehicle.create(vehicleData);
    res.status(201).json(vehicle);
  } catch (error) {
    // res
    //   .status(500)
    //   .json({ message: "Lỗi khi tạo xe mới", error: error.message });
    console.error("🔥 Lỗi khi tạo xe mới:", error); // THÊM DÒNG NÀY
    res.status(500).json({ message: "Lỗi khi tạo xe mới", error: error.message });
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
      { type,
        available: true,
        status: { $nin: ["pending", "rejected"] } },
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
