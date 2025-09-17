import TelemetryRaw from "../../models/telemetry_raw_model.js";
import ITelemetryRawRepository from "../interfaces/i_telemetry_raw_repo.js";

export default class TelemetryRawRepositoryMongo extends ITelemetryRawRepository {
  async create(data) {
    const doc = await TelemetryRaw.create(data);
    return doc.toObject(); 
  }

  async findById(id) {
    return TelemetryRaw.findById(id).lean(); 
  }

  async find(filter, options) {
    return TelemetryRaw.find(filter, null, options).lean();
  }

  async update(id, data) {
    return TelemetryRaw.findByIdAndUpdate(id, data, { new: true }).lean();
  }

  async delete(id) {
    return TelemetryRaw.findByIdAndDelete(id).lean();
  }

  async getRecentRaw(deviceId, limit = 50) {
    return TelemetryRaw.find({ deviceId })
      .sort({ ts: -1 })
      .limit(limit)
      .lean();
  }

  async deleteOldRaw(deviceId, beforeTs) {
    return TelemetryRaw.deleteMany({ deviceId, ts: { $lt: beforeTs } });
  }
}
