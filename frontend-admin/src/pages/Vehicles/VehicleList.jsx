import React, { useEffect, useState } from 'react';
import { getAllVehicles } from '../../services/adminService';

export default function VehicleList() {
  const [vehicles, setVehicles] = useState([]);

  useEffect(() => {
    getAllVehicles()
      .then((res) => setVehicles(res.data))
      .catch((err) => console.error('Failed to fetch vehicles:', err));
  }, []);

  return (
    <div className="p-6">
      <h3 className="text-2xl font-bold mb-4 text-gray-800">All Vehicles</h3>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {vehicles.map((v) => (
            <li key={v._id} className="py-2">
              {v.name} - {v.status}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}