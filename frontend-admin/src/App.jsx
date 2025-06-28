import React, { useEffect, useState } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import AdminLayout from './layouts/AdminLayout';
import Login from './pages/Login';
import api from './services/api';
import './App.css';

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    console.log('App: Checking authentication...');
    const checkAuth = async () => {
      try {
        const token = localStorage.getItem('accessToken');
        if (token) {
          console.log('App: Token found, verifying...');
          await api.get('/admin/get-admin-profile');
          setIsAuthenticated(true);
        } else {
          console.log('App: No token found');
          setIsAuthenticated(false);
        }
      } catch (err) {
        console.error('App: Authentication check failed:', err.message);
        setIsAuthenticated(false);
      } finally {
        console.log('App: Authentication check complete');
        setIsLoading(false);
      }
    };
    checkAuth();
  }, []);

  if (isLoading) {
    console.log('App: Rendering loading screen');
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <p className="text-gray-600">Đang tải...</p>
      </div>
    );
  }

  console.log('App: Rendering routes, isAuthenticated:', isAuthenticated);
  return (
    <Routes>
      <Route
        path="/login"
        element={isAuthenticated ? <Navigate to="/admin/dashboard" replace /> : <Login setIsAuthenticated={setIsAuthenticated} />}
      />
      <Route
        path="/admin/*"
        element={isAuthenticated ? <AdminLayout /> : <Navigate to="/login" replace />}
      />
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

export default App;