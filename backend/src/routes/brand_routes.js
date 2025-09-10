import { Router } from "express";
import authenticateJWT from "../middlewares/auth_middlerware.js";
import uploadBrand from "../middlewares/upload_brand.js"; 
import BrandController from "../controllers/brand_controller.js";
import BrandService from "../services/brand_service.js";
import BrandValidator from "../validators/brand_validate.js";
import getRepositories from "../repositories/index.js";
import CloudinaryAdapter from "../adapters/storage/cloudinary_adapter.js";
import { authorizeRoles } from "../middlewares/role_middlerware.js";

const router = Router();

const { BrandRepository } = await getRepositories();

const validator = new BrandValidator();
const storageAdapter = new CloudinaryAdapter("brands");
const brandService = new BrandService(BrandRepository, validator, storageAdapter);
const brandController = new BrandController(brandService);

router.use(authenticateJWT);

router.get("/", brandController.getAllBrands);
router.get("/:id", brandController.getBrandById);

router.post(
  "/",
  authorizeRoles("admin", "owner"),
  uploadBrand,
  brandController.createBrand
);

router.patch(
  "/:id",
  authorizeRoles("admin", "owner"),
  uploadBrand,
  brandController.updateBrand
);

router.delete(
  "/:id",
  authorizeRoles("admin", "owner"),
  brandController.deleteBrand
);

export default router;
