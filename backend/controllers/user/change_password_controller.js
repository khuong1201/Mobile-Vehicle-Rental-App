const bcrypt = require("bcrypt");
const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const changePassword = asyncHandler(async (req, res, next) => {
  const { oldPassword, newPassword } = req.body;

  if (!oldPassword || !newPassword) {
    return next(
      new AppError("Both oldPassword and newPassword are required", 400, "MISSING_PASSWORDS")
    );
  }

  const strongPasswordRegex =
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\[\]{};':"\\|,.<>\/?`~\-]).{8,}$/;

  if (!strongPasswordRegex.test(newPassword)) {
    return next(
      new AppError(
        "Password must be at least 8 characters long and contain 1 uppercase letter, 1 number, and 1 special character",
        400,
        "PASSWORD_WEAK"
      )
    );
  }

  const user = await User.findById(req.user.id);
  if (!user) {
    return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  }

  if (!user.passwordHash) {
    return next(
      new AppError(
        "You are using Google login or have not set a password. Please reset your password.",
        400,
        "NO_PASSWORD_SET"
      )
    );
  }

  const isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
  if (!isMatch) {
    return next(new AppError("Old password is incorrect", 400, "INCORRECT_OLD_PASSWORD"));
  }

  user.passwordHash = await bcrypt.hash(newPassword, 10);
  await user.save();

  return res.success("Password changed successfully", {
    user: {
      id: user._id,
      userId: user.userId,
      email: user.email,
      fullName: user.fullName,
    },
  });
});

module.exports = { changePassword };
