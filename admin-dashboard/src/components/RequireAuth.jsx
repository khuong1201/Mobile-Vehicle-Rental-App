import { useEffect, useState } from 'react';
import { Navigate } from 'react-router-dom';
import api from '../api/adminApi';

function RequireAuth({ children }) {
  const [isAuthenticated, setIsAuthenticated] = useState(null);

  useEffect(() => {
    api.get('/users/get-user-profile')
      .then(() => setIsAuthenticated(true))
      .catch(() => setIsAuthenticated(false));
  }, []);

  if (isAuthenticated === null) return null; // hoặc loading...

  return isAuthenticated ? children : <Navigate to="/login" replace />;
}

export default RequireAuth;
