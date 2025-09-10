import { Router } from "express";
import authenticateJWT from "../middlewares/auth_middlerware.js";
import uploadBanner from "../middlewares/upload_banner.js"; 
import BannerController from "../controllers/banner_controller.js";
import BannerService from "../services/banner_service.js";
import BannerValidator from "../validators/banner_validate.js";
import getRepositories from "../repositories/index.js";
import CloudinaryAdapter from "../adapters/storage/cloudinary_adapter.js";
import { authorizeRoles } from "../middlewares/role_middlerware.js";

const router = Router();

const { BannerRepository } = await getRepositories();

const validator = new BannerValidator();
const storageAdapter = new CloudinaryAdapter("banners");
const bannerService = new BannerService(BannerRepository, validator, storageAdapter);
const bannerController = new BannerController(bannerService);

router.use(authenticateJWT);

router.get("/", bannerController.getAllBanners);
router.get("/:id", bannerController.getBannerById);

router.post(
  "/",
  authorizeRoles("admin"),
  uploadBanner,
  bannerController.createBanner
);

router.patch(
  "/:id",
  authorizeRoles("admin"),
  uploadBanner,
  bannerController.updateBanner
);

router.delete(
  "/:id",
  authorizeRoles("admin"),
  bannerController.deleteBanner
);

export default router;
