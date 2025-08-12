const { GetRevenueByOwner } = require("../../services/user_revenue_service");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const checkOwnerMonthlyTax = asyncHandler(async (req, res, next) => {
  const { userId } = req.params;
  const { month, year } = req.query;

  const parsedMonth = parseInt(month, 10);
  const parsedYear = parseInt(year, 10);

  if (!month || !year) {
    return next(new AppError("Month và Year là bắt buộc", 400, "MISSING_QUERY_PARAMS"));
  }
  if (isNaN(parsedMonth) || parsedMonth < 1 || parsedMonth > 12) {
    return next(new AppError("Tháng không hợp lệ (1-12)", 400, "INVALID_MONTH"));
  }
  if (isNaN(parsedYear) || parsedYear < 2000) {
    return next(new AppError("Năm không hợp lệ", 400, "INVALID_YEAR"));
  }

  const data = await GetRevenueByOwner(userId, parsedMonth, parsedYear);

  res.json({
    message: `Tax & Revenue for owner ${userId} in ${data.month}/${data.year}`,
    ...data,
  });
});

module.exports = { checkOwnerMonthlyTax };
