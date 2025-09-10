import { hash, compare } from "../utils/hash.js";
import AppError from "../utils/app_error.js";


export default class OtpService {
  constructor(otpRepo, OtpValidator) {
    this.otpRepo = otpRepo;
    this.validator = OtpValidator;
  }

  async createOtp(userIdentifier, otpCode) {
    this.validator.validateCreate({ identifier: userIdentifier, code: otpCode });

    const otpHash = await hash(otpCode,10);
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); 

    return await this.otpRepo.create({
      userIdentifier,
      otpHash,
      expiresAt,
    });
  }

  async verifyOtp(userIdentifier, otpCode) {
    this.validator.validateVerify({ identifier: userIdentifier, code: otpCode });

    const otpRecord = await this.otpRepo.findValidOtp(userIdentifier);
    if (!otpRecord) throw new AppError("OTP not found or expired", 404);

    const isValid = await compare(otpCode, otpRecord.otpHash);
    if (!isValid) throw new AppError("Invalid OTP", 400);

    await this.otpRepo.delete(otpRecord.otpId);
    return true;
  }
}
