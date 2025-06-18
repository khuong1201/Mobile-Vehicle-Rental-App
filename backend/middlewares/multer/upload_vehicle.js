const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("../../config/cloudinary_instance");

const storage = new CloudinaryStorage({
  cloudinary,
  params: (req, file) => {
    let folder = "vehicles/others";
    if (req.user?.id) {
      folder = `vehicles/${req.user.id}`;
    }
    const cleanFileName = file.originalname.replace(/\.[^/.]+$/, "");

    return {
      folder,
      allowed_formats: ["jpg", "jpeg", "png"],
      public_id: `${Date.now()}_${cleanFileName}`,
      resource_type: "image",
    };
  },
});

const uploadVehicle = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, 
  fileFilter: (req, file, cb) => {
    const allowedTypes = ["image/jpeg", "image/png"];
    if (!allowedTypes.includes(file.mimetype)) {
      return cb(new Error("Chỉ chấp nhận tệp JPG hoặc PNG"));
    }
    cb(null, true);
  },
});

module.exports = uploadVehicle.fields([{ name: "images", maxCount: 10 }]); 