const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');
const axios = require('axios');
const bcrypt = require('bcrypt');
require('dotenv').config();

const Brand = require('./models/vehicles/brand_model');
const Vehicle = require('./models/vehicles/vehicle_model');
const User = require('./models/user_model');
const { Province, District, Ward } = require('./models/location/location_in_vietnam_model');

const InitStatus = mongoose.model('InitStatus', new mongoose.Schema({
  initialized: { type: Boolean, default: false },
  lastInit: { type: Date },
  locationDataInitialized: { type: Boolean, default: false }
}));

async function fetchAndStoreData() {
  try {
    const provincesResponse = await axios.get('https://provinces.open-api.vn/api/p/');
    const provinces = provincesResponse.data;

    for (const provinceData of provinces) {
      let province = await Province.findOne({ code: provinceData.code });

      if (!province) {
        province = new Province({
          code: provinceData.code,
          name: provinceData.name,
          full_name: provinceData.name,
          full_name_en: provinceData.name,
          division_type: provinceData.division_type,
          phone_code: provinceData.phone_code,
          districts: []
        });
        await province.save();
        console.log(`✅ Tỉnh/thành: ${province.name}`);
      }

      const districtsResponse = await axios.get(`https://provinces.open-api.vn/api/p/${province.code}?depth=2`);
      const districts = districtsResponse.data.districts || [];

      for (const districtData of districts) {
        let district = await District.findOne({ code: districtData.code });

        if (!district) {
          district = new District({
            code: districtData.code,
            name: districtData.name,
            full_name: districtData.name,
            full_name_en: districtData.name,
            division_type: districtData.division_type,
            province_code: province.code,
            wards: []
          });
          await district.save();
          console.log(`  ↳ Quận/huyện: ${district.name}`);
        }

        if (!province.districts.includes(district._id)) {
          province.districts.push(district._id);
        }

        const wardsResponse = await axios.get(`https://provinces.open-api.vn/api/d/${district.code}?depth=2`);
        const wards = wardsResponse.data.wards || [];

        for (const wardData of wards) {
          let ward = await Ward.findOne({ code: wardData.code });

          if (!ward) {
            ward = new Ward({
              code: wardData.code,
              name: wardData.name,
              full_name: wardData.name,
              full_name_en: wardData.name,
              division_type: wardData.division_type,
              district_code: district.code
            });
            await ward.save();
            console.log(`    ↳ Xã/phường: ${ward.name}`);
          }

          if (!district.wards.includes(ward._id)) {
            district.wards.push(ward._id);
          }
        }

        await district.save();
      }

      await province.save();
    }

    console.log('✅ Dữ liệu hành chính đã được cập nhật.');
  } catch (error) {
    console.error('❌ Lỗi khi lấy/lưu dữ liệu hành chính:', error.message);
    throw error;
  }
}

const initDB = async () => {
  try {
    const adminEmail = process.env.EMAIL_USER;
    const adminPassword = process.env.EMAIL_PASS;

    let adminUser = await User.findOne({ email: adminEmail });
    if (!adminUser) {
      const hashedPassword = await bcrypt.hash(adminPassword, 10);
      adminUser = await User.create({
        userId: uuidv4(),
        fullName: 'Administrator',
        email: adminEmail,
        passwordHash: hashedPassword,
        role: 'admin',
        verified: true
      });
      console.log(`✅ Đã tạo admin: ${adminUser.email}`);
    } else {
      console.log(`ℹ️ Admin đã tồn tại: ${adminEmail}`);
    }

    const status = await InitStatus.findOne();
    if (status?.initialized && status?.locationDataInitialized) {
      console.log('ℹ️ Dữ liệu đã được khởi tạo trước đó.');
      return;
    }

    await fetchAndStoreData();

    const brands = [
      { brandName: 'Mercedes-Benz', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg' },
      { brandName: 'Audi', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/9/92/Audi_Logo_2016.svg' },
      { brandName: 'BMW', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/4/44/BMW.svg' },
      { brandName: 'Toyota', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/3/33/Toyota_Logo.svg' },
      { brandName: 'Mitsubishi', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/5/59/Mitsubishi_logo.svg' },
      { brandName: 'Volkswagen', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/6/6a/Volkswagen_logo_2019.svg' },
      { brandName: 'Ford', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Ford_logo_flat.svg' },
      { brandName: 'Lexus', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/d/d2/Lexus_Logo_1989.svg' },
      { brandName: 'Hyundai', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Hyundai_Motor_Company_logo.svg' },
      { brandName: 'VinFast', brandImage: 'https://upload.wikimedia.org/wikipedia/commons/3/38/VinFast_Logo.svg' }
    ];

    for (const brand of brands) {
      const exists = await Brand.findOne({ brandName: brand.brandName });
      if (!exists) {
        await Brand.create(brand);
        console.log(`✅ Brand: ${brand.brandName}`);
      } else {
        if (!exists.brandImage) {
          exists.brandImage = brand.brandImage;
          await exists.save();
          console.log(`🔄 Cập nhật logo brand: ${brand.brandName}`);
        } else {
          console.log(`ℹ️ Brand đã có: ${brand.brandName}`);
        }
      }
    }

    const savedBrands = await Brand.find();
    const brandMap = {};
    savedBrands.forEach(b => brandMap[b.brandName] = b._id);

    const vehicles = [
      { vehicleName: 'C-Class', brandName: 'Mercedes-Benz', type: 'Car', price: 1800000 },
      { vehicleName: 'E-Class', brandName: 'Mercedes-Benz', type: 'Car', price: 2200000 },
      { vehicleName: 'GLC', brandName: 'Mercedes-Benz', type: 'Car', price: 2000000 },
      { vehicleName: 'Q5', brandName: 'Audi', type: 'Car', price: 1800000 },
      { vehicleName: 'RX', brandName: 'Lexus', type: 'Car', price: 2500000 },
      { vehicleName: 'VF e34', brandName: 'VinFast', type: 'Car', price: 700000 },
      { vehicleName: 'Tucson', brandName: 'Hyundai', type: 'Car', price: 800000 },
      { vehicleName: 'Ranger', brandName: 'Ford', type: 'Car', price: 800000 }
    ];

    for (const v of vehicles) {
      const licensePlate = 'TEMP-' + Math.floor(Math.random() * 100000).toString().padStart(5, '0');
      const exists = await Vehicle.findOne({ licensePlate });
      if (!exists) {
        const newVehicle = await Vehicle.create({
          ownerId: adminUser._id,
          vehicleId: uuidv4(),
          vehicleName: v.vehicleName,
          brandId: brandMap[v.brandName],
          type: v.type,
          licensePlate,
          yearOfManufacture: 2022,
          description: `Mẫu xe ${v.vehicleName} của hãng ${v.brandName}`,
          price: v.price,
          location: {
            address: 'Hà Nội',
            lat: 21.0278,
            lng: 105.8342
          }
        });
        console.log(`🚗 Đã thêm xe: ${v.vehicleName}`);
      }
    }

    await InitStatus.findOneAndUpdate(
      {},
      { initialized: true, locationDataInitialized: true, lastInit: new Date() },
      { upsert: true }
    );

    console.log('🎉 Khởi tạo dữ liệu thành công.');
  } catch (error) {
    console.error('❌ Lỗi khi khởi tạo:', error.message);
    throw error;
  }
};

module.exports = initDB;
