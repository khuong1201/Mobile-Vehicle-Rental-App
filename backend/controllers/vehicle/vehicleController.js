const mongoose = require("mongoose");
const Vehicle = require("../../models/vehicles/vehicle_model");
const Car = require("../../models/vehicles/car_model");
const Motor = require("../../models/vehicles/motor_model");
const Coach = require("../../models/vehicles/coach_model");
const Bike = require("../../models/vehicles/bike_model");
const AppError = require("../../utils/app_error");
const Brand = require("../../models/vehicles/brand_model");
const { checkExpiredBookings } = require("../booking/booking_controller");
const {
  deleteFileFromCloudinary,
} = require("../../services/cloudinary_service");
const paginate = require("../../utils/paginate");

const GetAllVehicles = async (req, res, next) => {
  try {
    await checkExpiredBookings();

    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const sort = req.query.sort || "-createdAt";

    const result = await paginate(
      Vehicle,
      {
        available: true,
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
  } catch (err) {
    next(err);
  }
};
const GetAllVehiclesForAdmin = async (req, res, next) => {
  try {
    const vehicles = await Vehicle.find().populate("brand", "brandName");

    res.json({
      vehicles: vehicles.map(v => ({
        vehicleId: v.vehicleId,
        vehicleName: v.vehicleName,
        licensePlate: v.licensePlate,
        brand: v.brand?.BrandName || "unknown",
        price: v.price,
        status: v.status,
        images: v.images,
        createdAt: v.createdAt,
      }))
    });
  } catch (err) {
    next(err);
  }
};

const GetVehiclePending = async (req, res, next) => {
  try {
    const vehicles = await Vehicle.find({ status: "pending" }).populate("brand", "brandName");

    res.json({
      vehicles: vehicles.map(v => ({
        vehicleId: v.vehicleId,
        vehicleName: v.vehicleName,
        licensePlate: v.licensePlate,
        brand: v.brand?.brandName || "unknown",
        price: v.price,
        images: v.images,
        status: v.status,
      }))
    });
  } catch (err) {
    next(err);
  }
};


const ChangeVehicleStatus = async (req, res, next) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const vehicle = await Vehicle.findOne({ vehicleId: id });
    if (!vehicle) return next(new AppError("Không tìm thấy xe", 404, "VEHICLE_NOT_FOUND"));

    vehicle.status = status;
    await vehicle.save();

    res.json({ message: "Cập nhật trạng thái xe thành công" });
  } catch (err) {
    next(err);
  }
};


