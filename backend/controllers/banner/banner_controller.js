const mongoose = require("mongoose");
const Banner = require("../../models/Banner_model");
const { cloudinary } = require("../../config/cloudinary_instance");

// 🟢 Create Banner
const CreateBanner = async (req, res) => {
  try {
    const { bannerName } = req.body;
    const file = req.file;

    if (!bannerName || !file) {
      return res.status(400).json({ success: false, message: "Missing name or image" });
    }

    const exists = await Banner.findOne({ bannerName });
    if (exists) {
      return res.status(400).json({ success: false, message: "Banner name already exists" });
    }

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
    res.status(500).json({
      success: false,
      message: "Error creating banner",
      error: e.message,
    });
  }
};

// 🟡 Update Banner
const UpdateBanner = async (req, res) => {
  try {
    const { id } = req.params;
    const { bannerName } = req.body;
    const file = req.file;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Invalid ID" });
    }

    const banner = await Banner.findById(id);
    if (!banner) {
      return res.status(404).json({ success: false, message: "Banner not found" });
    }

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
    res.status(500).json({
      success: false,
      message: "Error updating banner",
      error: e.message,
    });
  }
};

// 🔴 Delete Banner
const DeleteBanner = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Invalid ID" });
    }

    const banner = await Banner.findByIdAndDelete(id);
    if (!banner) {
      return res.status(404).json({ success: false, message: "Banner not found" });
    }

    if (banner.bannerPublicId) {
      await cloudinary.uploader.destroy(`banners/${banner.bannerPublicId}`);
    }

    res.status(200).json({
      success: true,
      message: "Banner deleted successfully",
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: "Error deleting banner",
      error: e.message,
    });
  }
};

// 🔍 Get All Banners
const GetAllBanner = async (req, res) => {
  try {
    const banners = await Banner.find();
    res.status(200).json({
      success: true,
      data: banners,
      message: "Fetched all banners successfully",
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: "Error fetching banners",
      error: e.message,
    });
  }
};

module.exports = {
  CreateBanner,
  UpdateBanner,
  DeleteBanner,
  GetAllBanner,
};
