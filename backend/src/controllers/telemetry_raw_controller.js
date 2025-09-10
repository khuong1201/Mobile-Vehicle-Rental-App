import asyncHandler from "../middlewares/async_handler.js";

export default class TelemetryRawController {
    constructor(TelemetryRawService) {
        this.telemetryRawService = TelemetryRawService;

        this.createTeleRaw = asyncHandler(this.createTeleRaw.bind(this));
        this.recentTeleRaw = asyncHandler(this.recentTeleRaw.bind(this));
    }

    async createTeleRaw(req, res) {
        const raw = await this.telemetryRawService.create(req.body);
        res.status(201).json({ status: "Success", data: raw});
    }

    async recentTeleRaw(req, res) {
        const deviceId = req.parms.deviceId;
        const { limit = 50 } = req.query;
        const raw = await this.telemetryRawService.getRecent(deviceId, Number(limit));
        res.json({ status: "Success", data: raw});
    }
}