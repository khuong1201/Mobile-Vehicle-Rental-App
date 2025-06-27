import React, { useEffect, useState } from 'react';
import { getAllReviews } from '../../services/adminService';

export default function ReviewList() {
  const [reviews, setReviews] = useState([]);

  useEffect(() => {
    getAllReviews()
      .then((res) => setReviews(res.data))
      .catch((err) => console.error('Failed to fetch reviews:', err));
  }, []);

  return (
    <div className="p-6">
      <h3 className="text-2xl font-bold mb-4 text-gray-800">Review List</h3>
      <div className="bg-white shadow-md rounded-lg p-4">
        <ul className="divide-y divide-gray-200">
          {reviews.map((r) => (
            <li key={r._id} className="py-2">
              {r.comment}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}