const mongoose = require("mongoose");
const Banner = require("../../models/Banner_model");
const { cloudinary } = require("../../config/cloudinary_instance");
const AppError = require("../../utils/app_error");

const CreateBanner = async (req, res, next) => {
  try {
    const { bannerName } = req.body;
    const file = req.file;

    if (!bannerName || !file) return next(new AppError("Missing name or image", 400, "MISSING_NAME_OR_IMAGE"));

    const exists = await Banner.findOne({ bannerName });
    if (exists) return next(new AppError("Banner name already exists", 400, "BANNER_NAME_EXISTS"));

    const newBanner = await Banner.create({
      bannerName,
      bannerUrl: file.path,
      bannerPublicId: file.filename, // or use file.public_id if needed
    });

    res.status(201).json({
      success: true,
      data: newBanner,
      message: "Banner created successfully",
    });
  } catch (e) {
    next(err);
  }
};

// 🟡 Update Banner
const UpdateBanner = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { bannerName } = req.body;
    const file = req.file;

    if (!mongoose.Types.ObjectId.isValid(id))  return next(new AppError("Invalid ID", 400, "INVALID_ID"));

    const banner = await Banner.findById(id);
    if (!banner) return next(new AppError("Banner not found", 404, "BANNER_NOT_FOUND"));

    // Xoá ảnh cũ nếu có file mới
    if (file && banner.bannerPublicId) {
      await cloudinary.uploader.destroy(`banners/${banner.bannerPublicId}`);
      banner.bannerUrl = file.path;
      banner.bannerPublicId = file.filename;
    }

    if (bannerName) banner.bannerName = bannerName;

    await banner.save();

    res.status(200).json({
      success: true,
      data: banner,
      message: "Banner updated successfully",
    });
  } catch (e) {
    next(err);
  }
};

// 🔴 Delete Banner
const DeleteBanner = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) return next(new AppError("Invalid ID", 400, "INVALID_ID"));

    const banner = await Banner.findByIdAndDelete(id);
    if (!banner) return next(new AppError("Banner not found", 404, "BANNER_NOT_FOUND"));

    if (banner.bannerPublicId) {
      await cloudinary.uploader.destroy(`banners/${banner.bannerPublicId}`);
    }

    res.status(200).json({
      success: true,
      message: "Banner deleted successfully",
    });
  } catch (e) {
    next(err);
  }
};

// 🔍 Get All Banners
const GetAllBanner = async (req, res, next) => {
  try {
    const banners = await Banner.find();
    res.status(200).json({
      success: true,
      data: banners,
      message: "Fetched all banners successfully",
    });
  } catch (e) {
    next(err);
  }
};

module.exports = {
  CreateBanner,
  UpdateBanner,
  DeleteBanner,
  GetAllBanner,
};
