import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Sidebar from '../components/Sidebar';
import AdminDashboard from '../pages/AdminDashboard';
import UserList from '../pages/Users/UserList';
import VehicleList from '../pages/Vehicles/VehicleList';
import VehiclePending from '../pages/Vehicles/VehiclePending';
import BrandList from '../pages/Brands/BrandList';
import ReviewList from '../pages/Reviews/ReviewList';

export default function AdminLayout() {
  console.log('AdminLayout: Rendering');
  return (
    <div className="app-layout">
      <Sidebar />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<AdminDashboard />} />
          <Route path="dashboard" element={<AdminDashboard />} />
          <Route path="users" element={<UserList />} />
          <Route path="vehicles" element={<VehicleList />} />
          <Route path="vehicles/pending" element={<VehiclePending />} />
          <Route path="brands" element={<BrandList />} />
          <Route path="reviews" element={<ReviewList />} />
        </Routes>
      </main>
    </div>
  );
}