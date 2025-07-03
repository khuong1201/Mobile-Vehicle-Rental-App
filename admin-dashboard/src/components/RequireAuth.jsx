import { useEffect, useState } from 'react';
import { Navigate } from 'react-router-dom';
import api from '../api/adminApi';

function RequireAuth({ children }) {
  const [isAuthenticated, setIsAuthenticated] = useState(null);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = document.cookie
          .split('; ')
          .find(row => row.startsWith('accessToken='))
          ?.split('=')[1];

        if (!token) {
          setIsAuthenticated(false);
          return;
        }

        await api.get('/users/get-user-profile');
        setIsAuthenticated(true);
      } catch (err) {
        console.error('Lỗi kiểm tra xác thực:', err);
        setIsAuthenticated(false);
      }
    };

    checkAuth();
  }, []);

  if (isAuthenticated === null) {
    return <div>Loading...</div>;
  }

  return isAuthenticated ? children : <Navigate to="/login" replace />;
}

export default RequireAuth;