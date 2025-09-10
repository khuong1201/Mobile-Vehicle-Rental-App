import IRepo from "./i_repo.js";

export default class ITelemetryRawRepo extends IRepo {
  async getRecentRaw(deviceId, limit = 50) { throw new Error("Not implemented"); }
  async deleteOldRaw(deviceId, beforeTs) { throw new Error("Not implemented"); }
}
