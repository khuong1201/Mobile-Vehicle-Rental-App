const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');
const Brand = require('./models/brand_model');
const Vehicle = require('./models/vehicle_model'); // base model
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
    for (const brandName of brands) {
      const exists = await Brand.findOne({ brand: brandName });
      if (!exists) {
        const brandId = 'BR' + uuidv4().slice(0, 6).toUpperCase();
        await Brand.create({ brandId, brand: brandName });
        console.log(`✅ Đã thêm brand mới: ${brandName} (ID: ${brandId})`);
      } else {
        console.log(`ℹ️ Brand đã tồn tại: ${brandName}`);
      }
    }

    // Map tên brand → _id
    const savedBrands = await Brand.find();
    const brandMap = {};
    savedBrands.forEach(b => brandMap[b.brand] = b._id);

    // Danh sách xe mẫu
    const vehicles = [
      { vehicleName: "C-Class", brand: "Mercedes-Benz", type: "Car", pricePerHour: 1800000 },
      { vehicleName: "E-Class", brand: "Mercedes-Benz", type: "Car", pricePerHour: 2200000 },
      { vehicleName: "GLC", brand: "Mercedes-Benz", type: "Car", pricePerHour: 2000000 },
      { vehicleName: "Q5", brand: "Audi", type: "Car", pricePerHour: 1800000 },
      { vehicleName: "RX", brand: "Lexus", type: "Car", pricePerHour: 2500000 },
      { vehicleName: "VF e34", brand: "VinFast", type: "Car", pricePerHour: 700000 },
      { vehicleName: "Tucson", brand: "Hyundai", type: "Car", pricePerHour: 800000 },
      { vehicleName: "Ranger", brand: "Ford", type: "Car", pricePerHour: 800000 }
    ];

    for (const v of vehicles) {
      const exists = await Vehicle.findOne({
        vehicleName: v.vehicleName,
        brand: brandMap[v.brand]
      });

      if (!exists) {
        const vehicleId = uuidv4();

        await Vehicle.create({
          vehicleId,
          vehicleName: v.vehicleName,
          brand: brandMap[v.brand],
          pricePerHour: v.pricePerHour,
          type: v.type, // discriminator key
          licensePlate: 'TEMP-' + Math.floor(Math.random() * 10000),
          yearOfManufacture: 2022,
          description: `Mẫu xe ${v.vehicleName} của hãng ${v.brand}`,
          location: {
            address: "Hà Nội",
            lat: 21.0278,
            lng: 105.8342
          }
        });

        console.log(`✅ Đã thêm xe mới: ${v.vehicleName} (UUID: ${vehicleId})`);
      } else {
        console.log(`ℹ️ Xe đã tồn tại: ${v.vehicleName}`);
      }
    }

    // Đánh dấu đã khởi tạo
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
