export default class TelemetryRawService {
    constructor(TelemetryRawRepo, TelemetryActiveRepo, validator) {
        this.telemetryRawRepo = TelemetryRawRepo;
        this.telemetryActiveRepo = TelemetryActiveRepo;
        this.validator = validator;
    }

    async create(payload) {
        this.validator.validateCreate(payload);
      
        const raw = await this.telemetryRawRepo.create(payload);
        const rawObj = raw.toObject ? raw.toObject() : raw;
      
        const { deviceId, ts } = rawObj;
        const rawPayload = rawObj.payload?.payload; 
      
        const activeData = {
          deviceId,
          ts,
          location: {
            type: "Point",
            coordinates: rawPayload?.location?.coordinates || [0, 0],
          },
          speedKmh: rawPayload?.speedKmh ?? 0,
          headingDeg: rawPayload?.headingDeg ?? 0,
          batteryV: rawPayload?.batteryV ?? null,
        };
      
        await this.telemetryActiveRepo.create(activeData);
        return raw;
      }
      
    

    async getRecent(deviceId, limit = 50) {
        return this.telemetryRawRepo.getRecentRaw(deviceId, limit);
    }
}