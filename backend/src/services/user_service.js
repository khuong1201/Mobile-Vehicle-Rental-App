import { hash } from "../utils/hash.js";

export default class UserService {
  constructor(userRepo, userValidator) {
    this.userRepo = userRepo;
    this.userValidator = userValidator;
  }

  async updatePassword(userId, newPassword) {
    this.userValidator.validatePassword(newPassword);
    const hashedPassword = await hash(newPassword, 10);
    return this.userRepo.updateById(userId, { passwordHash: hashedPassword });
  }

  async getProfile(userId) {
    return this.userRepo.getProfile(userId);
  }

  async updateProfile(userId, payload) {
    this.userValidator.validateProfile(payload);
    return this.userRepo.updateById(userId, payload);
  }

  async updateRole(userId, newRole) {
    this.userValidator.validateRole(newRole);
    return this.userRepo.updateById(userId, { role: newRole });
  }

  async addLicense(userId, licenseData) {
    this.userValidator.validateLicense(licenseData);
    const newLicenseData = { ...licenseData, status: "pending" };
    return this.userRepo.addLicense(userId, newLicenseData);
  }

  async updateLicense(userId, licenseId, payload) {
    this.userValidator.validateLicense(payload);
    const newPayload = { ...payload, status: "pending" };
    return this.userRepo.updateLicense(userId, licenseId, newPayload);
  }

  async deleteLicense(userId, licenseId) {
    return this.userRepo.deleteLicense(userId, licenseId);
  }

  async addAddress(userId, addressData) {
    this.userValidator.validateAddress(addressData);
    return this.userRepo.addAddress(userId, addressData);
  }

  async updateAddress(userId, addressId, payload) {
    this.userValidator.validateAddress(payload);
    return this.userRepo.updateAddress(userId, addressId, payload);
  }

  async deleteAddress(userId, addressId) {
    return this.userRepo.deleteAddress(userId, addressId);
  }
}