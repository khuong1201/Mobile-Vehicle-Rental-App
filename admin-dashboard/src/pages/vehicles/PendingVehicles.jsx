import { useEffect, useState } from 'react';
import api from '../../api/adminApi';
import '../../styles/layout.css';

function PendingVehicles() {
  const [pending, setPending] = useState([]);

  useEffect(() => {
    api.get('/admin/pending').then(res => setPending(res.data));
  }, []);

  return (
    <div className="layout-content">
      <h2>Pending Vehicles</h2>
      <ul>
        {pending.map(vehicle => (
          <li key={vehicle._id}>{vehicle.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default PendingVehicles;