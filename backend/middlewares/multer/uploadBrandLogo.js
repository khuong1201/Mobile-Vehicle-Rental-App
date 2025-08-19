const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../../config/cloudinary_instance');

const storage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: 'brands',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp'],
    public_id: (req, file) => `${Date.now()}_${file.originalname}`,
  },
});

const uploadBrandLogo = multer({ storage });

module.exports = uploadBrandLogo;
