import asyncHandler from "../middlewares/async_handler.js";
import AppError from "../utils/app_error.js";

export default class BrandController {
    constructor(brandService) {
        this.service = brandService;

        this.createBrand = asyncHandler(this.createBrand.bind(this));
        this.getBrandById = asyncHandler(this.getBrandById.bind(this));
        this.getAllBrands = asyncHandler(this.getAllBrands.bind(this));
        this.updateBrand = asyncHandler(this.updateBrand.bind(this));
        this.deleteBrand = asyncHandler(this.deleteBrand.bind(this));
    }

    async createBrand(req, res) {
        console.log("req.body:", req.body);
        console.log("req.file:", req.file);
        const file = req.file || null;
        const data = await this.service.createBrand(req.body, file);
        res.json({ status: "success", data });
    }

    async getBrandById(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Brand ID is required", 400);

        const data = await this.service.getBrandById(id);
        res.json({ status: "success", data });
    }

    async getAllBrands(req, res) {
        const data = await this.service.getAllBrands();
        res.json({ status: "success", data });
    }

    async updateBrand(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Brand ID is required", 400);

        const file = req.file || null;
        const data = await this.service.updateBrand(id, req.body, file);
        res.json({ status: "success", data });
    }

    async deleteBrand(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Brand ID is required", 400);

        await this.service.deleteBrand(id);
        res.json({ status: "success", message: "Brand deleted successfully" });
    }
}
