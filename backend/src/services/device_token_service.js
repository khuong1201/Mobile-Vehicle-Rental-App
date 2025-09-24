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
    } else {
      user.deviceTokens.push({
        token,
        platform,
        deviceId,
        lastUsedAt: new Date()
      });
    }

    await user.save();
    return { message: "Device token registered" };
  }

  async removeDeviceToken(userId, token) {
    this.validator.validateRemoveToken(token);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found", 404);

    user.deviceTokens = user.deviceTokens.filter(t => t.token !== token);
    await user.save();

    return { message: "Device token removed" };
  }
}
