import AppError from "../utils/app_error.js";

export default class DeviceTokenService {
  constructor(userRepo, validator) {
    this.userRepo = userRepo;
    this.validator = validator;
  }

  async registerDeviceToken(userId, token, platform, deviceId) {
    this.validator.validateRegisterToken(token);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found", 404);

    const existing = user.deviceTokens.find(t => t.token === token);

    if (existing) {
      existing.lastUsedAt = new Date();
      existing.platform = platform;
      existing.deviceId = deviceId;
      existing.deleted = false;
    } else {
      user.deviceTokens.push({
        token,
        platform,
        deviceId,
        lastUsedAt: new Date(),
        deleted: false
      });
    }

    await user.save();
    return { message: "Device token registered" };
  }

  async removeDeviceToken(userId, token) {
    this.validator.validateRemoveToken(token);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found", 404);

    let found = false;
    user.deviceTokens = user.deviceTokens.map(t => {
      if (t.token === token) {
        found = true;
        return { ...t, deleted: true };
      }
      return t;
    });

    if (!found) throw new AppError("Device token not found", 404);

    await user.save();
    return { message: "Device token soft deleted" };
  }

  getActiveTokens(user) {
    return user.deviceTokens.filter(t => !t.deleted);
  }
}
