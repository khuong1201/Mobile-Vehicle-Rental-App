import '../../styles/layout.css';
import { useEffect, useState } from 'react';
import api from '../../api/adminApi';

function UnapprovedLicenses() {
  const [users, setUsers] = useState([]);

  const fetchUsers = () => {
    api.get('/admin/get-users-with-unapproved-licenses').then(res => setUsers(res.data));
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const approve = (userId) => {
    api.post('/admin/approve-license', { userId }).then(fetchUsers);
  };

  const reject = (userId) => {
    api.post('/admin/reject-license', { userId }).then(fetchUsers);
  };

  return (
    <div className="layout-content">
      <h2>Unapproved Licenses</h2>
      <ul>
        {users.map(user => (
          <li key={user._id}>
            {user.username}
            <button onClick={() => approve(user._id)}>Duyệt</button>
            <button onClick={() => reject(user._id)}>Từ chối</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default UnapprovedLicenses;