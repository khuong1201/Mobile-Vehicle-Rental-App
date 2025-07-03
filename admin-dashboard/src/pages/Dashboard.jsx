import '../styles/layout.css';
import { useEffect, useState } from 'react';
import api from '../api/adminApi';

function Dashboard() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalVehicles: 0,
    totalBrands: 0,
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const timestamp = Date.now();
        const usersRes = await api.get(`/admin/get-all-user?t=${timestamp}`);
        const vehiclesRes = await api.get(`/admin/all-vehicles?t=${timestamp}`);
        const brandsRes = await api.get(`/admin/get-all-banner?t=${timestamp}`);

        setStats({
          totalUsers: usersRes.data.length,
          totalVehicles: vehiclesRes.data.length,
          totalBrands: brandsRes.data.length,
        });
      } catch (err) {
        console.error('Lỗi khi lấy thống kê:', err);
      }
    };

    fetchData();
  }, []);

  return (
    <div className="layout-content">
      <h1>Trang tổng quan</h1>
      <p>Chào mừng bạn đến với trang quản trị!</p>
      <div style={{ display: 'flex', gap: '2rem', marginTop: '2rem' }}>
        <div>
          <h3>👤 Người dùng</h3>
          <p>{stats.totalUsers}</p>
        </div>
        <div>
          <h3>🚗 Phương tiện</h3>
          <p>{stats.totalVehicles}</p>
        </div>
        <div>
          <h3>🏷️ Thương hiệu</h3>
          <p>{stats.totalBrands}</p>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;