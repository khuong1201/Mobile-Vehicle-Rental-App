import React from 'react';
import { NavLink } from 'react-router-dom';

export default function Sidebar() {
  console.log('Sidebar: Rendering');
  return (
    <div className="w-64 bg-gray-800 text-white min-h-screen p-4">
      <h2 className="text-2xl font-bold mb-6">Admin Panel</h2>
      <nav className="space-y-2">
        <NavLink
          to="/admin/dashboard"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Dashboard
        </NavLink>
        <NavLink
          to="/admin/users"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Users
        </NavLink>
        <NavLink
          to="/admin/vehicles"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Vehicles
        </NavLink>
        <NavLink
          to="/admin/vehicles/pending"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Pending Vehicles
        </NavLink>
        <NavLink
          to="/admin/brands"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Brands
        </NavLink>
        <NavLink
          to="/admin/reviews"
          className={({ isActive }) =>
            isActive
              ? 'block py-2 px-4 bg-gray-700 rounded'
              : 'block py-2 px-4 hover:bg-gray-700 rounded'
          }
        >
          Reviews
        </NavLink>
      </nav>
    </div>
  );
}