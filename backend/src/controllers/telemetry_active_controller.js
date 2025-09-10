import asyncHandler from "../middlewares/async_handler.js";

export default class TelemetryActiveController {
    constructor(TelemetryActiveService) {
        this.telemetryActiveService = TelemetryActiveService;

        this.latestTeleActive = asyncHandler(this.latestTeleActive.bind(this));
        this.routeTeleActive = asyncHandler(this.routeTeleActive.bind(this));
        this.nearbyTeleActive = asyncHandler(this.nearbyTeleActive.bind(this));
    }

    async latestTeleActive(req, res) {
        const deviceId = req.params.deviceId;
        const latest = await this.telemetryActiveService.getLatest(deviceId);
        res.json({ status: "Success", data: latest });
    }

    async routeTeleActive(req, res) {
        const deviceId = req.params.deviceId;
        const { from, to } = req.query;
        const data = await this.telemetryActiveService.getRoute(deviceId, new Date(from), new Date(to));
        res.json({ status: "Success", data: data });
    }

    async nearbyTeleActive(req, res) {
        const { lon, lat, radius } = req.query;
        const data = await this.telemetryActiveService.getNearby([parseFloat(lon), parseFloat(lat)], Number(radius));
        res.json({ status: "Success", data: data });
    }
}