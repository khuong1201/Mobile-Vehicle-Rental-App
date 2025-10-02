import { hash } from "../utils/hash.js";

export default class UserService {
  constructor(userRepo, userValidator, storageAdapter) {
    this.userRepo = userRepo;
    this.userValidator = userValidator;
    this.storageAdapter = storageAdapter;
  }

  async uploadImages(userId, files = []) {
    if (!files.length) return { urls: [], publicIds: [] };
    const uploaded = await Promise.all(
      files.map((file) =>
        this.storageAdapter.upload(file, { folder: `driverLicences/${userId}` })
      )
    );
    return {
      urls: uploaded.map((u) => u.url),
      publicIds: uploaded.map((u) => u.publicId),
    };
  }

  async updatePassword(userId, newPassword) {
    this.userValidator.validatePassword(newPassword);
    const hashedPassword = await hash(newPassword, 10);
    return this.userRepo.updateById(userId, { passwordHash: hashedPassword });
  }

  async getProfile(userId) {
    return this.userRepo.getProfile(userId);
  }

  async getOrtherProfile(ownerId) {
    return this.userRepo.getOrtherProfile(ownerId);
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

    const files = [];
    if (licenseData.frontFile) files.push(licenseData.frontFile);
    if (licenseData.backFile) files.push(licenseData.backFile);

    const uploaded = await this.uploadImages(userId, files);

    const newLicenseData = {
      typeOfDriverLicense: licenseData.typeOfDriverLicense,
      classLicense: licenseData.classLicense,
      licenseNumber: licenseData.licenseNumber,
      driverLicenseFront: uploaded.urls[0] ?? "",
      driverLicenseBack: uploaded.urls[1] ?? "",
      driverLicenseFrontPublicId: uploaded.publicIds[0] ?? "",
      driverLicenseBackPublicId: uploaded.publicIds[1] ?? "",
      status: "approved",
    };

    return this.userRepo.addLicense(userId, newLicenseData);
  }

  async updateLicense(userId, licenseId, licenseData) {
    this.userValidator.validateLicense(licenseData);

    const user = await this.userRepo.findById(userId);
    if (!user) throw new AppError("User not found");

    const license = user.license.find(
      (l) => l.licenseId.toString() === licenseId
    );
    if (!license) throw new AppError("License not found");

    if (licenseData.frontFile) {
      const uploadedFront = await this.uploadImages(userId, [
        licenseData.frontFile,
      ]);
      license.driverLicenseFront = uploadedFront.urls[0];
      license.driverLicenseFrontPublicId = uploadedFront.publicIds[0];
    }

    if (licenseData.backFile) {
      const uploadedBack = await this.uploadImages(userId, [licenseData.backFile]);
      license.driverLicenseBack = uploadedBack.urls[0];
      license.driverLicenseBackPublicId = uploadedBack.publicIds[0];
    }

    license.typeOfDriverLicense =
      licenseData.typeOfDriverLicense ?? license.typeOfDriverLicense;
    license.classLicense = licenseData.classLicense ?? license.classLicense;
    license.licenseNumber = licenseData.licenseNumber ?? license.licenseNumber;

    license.status = "approved"; 

    await user.save();
    return user.license;
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
