const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");

const UpdatePersonalInfo = async (req, res, next) => {
  try {
    const { fullName, dateOfBirth, phoneNumber, gender, IDs } = req.body;
    if (!fullName || fullName.length < 3) {
      return next(new AppError("Họ tên tối thiểu 3 ký tự", 400, "INVALID_NAME"));
    }

    if (!dateOfBirth) return next(new AppError("Ngày sinh là bắt buộc", 400, "MISSING_DATE_OF_BIRTH"));

    if (!phoneNumber || phoneNumber.length < 10 || phoneNumber.length > 15) {
      return next(new AppError("Số điện thoại phải từ 10 đến 15 ký tự", 400, "INVALID_PHONE"));
    }

    if (!gender) return next(new AppError("Giới tính là bắt buộc", 400, "MISSING_GENDER"));

    if (!IDs || !Array.isArray(IDs) || IDs.length === 0) 
      return next(new AppError("Cần ít nhất 1 giấy tờ tùy thân", 400, "MISSING_IDS"));


    const user = await User.findById(req.user.id);
    if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

    if (fullName) user.fullName = fullName;
    if (dateOfBirth) user.dateOfBirth = dateOfBirth;
    if (phoneNumber) user.phoneNumber = phoneNumber;
    if (IDs) user.IDs = IDs;
    await user.save();
    res.json({
      message: "User details updated successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
        phoneNumber: user.phoneNumber,
        IDs: user.IDs,
      },
    });
  } catch (err) {
    next(err);
  }
};
const GetUserProfile = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).select(
      "-passwordHash -otp -otpExpires -refreshToken"
    );
    if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

    res.json({
      message: "User profile retrieved successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
        phoneNumber: user.phoneNumber,
        gender: user.gender,
        IDs: user.IDs,
        address: user.addresses,
        license: user.license,
        role: user.role,
        verified: user.verified,
        points: user.points,
      },
    });
  } catch (err) {
    next(err);
  }
};
module.exports = {
  UpdatePersonalInfo,
  GetUserProfile,
};
