import { Link } from 'react-router-dom';

function Sidebar() {
  const handleLogout = () => {
    localStorage.clear();
    window.location.href = '/login';
  };

  return (
    <div className="sidebar">
      <h3>Admin</h3>
      <ul>
        <li><Link to="/dashboard">Tổng quan</Link></li>
        <li><Link to="/users">Users</Link></li>
        <li><Link to="/users/unapproved">Unapproved Licenses</Link></li>
        <li><Link to="/vehicles">Vehicles</Link></li>
        <li><Link to="/vehicles/pending">Pending Vehicles</Link></li>
        <li><Link to="/brands">Brands</Link></li>
        <li><Link to="/brands/create">Create Brand</Link></li>
        <li><Link to="/admin-profile">Admin Profile</Link></li>
        <li><button onClick={handleLogout}>Logout</button></li>
      </ul>
    </div>
  );
}

export default Sidebar;