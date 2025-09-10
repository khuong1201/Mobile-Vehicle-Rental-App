import TelemetryRaw from "../../models/telemetry_raw_model.js";
import ITelemetryRawRepository from "../interfaces/i_telemetry_raw_repo.js";

export default class TelemetryRawRepositoryMongo extends ITelemetryRawRepository {
  async create(data) { return TelemetryRaw.create(data); }
  async findById(id) { return TelemetryRaw.findById(id); }
  async find(filter, options) { return TelemetryRaw.find(filter, null, options); }
  async update(id, data) { return TelemetryRaw.findByIdAndUpdate(id, data, { new: true }); }
  async delete(id) { return TelemetryRaw.findByIdAndDelete(id); }

  async getRecentRaw(deviceId, limit = 50) {
    return TelemetryRaw.find({ deviceId }).sort({ ts: -1 }).limit(limit);
  }

  async deleteOldRaw(deviceId, beforeTs) {
    return TelemetryRaw.deleteMany({ deviceId, ts: { $lt: beforeTs } });
  }
}
