import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import api from '../../api/adminApi';
import '../../styles/layout.css';

function UserProfile() {
  const { id } = useParams();
  const [user, setUser] = useState(null);

  useEffect(() => {
    api.get(`/admin/get-user-profile/${id}`).then(res => setUser(res.data));
  }, [id]);

  if (!user) return <div className="layout-content">Loading...</div>;

  return (
    <div className="layout-content">
      <h2>User Profile</h2>
      <p>Username: {user.username}</p>
      <p>Email: {user.email}</p>
      <p>Status: {user.status}</p>
    </div>
  );
}

export default UserProfile;