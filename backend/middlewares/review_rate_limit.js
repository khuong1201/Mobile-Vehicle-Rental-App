const rateLimit = require("express-rate-limit");

module.exports = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, 
  message: "You have submitted too many reviews, please try again later."
});
