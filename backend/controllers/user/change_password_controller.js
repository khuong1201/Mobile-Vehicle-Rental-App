const bcrypt = require("bcrypt");
const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");

const ChangePassword = async (req, res, next) => {
  try {
    const { oldPassword, newPassword } = req.body;
    if (!oldPassword || !newPassword) 
      return next(new AppError("oldPassword và newPassword là bắt buộc", 400, "MISSING_PASSWORDS"));
      const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\[\]{};':"\\|,.<>\/?`~\-]).{8,}$/;
    if (!strongPasswordRegex.test(newPassword)) {
      return next(new AppError(
        "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa và 1 ký tự đặc biệt",
        400,
        "PASSWORD_WEAK"
      ));
    }
    const user = await User.findById(req.user.id);
    if (!user)  return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

    if (!user.passwordHash) 
      return next(new AppError("Bạn đang sử dụng đăng nhập Google hoặc cần đặt lại mật khẩu", 400, "NO_PASSWORD_SET"));

    const isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!isMatch) return next(new AppError("Mật khẩu cũ không chính xác", 400, "INCORRECT_OLD_PASSWORD"));

    const passwordHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = passwordHash;
    await user.save();

    res.json({ message: "Password changed successfully" });
  } catch (err) {
    next(err);
  }
};
module.exports = {
  ChangePassword,
};
