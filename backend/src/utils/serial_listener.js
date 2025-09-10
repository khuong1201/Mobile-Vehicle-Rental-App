import { SerialPort, ReadlineParser } from "serialport";
import axios from "axios";

const DEVICE_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2VJZCI6IjNlN2QxMzg5LTg1MjEtNDAwMS05OTRhLTA5ZjViNzZjNThjNCIsImlhdCI6MTc1NzMwNjA2NSwiZXhwIjoxNzg4ODYzNjY1fQ.uAtYnkmwd9c5Tv546jFXrdMzeK0paga3X3cpMLLeBEY";

const port = new SerialPort({ path: "COM4", baudRate: 9600 });
const parser = port.pipe(new ReadlineParser({ delimiter: "\n" }));

parser.on("data", async (line) => {
  line = line.trim();
  if (!line.startsWith("{")) return;

  try {
    const data = JSON.parse(line);
    console.log("📡 Received from Arduino:", data);

    await axios.post("http://localhost:5000/api/telemetry-raw/", {
      deviceId: data.deviceId,
      ts: new Date(),
      payload: data,   
    }, {
      headers: {"x-device-token": DEVICE_TOKEN }
    });

    console.log("✅ Sent to server successfully");
  } catch (err) {
    console.error("❌ JSON/API error:", err.message);
  }
});
