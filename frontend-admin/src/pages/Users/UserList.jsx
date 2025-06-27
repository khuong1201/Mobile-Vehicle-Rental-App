import React, { useEffect, useState } from 'react';
import { getAllUsers, getUnapprovedLicenses, approveLicense, rejectLicense } from '../../services/adminService';

export default function UserList() {
  const [users, setUsers] = useState([]);
  const [unapproved, setUnapproved] = useState([]);

  useEffect(() => {
    refresh();
  }, []);

  async function refresh() {
    try {
      const [all, unapp] = await Promise.all([
        getAllUsers(),
        getUnapprovedLicenses(),
      ]);
      setUsers(all.data);
      setUnapproved(unapp.data);
    } catch (err) {
      console.error('Failed to fetch users:', err);
    }
  }

  const handleApprove = async (userId) => {
    try {
      await approveLicense(userId);
      refresh();
    } catch (err) {
      console.error('Failed to approve license:', err);
    }
  };

  const handleReject = async (userId) => {
    try {
      await rejectLicense(userId);
      refresh();
    } catch (err) {
      console.error('Failed to reject license:', err);
    }
  };

  return (
    <div className="p-6">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">Users</h2>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {users.map((u) => (
            <li key={u.userId} className="py-2">
              {u.fullName} - {u.email} - {u.verified ? '✔️ Verified' : '❌ Not Verified'}
            </li>
          ))}
        </ul>
      </div>

      <h2 className="text-2xl font-bold mt-6 mb-4 text-gray-800">Unapproved Licenses</h2>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {unapproved.map((u) => (
            <li key={u.userId} className="py-2 flex justify-between items-center">
              <span>
                {u.fullName} - {u.license.map((l) => l.licenseNumber).join(', ')}
              </span>
              <div className="space-x-2">
                <button
                  onClick={() => handleApprove(u.userId)}
                  className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
                >
                  Approve
                </button>
                <button
                  onClick={() => handleReject(u.userId)}
                  className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
                >
                  Reject
                </button>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}