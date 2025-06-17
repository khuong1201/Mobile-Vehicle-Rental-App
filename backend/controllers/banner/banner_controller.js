const banner = require("../../models/Banner_model");

const CreateBanner = async (req, res) => {
  try {
    const { bannerName, bannerUrl } = req.body;
    if (!req.body) {
      return res.status(400).json({
        success: false,
        message: "Please provide bannerName and banner Image",
      });
    }
    const existed = await banner.findOne({ brandName });
    if (existed) {
      return res.status(400).json({
        success: false,
        message: "banner name is existed",
      });
    }
    const newBanner = await banner.create({ bannerName, bannerUrl });
    res.status(201).json({
      success: true,
      data: newBanner,
      message: "banner created successfully",
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: "error creating banner",
      error: error.message,
    });
  }
};
const UpdateBanner = async (req, res) => {
  try {
    const { id } = req.params;
    const { bannerName, BannerUrl } = req.body;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Invalod ID" });
    }
    const updated = await banner.findByIdandUpdate(id, {
      bannerName,
      BannerUrl,
    });
    if (!updated) {
      res.status(404).json({ success: false, message: "banner not found" });
    }
    res.status(200).json({
      success: true,
      data: updated,
      message: "updated banner successfully",
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      message: "Error update banner",
    });
  }
};

const DeleteBanner = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: "Invalid ID" });
    }
    const deleted = await banner.findByIdAndDelete(id);
    if (!deleted) {
      return res
        .status(404)
        .json({ success: false, message: "Banner not found" });
    }

    res
      .status(200)
      .json({ success: true, message: "Banner deleted successfully" });
  } catch (e) {
    res
      .status(500)
      .json({
        success: false,
        message: "Error deleting brand",
        error: error.message,
      });
  }
};

const GetAllBanner = async (req,res) => {
    try{
        const banners = await banners.find();
        res.status(200).json({
            success: true,
            data: banners,
            message: 'get all banner successfully'
        })
    }catch(e){
        res.status(500).json({
            success: false,
            message: 'Error retrieving banner list',
            error: error.message
          });
    }
}

module.exports = { CreateBanner, DeleteBanner, UpdateBanner,GetAllBanner, };