const CreateVehicle = async (req, res, next) => {
  try {
    const data = req.body;
    console.log("📥 Dữ liệu xe mới:", data);
    const rawType = (data.type || "").toLowerCase();
    if (!["car", "motor", "coach", "bike"].includes(rawType)) {
      return next(new AppError("Loại xe không hợp lệ", 400, "INVALID_VEHICLE_TYPE"));
    }
    const brandId = data.brand;
    if (!brandId || !mongoose.Types.ObjectId.isValid(brandId)) {
      return next(new AppError("Thương hiệu không hợp lệ", 400, "INVALID_BRAND_ID"));
    }
    const brand = await Brand.findById(brandId);
    if (!brand) {
      return next(new AppError("Thương hiệu không tồn tại", 404, "BRAND_NOT_FOUND"));
    }

    let parsedLocation;
    try {
      parsedLocation =
        typeof data.location === "string"
          ? JSON.parse(data.location)
          : data.location;
    } catch (err) {
      console.warn("⚠️ Lỗi khi parse location:", err.message);
      parsedLocation = undefined;
    }
    let parsedBankAccount;
    try {
      parsedBankAccount =
        typeof data.ownerBankAccount === "string"
          ? JSON.parse(data.ownerBankAccount)
          : data.ownerBankAccount;
    } catch (err) {
      console.warn("⚠️ Lỗi khi parse bankAccount:", err.message);
      parsedBankAccount = {
        accountNumber: "",
        bankName: "",
        accountHolderName: "",
      };
    }

    const images = req.files?.images || [];
    const imageInfos = images.map((file) => ({
      url: file.path,
      publicId: file.filename,
    }));

    const baseVehicleData = {
      vehicleName: data.vehicleName || "Default Vehicle",
      licensePlate: data.licensePlate,
      brand: brand._id,
      model: data.model,
      yearOfManufacture: data.yearOfManufacture,
      images: imageInfos.map((i) => i.url),
      imagePublicIds: imageInfos.map((i) => i.publicId),
      description: data.description,
      location: parsedLocation,
      price: parseFloat(data.price || 0),
      bankAccount: parsedBankAccount,
      rate: parseFloat(data.rate || 0),
      available: data.available === "true" || data.available === true,
      status: data.status || "pending",
      ownerId: req.user.id,
      ownerEmail: req.user.email,
    };

    let vehicle;

    switch (rawType) {
      case "car":
        vehicle = await Car.create({
          ...baseVehicleData,
          fuelType: data.fuelType || "",
          transmission: data.transmission || "Automatic",
          numberOfSeats: parseFloat(data.numberOfSeats || 4),
        });
        break;

      case "motor":
        vehicle = await Motor.create({
          ...baseVehicleData,
          fuelType: data.fuelType || "",
        });
        break;

      case "coach":
        vehicle = await Coach.create({
          ...baseVehicleData,
          fuelType: data.fuelType || "",
          transmission: data.transmission || "Manual",
          numberOfSeats: parseFloat(data.numberOfSeats || 16),
        });
        break;

      case "bike":
        vehicle = await Bike.create({...baseVehicleData});
        break;

      default:
        return next(new AppError("Loại xe không hợp lệ", 400, "INVALID_VEHICLE_TYPE"));
    }

    return res.status(201).json(vehicle);
  } catch (err) {
    next(err);
  }
};
const UpdateVehicle = async (req, res, next) => {
  try {
    const { id } = req.params;
    const data = req.body;

    const vehicle = await Vehicle.findById(id);
    if (!vehicle) return next(new AppError("Không tìm thấy xe", 404, "VEHICLE_NOT_FOUND"));

    if (vehicle.ownerId.toString() !== req.user.id)
      return next(new AppError("Bạn không có quyền sửa xe này", 403, "NOT_AUTHORIZED"));

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
  } catch (err) {
    next(err);
  }
};

const DeleteVehicle = async (req, res, next) => {
  try {
    const vehicle = await Vehicle.findById(req.params.id);
    if (!vehicle)
      return next(new AppError("Không tìm thấy xe", 404, "VEHICLE_NOT_FOUND"));

    if (vehicle.ownerId.toString() !== req.user.id && req.user.role !== "admin")
      return next(new AppError("Bạn không có quyền xóa xe này", 403, "NOT_AUTHORIZED"));
    if (vehicle.imagePublicIds?.length > 0) {
      for (const publicId of vehicle.imagePublicIds) {
        await deleteFileFromCloudinary(publicId);
      }
    }
    await Vehicle.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: "Xóa xe thành công" });
  } catch (err) {
    next(err);
  }
};

const GetVehicleByType = async (req, res, next) => {
  try {
    const { type } = req.params;
    const allowed = ["Car", "Motorbike", "Coach", "Bike"];
    if (!allowed.includes(type)) {
      return next(new AppError("Loại xe không hợp lệ", 400, "INVALID_VEHICLE_TYPE"));
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
  } catch (err) {
    next(err);
  }
};

const GetUnavailableVehicles = async (req, res, next) => {
  try {
    await checkExpiredBookings();
    const vehicles = await Vehicle.find({ available: false });
    res.status(200).json(vehicles);
  } catch (err) {
    next(err);
  }
};

module.exports = {
  GetAllVehiclesForAdmin,
  GetAllVehicles,
  CreateVehicle,
  UpdateVehicle,
  DeleteVehicle,
  GetVehiclePending,
  ChangeVehicleStatus,
  GetVehicleByType,
  GetUnavailableVehicles,
};
