const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');
const Brand = require('./models/vehicles/brand_model');
const Vehicle = require('./models/vehicles/vehicle_model');
const User = require('./models/user_model');
const bcrypt = require('bcrypt');
require('dotenv').config();

const InitStatus = mongoose.model('InitStatus', new mongoose.Schema({
  initialized: { type: Boolean, default: false },
  lastInit: { type: Date }
}));

const initDB = async () => {
  try {
    const adminEmail = process.env.EMAIL_USER;
    const adminPassword = process.env.EMAIL_PASS;

    // Tạo admin user nếu chưa có
    let adminUser = await User.findOne({ email: adminEmail });
    if (!adminUser) {
      const hashedPassword = await bcrypt.hash(adminPassword, 10);
      adminUser = await User.create({
        userId: uuidv4(),
        fullName: 'Administrator',
        email: adminEmail,
        passwordHash: hashedPassword,
        role: 'admin',
        verified: true,
      });
      console.log(`✅ Admin user created: ${adminUser.email}`);
    } else {
      console.log(`ℹ️ Admin user already exists: ${adminEmail}`);
    }

    // Kiểm tra trạng thái đã khởi tạo
    const status = await InitStatus.findOne();
    if (status?.initialized) {
      console.log('ℹ️ Cơ sở dữ liệu đã được khởi tạo trước đó.');
      return;
    }

    // Danh sách hãng xe
    // Danh sách hãng xe kèm logo
const brands = [
  {
    brandName: 'Mercedes',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Audi',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'BMW',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Toyota',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Mitsubishi',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Volkswagen',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Ford',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Lexus',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'Hyundai',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  },
  {
    brandName: 'VinFast',
    brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg'
  }
];

for (const brand of brands) {
  const exists = await Brand.findOne({ brandName: brand.brandName });

  if (!exists) {
    const newBrand = await Brand.create({
      brandName: brand.brandName,
      brandImage: brand.brandImage
    });
    console.log(`✅ Đã thêm brand mới: ${brand.brandName}`);
  } else {
    if (!exists.brandImage) {
      exists.brandImage = brand.brandImage;
      await exists.save();
      console.log(`🔄 Đã cập nhật brandImage cho: ${brand.brandName}`);
    } else {
      console.log(`ℹ️ Brand đã tồn tại: ${brand.brandName}`);
    }
  }
}

    // Ánh xạ brandName -> _id
    const savedBrands = await Brand.find();
    const brandMap = {};
    savedBrands.forEach(b => {
      brandMap[b.brandName] = b._id;
    });

    // Danh sách xe mẫu
    const vehicles = [
      { vehicleName: 'C-Class', brandName: 'Mercedes', type: 'Car', price: 1800000 },
      { vehicleName: 'E-Class', brandName: 'Mercedes', type: 'Car', price: 2200000 },
      { vehicleName: 'GLC', brandName: 'Mercedes', type: 'Car', price: 2000000 },
      { vehicleName: 'Q5', brandName: 'Audi', type: 'Car', price: 1800000 },
      { vehicleName: 'RX', brandName: 'Lexus', type: 'Car', price: 2500000 },
      { vehicleName: 'VF e34', brandName: 'VinFast', type: 'Car', price: 700000 },
      { vehicleName: 'Tucson', brandName: 'Hyundai', type: 'Car', price: 800000 },
      { vehicleName: 'Ranger', brandName: 'Ford', type: 'Car', price: 800000 }
    ];

    for (const v of vehicles) {
      const licensePlate = 'TEMP-' + Math.floor(Math.random() * 10000);
      const exists = await Vehicle.findOne({ licensePlate });

      if (!exists) {
        const newVehicle = await Vehicle.create({
          ownerId: adminUser._id,
          vehicleId: uuidv4(),
          vehicleName: v.vehicleName,
          brandId: brandMap[v.brandName],
          type: v.type,
          licensePlate: licensePlate,
          yearOfManufacture: 2022,
          description: `Mẫu xe ${v.vehicleName} của hãng ${v.brandName}`,
          price: v.price,
          location: {
            address: 'Hà Nội',
            lat: 21.0278,
            lng: 105.8342
          }
        });

        console.log(`✅ Đã thêm xe mới: ${v.vehicleName} (UUID: ${newVehicle.vehicleId})`);
      } else {
        console.log(`ℹ️ Xe đã tồn tại với biển số: ${licensePlate}`);
      }
    }

    // Cập nhật trạng thái đã khởi tạo
    await InitStatus.findOneAndUpdate(
      {},
      { initialized: true, lastInit: new Date() },
      { upsert: true }
    );

    console.log('✅ Khởi tạo dữ liệu hoàn tất.');
  } catch (e) {
    console.error('❌ Lỗi khi khởi tạo dữ liệu:', e.message);
    throw e;
  }
};

module.exports = initDB;
