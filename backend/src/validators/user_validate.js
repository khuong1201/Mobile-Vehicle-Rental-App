import AppError from "../utils/app_error.js";

export default class UserValidator {
    validateRole(role) {
        if (!["renter", "owner"].includes(role)) {
            throw new AppError("Only renter or owner roles are allowed");
        }
    }

    validatePassword(password) {
        if (!password || password.length < 6) {
            throw new AppError("Password must be at least 6 characters long");
        }
    }

    validateProfile(payload) {
        const { fullName, dateOfBirth, phoneNumber, gender, nationalIdNumber } = payload;
        if (!fullName) throw new AppError("Full name is required");
        if (!dateOfBirth) throw new AppError("Date of birth is required");
        if (!phoneNumber) throw new AppError("Phone number is required");
        if (!gender) throw new AppError("Gender is required");
        if (!nationalIdNumber) throw new AppError("IDs is required");
    }

    validateLicense(licenseData) {
        if (!licenseData.licenseNumber) throw new AppError("License number is required");
        if (!licenseData.typeOfDriverLicense) throw new AppError("typeOfDriverLicense is required");
        if (!licenseData.classLicense) throw new AppError("classLicense is required");
    }

    validateAddress(addressData) {
        const { addressType, address, floorOrApartmentNumber, contactName, phoneNumber } = addressData;
        if (!addressType || typeof addressType !== "string") throw new AppError("addressType is required and must be a string", 400);
        if (!address || typeof address !== "string") throw new AppError("address is required and must be a string", 400);
        if (!floorOrApartmentNumber || typeof floorOrApartmentNumber !== "string") throw new AppError("floorOrApartmentNumber is required and must be a string", 400);
        if (!contactName || typeof contactName !== "string") throw new AppError("contactName is required and must be a string", 400);
        const phoneRegex = /^[0-9]{9,12}$/;
        if (!phoneNumber || !phoneRegex.test(phoneNumber)) throw new AppError("phoneNumber is required and must be a valid number", 400);
    }
}
