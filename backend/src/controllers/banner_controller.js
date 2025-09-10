import asyncHandler from "../middlewares/async_handler.js";
import AppError from "../utils/app_error.js";

export default class BannerController {
    constructor(bannerService) {
        this.service = bannerService;

        this.createBanner = asyncHandler(this.createBanner.bind(this));
        this.getBannerById = asyncHandler(this.getBannerById.bind(this));
        this.getAllBanners = asyncHandler(this.getAllBanners.bind(this));
        this.updateBanner = asyncHandler(this.updateBanner.bind(this));
        this.deleteBanner = asyncHandler(this.deleteBanner.bind(this));
    }

    async createBanner(req, res) {
        const file = req.file || null;
        const data = await this.service.createBanner(req.body, file);
        res.json({ status: "success", data });
    }

    async getBannerById(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Banner ID is required", 400);

        const data = await this.service.getBannerById(id);
        res.json({ status: "success", data });
    }

    async getAllBanners(req, res) {
        const data = await this.service.getAllBanners();
        res.json({ status: "success", data });
    }

    async updateBanner(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Banner ID is required", 400);

        const file = req.file || null;
        const data = await this.service.updateBanner(id, req.body, file);
        res.json({ status: "success", data });
    }

    async deleteBanner(req, res) {
        const { id } = req.params;
        if (!id) throw new AppError("Banner ID is required", 400);

        await this.service.deleteBanner(id);
        res.json({ status: "success", message: "Banner deleted successfully" });
    }
}
