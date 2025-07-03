import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import RequireAuth from './components/RequireAuth';
import Sidebar from './components/Sidebar';
import Login from './pages/auth/Login';
import UserList from './pages/users/UserList';
import UserProfile from './pages/users/UserProfile';
import VehicleList from './pages/vehicles/VehicleList';
import PendingVehicles from './pages/vehicles/PendingVehicles';
import BrandList from './pages/brands/BrandList';
import CreateBrand from './pages/brands/CreateBrand';
import UpdateBrand from './pages/brands/UpdateBrand';
import ReviewDetail from './pages/reviews/ReviewDetail';
import UnapprovedLicenses from './pages/users/UnapprovedLicenses';
import Dashboard from './pages/Dashboard';

function ProtectedLayout({ children }) {
  return (
    <RequireAuth>
      <div style={{ display: 'flex' }}>
        <Sidebar />
        <div className="layout-content" style={{ flex: 1 }}>{children}</div>
      </div>
    </RequireAuth>
  );
}

function AppRouter() {
  const isLoggedIn = !!localStorage.getItem('accessToken');

  return (
    <Router>
      <Routes>
        {/* ✅ Route mặc định: tự động chuyển hướng khi vào trang gốc */}
        <Route
          path="/"
          element={<Navigate to={isLoggedIn ? "/dashboard" : "/login"} replace />}
        />

        <Route path="/login" element={<Login />} />

        <Route
          path="/dashboard"
          element={
            <ProtectedLayout>
              <Dashboard />
            </ProtectedLayout>
          }
        />
        <Route
          path="/users"
          element={
            <ProtectedLayout>
              <UserList />
            </ProtectedLayout>
          }
        />
        <Route
          path="/users/unapproved"
          element={
            <ProtectedLayout>
              <UnapprovedLicenses />
            </ProtectedLayout>
          }
        />
        <Route
          path="/users/:id"
          element={
            <ProtectedLayout>
              <UserProfile />
            </ProtectedLayout>
          }
        />
        <Route
          path="/vehicles"
          element={
            <ProtectedLayout>
              <VehicleList />
            </ProtectedLayout>
          }
        />
        <Route
          path="/vehicles/pending"
          element={
            <ProtectedLayout>
              <PendingVehicles />
            </ProtectedLayout>
          }
        />
        <Route
          path="/brands"
          element={
            <ProtectedLayout>
              <BrandList />
            </ProtectedLayout>
          }
        />
        <Route
          path="/brands/create"
          element={
            <ProtectedLayout>
              <CreateBrand />
            </ProtectedLayout>
          }
        />
        <Route
          path="/brands/update/:id"
          element={
            <ProtectedLayout>
              <UpdateBrand />
            </ProtectedLayout>
          }
        />
        <Route
          path="/reviews/:id"
          element={
            <ProtectedLayout>
              <ReviewDetail />
            </ProtectedLayout>
          }
        />
      </Routes>
    </Router>
  );
}

export default AppRouter;
