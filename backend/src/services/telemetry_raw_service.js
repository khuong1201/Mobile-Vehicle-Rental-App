export default class TelemetryRawService {
    constructor(TelemetryRawRepo, TelemetryActiveRepo, validator) {
        this.telemetryRawRepo = TelemetryRawRepo;
        this.telemetryActiveRepo = TelemetryActiveRepo;
        this.validator = validator;
    }

    async create(payload) {
        this.validator.validateCreate(payload);
        const raw = await this.telemetryRawRepo.create(payload);
        const { deviceId, ts, payload: rawPayload } = raw;
        const activeData = {
            deviceId,
            ts,
            location: {
                type: "Point",
                coordinates: rawPayload.location?.coordinates || [0, 0],
            },
            speedKmh: rawPayload.speed || 0,
            headingDeg: rawPayload.heading || 0,
            batteryV: rawPayload.batt || null,
        };

        await this.telemetryActiveRepo.create(activeData);

        return raw;
    }

    async getRecent(deviceId, limit = 50) {
        return this.telemetryRawRepo.getRecentRaw(deviceId, limit);
    }
}