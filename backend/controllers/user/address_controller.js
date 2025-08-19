const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const getAddresses = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.user.id).select("addresses");
  if (!user) {
    return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  }

  res.success("Addresses retrieved successfully", {
    addresses: user.addresses || [],
  });
});

const deleteAddress = asyncHandler(async (req, res, next) => {
  const { addressId } = req.body;
  if (!addressId) {
    return next(new AppError("Missing addressId", 400, "MISSING_ADDRESS_ID"));
  }

  const user = await User.findById(req.user.id);
  if (!user) {
    return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  }

  const addressExists = user.addresses.some(
    (addr) => addr._id.toString() === addressId
  );
  if (!addressExists) {
    return next(new AppError("Address not found", 400, "ADDRESS_NOT_FOUND"));
  }

  user.addresses = user.addresses.filter(
    (addr) => addr._id.toString() !== addressId
  );
  await user.save();

  res.success("Address deleted successfully", {
    user: {
      id: user._id,
      userId: user.userId,
      email: user.email,
      fullName: user.fullName,
      addresses: user.addresses,
    },
  });
});

const updateAddress = asyncHandler(async (req, res, next) => {
  const {
    addressId,
    addressType,
    address,
    floorOrApartmentNumber,
    contactName,
    phoneNumber,
  } = req.body;

  if (!addressType || !address || !floorOrApartmentNumber || !contactName || !phoneNumber) {
    return next(new AppError("Missing address fields", 400, "MISSING_FIELDS"));
  }

  const user = await User.findById(req.user.id);
  if (!user) {
    return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  }

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
    if (addressIndex === -1) {
      return next(new AppError("Address not found for update", 400, "ADDRESS_NOT_FOUND"));
    }
    user.addresses[addressIndex] = {
      ...user.addresses[addressIndex]._doc,
      ...newAddress,
    };
  } else {
    user.addresses.push(newAddress);
  }

  await user.save();

  res.success("Address updated successfully", {
    user: {
      id: user._id,
      userId: user.userId,
      email: user.email,
      fullName: user.fullName,
      addresses: user.addresses,
    },
  });
});

module.exports = { getAddresses, deleteAddress, updateAddress };
