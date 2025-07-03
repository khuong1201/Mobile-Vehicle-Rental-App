import '../../styles/layout.css';
import { useEffect, useState } from 'react';
import api from '../../api/adminApi';

function UserList() {
  const [users, setUsers] = useState([]);

  const fetchUsers = () => {
    api.get('/admin/get-all-user').then(res => setUsers(res.data));
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleDelete = async (userId) => {
    if (window.confirm('Bạn có chắc muốn xóa người dùng này không?')) {
      await api.delete('/admin/delete-account', { data: { id: userId } });
      fetchUsers();
    }
  };

  return (
    <div className="layout-content">
      <h2>All Users</h2>
      <ul>
        {users.map(user => (
          <li key={user._id}>
            {user.username} - {user.email}
            <button onClick={() => handleDelete(user._id)}>Xóa</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default UserList;