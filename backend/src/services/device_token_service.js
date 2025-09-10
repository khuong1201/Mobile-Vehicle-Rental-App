import AppError from "../utils/app_error.js";

export default class DeviceTokenService {
  constructor(userRepo, validator) {
    this.userRepo = userRepo;
    this.validator = validator; 
  }

  async registerDeviceToken(userId, token) {
    this.validator.validateRegisterToken(token);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found", 404);

    if (!user.deviceTokens.includes(token)) {
      user.deviceTokens.push(token);
      await user.save();
    }

    return { message: "Device token registered" };
  }

  async removeDeviceToken(userId, token) {
    this.validator.validateRemoveToken(token);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found", 404);

    user.deviceTokens = user.deviceTokens.filter(t => t !== token);
    await user.save();

    return { message: "Device token removed" };
  }
}
