export default class IStorageAdapter {
    async upload(file, options = {}) {
      throw new Error("Method 'upload' not implemented");
    }
  
    async delete(publicId) {
      throw new Error("Method 'delete' not implemented");
    }
  
    async getUrl(publicId) {
      throw new Error("Method 'getUrl' not implemented");
    }
  }
  