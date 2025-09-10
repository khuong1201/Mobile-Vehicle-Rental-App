import IRepo from './i_repo.js';

export default class IUserRepo extends IRepo {
  async findByEmail(email) { throw new Error('Not implemented'); }

  async updateRole(userId, role) { throw new Error('Not implemented'); }

  async addLicense(userId, licenseData) { throw new Error('Not implemented'); }
  async updateLicense(userId, licenseId, payload) { throw new Error('Not implemented'); }
  async deleteLicense(userId, licenseId) { throw new Error('Not implemented'); }

  async addAddress(userId, addressData) { throw new Error('Not implemented'); }
  async updateAddress(userId, addressId, payload) { throw new Error('Not implemented'); }
  async deleteAddress(userId, addressId) { throw new Error('Not implemented'); }
}
