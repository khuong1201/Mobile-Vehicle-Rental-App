import { SerialPort, ReadlineParser } from "serialport";
import axios from "axios";

class SerialListener {
  constructor(path = "COM4", baudRate = 9600) {
    this.port = new SerialPort({ path, baudRate });
    this.parser = this.port.pipe(new ReadlineParser({ delimiter: "\n" }));

    this.parser.on("data", async (line) => {
      line = line.trim();
      if (!line.startsWith("{")) return;

      try {
        const data = JSON.parse(line);
        console.log("📡 Received from Arduino:", data);

        // Nếu chỉ có imei => gọi check-imei
        if (data.imei && !data.deviceId) {
          try {
            const res = await axios.get(
              `http://localhost:5000/api/devices/check-imei/${data.imei}`
            );
            const { deviceId, deviceToken } = res.data.data;

            // Gửi dạng chuỗi JSON
            this.sendToArduino(JSON.stringify({ deviceId, deviceToken }));
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
    });
  }
  
  sendToArduino(str) {
    // str đã là JSON string
    this.port.write(str + "\n", (err) => {
      if (err) console.error("❌ Error writing to Arduino:", err.message);
      else console.log("➡️ Sent to Arduino:", str);
    });
  }
}

export default new SerialListener();