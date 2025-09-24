import { SerialPort, ReadlineParser } from "serialport";
import axios from "axios";
import AppError from "../utils/app_error.js";

class SerialService {
  constructor(deviceRepo, path = "COM4", baudRate = 9600) {
    this.deviceRepo = deviceRepo; 
    this.port = new SerialPort({ path, baudRate });
    this.parser = this.port.pipe(new ReadlineParser({ delimiter: "\n" }));

    this.parser.on("data", this.handleData.bind(this));
  }

  async handleData(line) {
    line = line.trim();
    if (!line.startsWith("{")) return;

    try {
      const data = JSON.parse(line);
      console.log("📡 Received from Arduino:", data);

      if (data.imei && !data.deviceId) {
        try {
          const res = await axios.get(
            `http://localhost:5000/api/devices/check-imei/${data.imei}`
          );
          const { deviceId, deviceToken } = res.data.data;
          this.send(JSON.stringify({ deviceId, deviceToken }));
        } catch (err) {
          console.error("❌ IMEI check failed:", err.message);
        }
        return;
      }

      // Nếu có deviceId + deviceToken => coi như telemetry
      if (data.deviceId && data.deviceToken) {
        await axios.post(
          "http://localhost:5000/api/telemetry-raw/",
          {
            deviceId: data.deviceId,
            ts: new Date(),
            payload: data,
          },
          {
            headers: { "x-device-token": data.deviceToken },
          }
        );

        console.log("✅ Sent telemetry to server successfully");
      }
    } catch (err) {
      console.error("❌ JSON/API error:", err.message);
    }
  }

  send(str) {
    this.port.write(str + "\n", (err) => {
      if (err) console.error("❌ Error writing to Arduino:", err.message);
      else console.log("➡️ Sent to Arduino:", str);
    });
  }

  async sendCommandToDevice(imei, command) {
    const device = await this.deviceRepo.findByImei(imei);
    if (!device) throw new AppError("Device not found", 404);

    this.send(JSON.stringify({ command }));

    if (command === "OFF") {
      await this.deviceRepo.updateByImei(imei, { status: "inactive" });
    }

    if (command === "ON") {
      await this.deviceRepo.updateByImei(imei, { status: "active" });
    }

    return { message: `Command ${command} sent to device ${imei}` };
  }
}

export default SerialService;
