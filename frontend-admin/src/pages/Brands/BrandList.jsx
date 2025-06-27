import React, { useEffect, useState } from 'react';
import { getAllBrands } from '../../services/adminService';

export default function BrandList() {
  const [brands, setBrands] = useState([]);

  useEffect(() => {
    getAllBrands()
      .then((res) => setBrands(res.data))
      .catch((err) => console.error('Failed to fetch brands:', err));
  }, []);

  return (
    <div className="p-6">
      <h3 className="text-2xl font-bold mb-4 text-gray-800">Brand List</h3>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {brands.map((b) => (
            <li key={b._id} className="py-2">
              {b.name}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}