import { Routes, Route } from 'react-router-dom';
import AdminLayout from '../layouts/AdminLayout';
import UserList from '../pages/Users/UserList';
import VehicleList from '../pages/Vehicles/VehicleList';
import VehiclePending from '../pages/Vehicles/VehiclePending';
import BrandList from '../pages/Brands/BrandList';
import ReviewList from '../pages/Reviews/ReviewList';

export default function AdminRoutes() {
  return (
    <Routes>
      <Route path="/admin" element={<AdminLayout />}>
        <Route path="users" element={<UserList />} />
        <Route path="vehicles" element={<VehicleList />} />
        <Route path="vehicles/pending" element={<VehiclePending />} />
        <Route path="brands" element={<BrandList />} />
        <Route path="reviews" element={<ReviewList />} />
      </Route>
    </Routes>
  );
}