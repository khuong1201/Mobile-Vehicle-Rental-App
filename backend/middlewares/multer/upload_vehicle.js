const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("../../config/cloudinary_instance");
const path = require("path");

const storage = new CloudinaryStorage({
  cloudinary,
  params: (req, file) => {
    let folder = "vehicles/others";
    if (req.user?.id) {
      folder = `vehicles/${req.user.id}`;
    }
    const cleanFileName = file.originalname.replace(/\.[^/.]+$/, "");
    const ext = path.extname(file.originalname).toLowerCase() || ".jpg"; // Mặc định .jpg nếu không có phần mở rộng

    return {
      folder,
      allowed_formats: ["jpg", "jpeg", "png"],
      public_id: `${Date.now()}_${cleanFileName}`,
      resource_type: "image",
      format: ext.replace(".", ""), // Đảm bảo định dạng khớp với Cloudinary
    };
  },
});

const fileFilter = (req, file, cb) => {
  console.log(`📥 File received: ${file.originalname}, MIME: ${file.mimetype}, Size: ${file.size} bytes`);
  
  const allowedMimeTypes = ["image/jpeg", "image/png", "image/jpg"];
  const allowedExtensions = [".jpg", ".jpeg", ".png"];
  const fileExt = path.extname(file.originalname).toLowerCase();
  
  // Kiểm tra cả MIME type và phần mở rộng
  if (!allowedMimeTypes.includes(file.mimetype) || !allowedExtensions.includes(fileExt)) {
    console.log(`❌ File rejected: ${file.originalname}, Ext: ${fileExt}, MIME: ${file.mimetype}`);
    return cb(new Error("Chỉ chấp nhận tệp JPG hoặc PNG"), false);
  }
  
  console.log(`✅ File accepted: ${file.originalname}`);
  cb(null, true);
};

const uploadVehicle = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // Giới hạn 5MB
  fileFilter,
});

module.exports = uploadVehicle.fields([{ name: "images", maxCount: 10 }]);