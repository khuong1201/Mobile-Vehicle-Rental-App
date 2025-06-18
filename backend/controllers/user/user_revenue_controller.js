const { GetRevenueByOwner } = require('../../services/user_revenue_service');

const CheckOwnerMonthlyTax = async (req, res) => {
  try {
    const { userId } = req.params;
    const { month, year } = req.query; // lấy từ URL query ?month=6&year=2025

    const data = await GetRevenueByOwner(userId, parseInt(month), parseInt(year));

    res.json({
      message: `Tax & Revenue for owner ${userId} in ${data.month}/${data.year}`,
      ...data
    });
  } catch (err) {
    res.status(500).json({ message: 'Error calculating monthly revenue', error: err.message });
  }
};

module.exports = { CheckOwnerMonthlyTax };
