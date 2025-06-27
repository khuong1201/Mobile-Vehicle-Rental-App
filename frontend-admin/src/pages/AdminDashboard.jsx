import React, { useEffect, useState } from 'react';
import { getAllUsers, getAllVehicles, getPendingVehicles, getAllBrands } from '../services/adminService';

export default function AdminDashboard() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalVehicles: 0,
    pendingVehicles: 0,
    totalBrands: 0,
  });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [usersRes, vehiclesRes, pendingRes, brandsRes] = await Promise.all([
          getAllUsers(),
          getAllVehicles(),
          getPendingVehicles(),
          getAllBrands(),
        ]);

        setStats({
          totalUsers: usersRes.data.length,
          totalVehicles: vehiclesRes.data.length,
          pendingVehicles: pendingRes.data.length,
          totalBrands: brandsRes.data.length,
        });
      } catch (err) {
        console.error('Failed to fetch admin stats:', err);
      }
    };

    fetchStats();
  }, []);

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">📊 Admin Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white shadow-md p-4 rounded-lg">
          <h2 className="text-lg font-semibold text-gray-700">👥 Users</h2>
          <p className="text-2xl text-gray-900">{stats.totalUsers}</p>
        </div>
        <div className="bg-white shadow-md p-4 rounded-lg">
          <h2 className="text-lg font-semibold text-gray-700">🚗 Vehicles</h2>
          <p className="text-2xl text-gray-900">{stats.totalVehicles}</p>
        </div>
        <div className="bg-white shadow-md p-4 rounded-lg">
          <h2 className="text-lg font-semibold text-gray-700">⏳ Pending Vehicles</h2>
          <p className="text-2xl text-gray-900">{stats.pendingVehicles}</p>
        </div>
        <div className="bg-white shadow-md p-4 rounded-lg">
          <h2 className="text-lg font-semibold text-gray-700">🏷️ Brands</h2>
          <p className="text-2xl text-gray-900">{stats.totalBrands}</p>
        </div>
      </div>
    </div>
  );
}