const { GetRevenueByOwner } = require('../../services/user_revenue_service');
const AppError = require('../../utils/app_error');

const CheckOwnerMonthlyTax = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const { month, year } = req.query; 
    if (!month || !year) {
      return next(new AppError("Month và Year là bắt buộc", 400, "MISSING_QUERY_PARAMS"));
    }
    const data = await GetRevenueByOwner(userId, parseInt(month), parseInt(year));
    if (isNaN(parsedMonth) || parsedMonth < 1 || parsedMonth > 12) {
      return next(new AppError("Tháng không hợp lệ (1-12)", 400, "INVALID_MONTH"));
    }

    if (isNaN(parsedYear) || parsedYear < 2000) {
      return next(new AppError("Năm không hợp lệ", 400, "INVALID_YEAR"));
    }
    res.json({
      message: `Tax & Revenue for owner ${userId} in ${data.month}/${data.year}`,
      ...data
    });
  } catch (err) {
    next(new AppError("Không thể tính toán doanh thu hàng tháng", 500, "REVENUE_CALCULATION_FAILED"));
  }
};

module.exports = { CheckOwnerMonthlyTax };
