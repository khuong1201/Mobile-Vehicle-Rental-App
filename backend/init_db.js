const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const axios = require("axios");
const bcrypt = require("bcrypt");
require("dotenv").config();
const Car = require("./models/vehicles/car_model");
const Motor = require("./models/vehicles/motor_model");
const Coach = require("./models/vehicles/coach_model");
const Bike = require("./models/vehicles/bike_model");
const Brand = require("./models/vehicles/brand_model");
const Vehicle = require("./models/vehicles/vehicle_model");
const User = require("./models/user_model");
const {
  Province,
  District,
  Ward,
} = require("./models/location/location_in_vietnam_model");

const InitStatus = mongoose.model(
  "InitStatus",
  new mongoose.Schema({
    initialized: { type: Boolean, default: false },
    lastInit: { type: Date },
    locationDataInitialized: { type: Boolean, default: false },
  })
);

async function fetchAndStoreData() {
  try {
    const provincesResponse = await axios.get(
      "https://provinces.open-api.vn/api/p/",
      {
        timeout: 10000,
      }
    );
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
          districts: [],
        });
        await province.save();
        console.log(`✅ Tỉnh/thành: ${province.name}`);
      }

      // ➕ Bọc từng request districts
      let districts = [];
      try {
        const districtsResponse = await axios.get(
          `https://provinces.open-api.vn/api/p/${province.code}?depth=2`,
          {
            timeout: 10000,
          }
        );
        districts = districtsResponse.data.districts || [];
      } catch (err) {
        console.warn(
          `⚠️ Không thể lấy danh sách quận/huyện cho tỉnh: ${province.name}`
        );
        continue; // bỏ qua nếu lỗi
      }

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
            wards: [],
          });
          await district.save();
          console.log(`  ↳ Quận/huyện: ${district.name}`);
        }

        if (!province.districts.includes(district._id)) {
          province.districts.push(district._id);
        }

        // ➕ Bọc từng request wards
        let wards = [];
        try {
          const wardsResponse = await axios.get(
            `https://provinces.open-api.vn/api/d/${district.code}?depth=2`,
            {
              timeout: 10000,
            }
          );
          wards = wardsResponse.data.wards || [];
        } catch (err) {
          console.warn(`⚠️ Không thể lấy xã/phường cho quận: ${district.name}`);
          continue;
        }

        for (const wardData of wards) {
          let ward = await Ward.findOne({ code: wardData.code });

          if (!ward) {
            ward = new Ward({
              code: wardData.code,
              name: wardData.name,
              full_name: wardData.name,
              full_name_en: wardData.name,
              division_type: wardData.division_type,
              district_code: district.code,
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

    console.log("✅ Dữ liệu hành chính đã được cập nhật.");
  } catch (error) {
    console.error("❌ Lỗi khi lấy dữ liệu tỉnh/thành:", error.message);
    // Không throw nữa, tránh crash server
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
        fullName: "Administrator",
        email: adminEmail,
        passwordHash: hashedPassword,
        role: "admin",
        verified: true,
      });
      console.log(`✅ Đã tạo admin: ${adminUser.email}`);
    } else {
      console.log(`ℹ️ Admin đã tồn tại: ${adminEmail}`);
    }

    const status = await InitStatus.findOne();
    if (status?.initialized && status?.locationDataInitialized) {
      console.log("ℹ️ Dữ liệu đã được khởi tạo trước đó.");
      return;
    }

    const brands = [
      {
        brandName: "Mercedes",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/9/90/Mercedes-Logo.svg",
      },
      {
        brandName: "Audi",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/9/92/Audi_Logo_2016.svg",
      },
      {
        brandName: "BMW",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/4/44/BMW.svg",
      },
      {
        brandName: "Toyota",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/3/33/Toyota_Logo.svg",
      },
      {
        brandName: "Mitsubishi",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/5/59/Mitsubishi_logo.svg",
      },
      {
        brandName: "Volkswagen",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/6/6a/Volkswagen_logo_2019.svg",
      },
      {
        brandName: "Ford",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/3/3e/Ford_logo_flat.svg",
      },
      {
        brandName: "Lexus",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/d/d2/Lexus_Logo_1989.svg",
      },
      {
        brandName: "Hyundai",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/0/0f/Hyundai_Motor_Company_logo.svg",
      },
      {
        brandName: "VinFast",
        brandImage:
          "https://upload.wikimedia.org/wikipedia/commons/3/38/VinFast_Logo.svg",
      },
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
    savedBrands.forEach((b) => (brandMap[b.brandName] = b._id));

    const vehicles = [
      {
        vehicleName: "C-Class",
        brandName: "Mercedes",
        price: 1800000,
        numberOfSeats: 5,
        fuelType: "Gasoline",
        type: "Car",
      },
      {
        vehicleName: "E-Class",
        brandName: "Mercedes",
        price: 2200000,
        numberOfSeats: 5,
        fuelType: "Gasoline",
        type: "Car",
      },
      {
        vehicleName: "GLC",
        brandName: "Mercedes",
        price: 2000000,
        numberOfSeats: 5,
        fuelType: "Gasoline",
        type: "Car",
      },
      {
        vehicleName: "Q5",
        brandName: "Audi",
        price: 1800000,
        numberOfSeats: 5,
        fuelType: "Gasoline",
        type: "Car",
      },
      {
        vehicleName: "RX",
        brandName: "Lexus",
        price: 2500000,
        numberOfSeats: 5,
        fuelType: "Hybrid",
        type: "Car",
      },
      {
        vehicleName: "VF e34",
        brandName: "VinFast",
        price: 700000,
        numberOfSeats: 5,
        fuelType: "Electric",
        type: "Car",
      },
      {
        vehicleName: "Tucson",
        brandName: "Hyundai",
        price: 800000,
        numberOfSeats: 5,
        fuelType: "Diesel",
        type: "Car",
      },
      {
        vehicleName: "Ranger",
        brandName: "Ford",
        price: 800000,
        numberOfSeats: 5,
        fuelType: "Diesel",
        type: "Car",
      },
    ];
    
    for (const v of vehicles) {
      const licensePlate =
        "TEMP-" +
        Math.floor(Math.random() * 100000)
          .toString()
          .padStart(5, "0");
    
      const exists = await Vehicle.findOne({ licensePlate });
      if (exists) continue;
    
      // Chọn đúng model
      let VehicleModel;
      switch ((v.type || "").toLowerCase()) {
        case "car":
          VehicleModel = Car;
          break;
        case "motor":
          VehicleModel = Motor;
          break;
        case "coach":
          VehicleModel = Coach;
          break;
        case "bike":
          VehicleModel = Bike;
          break;
        default:
          console.warn(`❌ Loại xe không hợp lệ: ${v.type}`);
          continue;
      }
    
      const newVehicle = await VehicleModel.create({
        ownerId: adminUser._id,
        vehicleId: uuidv4(),
        vehicleName: v.vehicleName,
        brand: brandMap[v.brandName],
        licensePlate,
        yearOfManufacture: 2022,
        description: `Mẫu xe ${v.vehicleName} của hãng ${v.brandName}`,
        price: v.price,
        fuelType: v.fuelType,
        numberOfSeats: v.numberOfSeats,
        transmission: "Automatic",
        location: {
          address: "Hà Nội",
          lat: 21.0278,
          lng: 105.8342,
        },
      });
      console.log(`🚗 Đã thêm xe: ${v.vehicleName}`);
    }    

    console.log("🎉 Khởi tạo dữ liệu thành công.");
  } catch (error) {
    console.error("❌ Lỗi khi khởi tạo:", error.message);
    throw error;
  }
};

module.exports = initDB;
