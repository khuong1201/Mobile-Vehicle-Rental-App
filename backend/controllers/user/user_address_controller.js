const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const GetAddresses = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).select('addresses');
    if (!user) return next(new AppError('Người dùng không tồn tại', 404, "USER_NOT_FOUND"));

    res.json({
      message: 'Addresses retrieved successfully',
      addresses: user.addresses || [], // Return empty array if no addresses
    });
  } catch (err) {
    next(err);
  }
};

const DeleteAddress = async (req, res, next) => {
  try {
    const { addressId } = req.body;

    if (!addressId)  return next(new AppError("Thiếu addressId", 400, "MISSING_ADDRESS_ID"));

    const user = await User.findById(req.user.id);
    if (!user) return next(new AppError("Người dùng không tồn tại", 404, "USER_NOT_FOUND"));

    // Check if address exists
    const addressExists = user.addresses.some(
      (addr) => addr._id.toString() === addressId
    );
    if (!addressExists) return next(new AppError("Không tìm thấy địa chỉ", 400, "ADDRESS_NOT_FOUND"));

    // Remove the address
    user.addresses = user.addresses.filter(
      (addr) => addr._id.toString() !== addressId
    );
    await user.save();

    res.json({
      message: "Address deleted successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        addresses: user.addresses,
      },
    });
  } catch (err) {
    next(err);
  }
};
const UpdateAddress = async (req, res, next) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: "Request body is missing" });
    }
    const {
      addressId,
      addressType,
      address,
      floorOrApartmentNumber,
      contactName,
      phoneNumber,
    } = req.body;
    if (!addressType || !address || !floorOrApartmentNumber || !contactName || !phoneNumber) {
      return next(new AppError("Thiếu thông tin địa chỉ", 400, "MISSING_FIELDS"));
    }
    const user = await User.findById(req.user.id);
    if (!user) return next(new AppError("Người dùng không tồn tại", 404, "USER_NOT_FOUND"));
    user.addresses = user.addresses || [];
    const newAddress = {
      addressType,
      address,
      floorOrApartmentNumber,
      contactName,
      phoneNumber,
    };

    if (addressId) {
      const addressIndex = user.addresses.findIndex(
        (addr) => addr._id.toString() === addressId
      );
      if (addressIndex === -1) return next(new AppError("Không tìm thấy địa chỉ để cập nhật", 400, "ADDRESS_NOT_FOUND"));
      user.addresses[index] = { ...user.addresses[index], ...newAddress };
    } else {
      user.addresses.push(newAddress);
    }

    await user.save();

    res.json({
      message: "Address updated successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        addresses: user.addresses,
      },
    });
  } catch (err) {
    next(err);
  }
};
module.exports = { DeleteAddress, UpdateAddress, GetAddresses };
