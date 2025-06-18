const cloudinary = require("../config/cloudinary_instance");

const deleteFileFromCloudinary = async (publicId) => {
  try {
    const result = await cloudinary.uploader.destroy(publicId);
    return result;
  } catch (error) {
    throw new Error(`Không thể xóa tệp trên Cloudinary: ${error.message}`);
  }
};

module.exports = {
  deleteFileFromCloudinary,
};