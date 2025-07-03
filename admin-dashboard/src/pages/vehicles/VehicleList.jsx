import { useEffect, useState } from 'react';
import api from '../../api/adminApi';
import '../../styles/layout.css';

function VehicleList() {
  const [vehicles, setVehicles] = useState([]);

  useEffect(() => {
    api.get('/admin/all-vehicles').then(res => setVehicles(res.data));
  }, []);

  return (
    <div className="layout-content">
      <h2>All Vehicles</h2>
      <ul>
        {vehicles.map(vehicle => (
          <li key={vehicle._id}>{vehicle.name} - {vehicle.status}</li>
        ))}
      </ul>
    </div>
  );
}

export default VehicleList;