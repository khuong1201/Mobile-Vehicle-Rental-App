import React, { useEffect, useState } from 'react';
import { getPendingVehicles } from '../../services/adminService';

export default function VehiclePending() {
  const [pending, setPending] = useState([]);

  useEffect(() => {
    getPendingVehicles()
     

 .then((res) => setPending(res.data))
      .catch((err) => console.error('Failed to fetch pending vehicles:', err));
  }, []);

  return (
    <div className="p-6">
      <h3 className="text-2xl font-bold mb-4 text-gray-800">Pending Vehicles</h3>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {pending.map((v) => (
            <li key={v._id} className="py-2">
              {v.name}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}