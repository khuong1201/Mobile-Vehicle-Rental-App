import DeviceModel from "../models/device_model.js";
import AppError from "../utils/app_error.js";
import asyncHandler from "./async_handler.js";

const authDeviceToken = asyncHandler(async (req, res, next) => {
  const token = req.headers["x-device-token"];
  if (!token) throw new AppError("Missing device token", 401);

  const device = await DeviceModel.findOne({ deviceToken: token, status: "active" });
  if (!device) throw new AppError("Invalid or inactive device token", 401);

  req.device = device;
  next();
});

export default authDeviceToken;
