import app from './app.js';
import env from './config/env.js';
import "./utils/serial_listener.js";
app.listen(env.PORT, () => {
  console.log(`Server running in ${env.NODE_ENV} mode on port ${env.PORT}`);
});