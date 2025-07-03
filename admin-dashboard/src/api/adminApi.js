import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  withCredentials: true, 
});

api.interceptors.response.use(
  (res) => res,
  async (err) => {
    const originalRequest = err.config;

    if (err.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      try {
        await axios.post(`${api.defaults.baseURL}/auth/refresh-token`, {}, { withCredentials: true });

        return api(originalRequest);
      } catch {
        window.location.href = '/login';
      }
    }

    return Promise.reject(err);
  }
);

export default api;
