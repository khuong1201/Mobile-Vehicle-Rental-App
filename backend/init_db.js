const mongoose = require('mongoose');
const Brand = require('./models/brand_model');
const Vehicle = require('./models/vehicle_model');
const InitStatus = mongoose.model('InitStatus', new mongoose.Schema({
  initialized: { type: Boolean, default: false },
  lastInit: { type: Date }
}));

const initDB = async () => {
  try {
    const status = await InitStatus.findOne();
    if (status && status.initialized) {
      console.log('ℹ️ Cơ sở dữ liệu đã được khởi tạo trước đó.');
      return;
    }

    // Danh sách hãng xe
    const brands = [
      "Mercedes-Benz", "Audi", "BMW", "Toyota", "Mitsubishi",
      "Volkswagen", "Ford", "Lexus", "Hyundai", "VinFast"
    ];

    // Thêm hãng xe nếu chưa tồn tại
    let lastBrand = await Brand.findOne().sort({ brandId: -1 });
    let nextBrandNumber = 1;
    if (lastBrand && lastBrand.brandId && lastBrand.brandId.startsWith('BR')) {
      const number = parseInt(lastBrand.brandId.replace('BR', ''), 10);
      if (!isNaN(number)) nextBrandNumber = number + 1;
    }
    for (const brandName of brands) {
      const exists = await Brand.findOne({ brand: brandName });
      if (!exists) {
        const brandId = 'BR' + String(nextBrandNumber++).padStart(2, '0');
        await Brand.create({ brandId, brand: brandName });
        console.log(`✅ Đã thêm brand mới: ${brandName} (ID: ${brandId})`);
      } else {
        console.log(`ℹ️ Brand đã tồn tại: ${brandName}`);
      }
    }

    // Tạo map để lấy ObjectId của hãng xe
    const savedBrands = await Brand.find();
    const brandMap = {};
    savedBrands.forEach(b => brandMap[b.brand] = b._id);

    // Danh sách xe kèm giá thuê và loại
    const vehicles = [
      { vehicleName: "C-Class", brand: "Mercedes-Benz", type: "Sedan", priceRentalMin: 1800000, priceRentalMax: 3000000 },
      { vehicleName: "E-Class", brand: "Mercedes-Benz", type: "Sedan", priceRentalMin: 2200000, priceRentalMax: 3800000 },
      { vehicleName: "GLC", brand: "Mercedes-Benz", type: "SUV", priceRentalMin: 2000000, priceRentalMax: 3500000 },
      { vehicleName: "GLE", brand: "Mercedes-Benz", type: "SUV", priceRentalMin: 2500000, priceRentalMax: 4500000 },
      { vehicleName: "A4", brand: "Audi", type: "Sedan", priceRentalMin: 1600000, priceRentalMax: 2800000 },
      { vehicleName: "A6", brand: "Audi", type: "Sedan", priceRentalMin: 2000000, priceRentalMax: 3500000 },
      { vehicleName: "Q5", brand: "Audi", type: "SUV", priceRentalMin: 1800000, priceRentalMax: 3200000 },
      { vehicleName: "Q7", brand: "Audi", type: "SUV", priceRentalMin: 2200000, priceRentalMax: 4000000 },
      { vehicleName: "3 Series", brand: "BMW", type: "Sedan", priceRentalMin: 1600000, priceRentalMax: 2800000 },
      { vehicleName: "5 Series", brand: "BMW", type: "Sedan", priceRentalMin: 2000000, priceRentalMax: 3500000 },
      { vehicleName: "X3", brand: "BMW", type: "SUV", priceRentalMin: 1800000, priceRentalMax: 3200000 },
      { vehicleName: "X5", brand: "BMW", type: "SUV", priceRentalMin: 2200000, priceRentalMax: 4000000 },
      { vehicleName: "Vios", brand: "Toyota", type: "Sedan", priceRentalMin: 600000, priceRentalMax: 1000000 },
      { vehicleName: "Camry", brand: "Toyota", type: "Sedan", priceRentalMin: 800000, priceRentalMax: 1400000 },
      { vehicleName: "Innova", brand: "Toyota", type: "MPV", priceRentalMin: 700000, priceRentalMax: 1200000 },
      { vehicleName: "Fortuner", brand: "Toyota", type: "SUV", priceRentalMin: 900000, priceRentalMax: 1600000 },
      { vehicleName: "Xpander", brand: "Mitsubishi", type: "MPV", priceRentalMin: 700000, priceRentalMax: 1300000 },
      { vehicleName: "Outlander", brand: "Mitsubishi", type: "SUV", priceRentalMin: 800000, priceRentalMax: 1400000 },
      { vehicleName: "Tiguan", brand: "Volkswagen", type: "SUV", priceRentalMin: 900000, priceRentalMax: 1500000 },
      { vehicleName: "Ranger", brand: "Ford", type: "Pickup", priceRentalMin: 800000, priceRentalMax: 1400000 },
      { vehicleName: "Everest", brand: "Ford", type: "SUV", priceRentalMin: 1000000, priceRentalMax: 1800000 },
      { vehicleName: "RX", brand: "Lexus", type: "SUV", priceRentalMin: 2500000, priceRentalMax: 4000000 },
      { vehicleName: "NX", brand: "Lexus", type: "SUV", priceRentalMin: 2000000, priceRentalMax: 3500000 },
      { vehicleName: "Accent", brand: "Hyundai", type: "Sedan", priceRentalMin: 550000, priceRentalMax: 950000 },
      { vehicleName: "Elantra", brand: "Hyundai", type: "Sedan", priceRentalMin: 650000, priceRentalMax: 1100000 },
      { vehicleName: "Santa Fe", brand: "Hyundai", type: "SUV", priceRentalMin: 900000, priceRentalMax: 1600000 },
      { vehicleName: "Tucson", brand: "Hyundai", type: "SUV", priceRentalMin: 800000, priceRentalMax: 1400000 },
      { vehicleName: "VF e34", brand: "VinFast", type: "Electric", priceRentalMin: 700000, priceRentalMax: 1200000 },
      { vehicleName: "VF 8", brand: "VinFast", type: "Electric", priceRentalMin: 1200000, priceRentalMax: 2000000 }
    ];

    // Chèn dữ liệu xe nếu chưa có
    let lastVehicle = await Vehicle.findOne().sort({ vehicleId: -1 });
    let nextNumber = 1;
    if (lastVehicle && lastVehicle.vehicleId && lastVehicle.vehicleId.startsWith('VH')) {
      const number = parseInt(lastVehicle.vehicleId.replace('VH', ''), 10);
      if (!isNaN(number)) nextNumber = number + 1;
    }
    for (const v of vehicles) {
      const exists = await Vehicle.findOne({
        vehicleName: v.vehicleName,
        brand: brandMap[v.brand]
      });
      if (!exists) {
        const vehicleId = 'VH' + String(nextNumber++).padStart(2, '0');
        const idExists = await Vehicle.findOne({ vehicleId });
        if (idExists) {
          console.log(`⚠️ vehicleId đã tồn tại: ${vehicleId}, bỏ qua ${v.vehicleName}`);
          continue;
        }
        await Vehicle.create({
          vehicleId,
          vehicleName: v.vehicleName,
          brand: brandMap[v.brand],
          type: v.type,
          priceRentalMin: v.priceRentalMin,
          priceRentalMax: v.priceRentalMax
        });
        console.log(`✅ Đã thêm xe mới: ${v.vehicleName} (ID: ${vehicleId})`);
      } else {
        console.log(`ℹ️ Xe đã tồn tại: ${v.vehicleName} (Brand: ${v.brand})`);
      }
    }

    // Cập nhật trạng thái khởi tạo
    await InitStatus.findOneAndUpdate(
      {},
      { initialized: true, lastInit: new Date() },
      { upsert: true }
    );

    console.log("✅ Khởi tạo dữ liệu hoàn tất.");
  } catch (e) {
    console.error('❌ Lỗi khi khởi tạo dữ liệu:', e.message);
    throw e;
  }
};

module.exports = initDB;