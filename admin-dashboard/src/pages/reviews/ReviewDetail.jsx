import '../../styles/layout.css';
import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../../api/adminApi';

function ReviewDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [review, setReview] = useState(null);

  useEffect(() => {
    api.get(`/admin/review/${id}`).then(res => setReview(res.data));
  }, [id]);

  const handleDelete = () => {
    if (window.confirm('Xóa review này?')) {
      api.delete(`/admin/delete-review/${id}`).then(() => {
        navigate('/');
      });
    }
  };

  if (!review) return <div className="layout-content">Loading...</div>;

  return (
    <div className="layout-content">
      <h2>Review Detail</h2>
      <p>User: {review.user}</p>
      <p>Vehicle: {review.vehicle}</p>
      <p>Content: {review.content}</p>
      <button onClick={handleDelete}>Xóa review</button>
    </div>
  );
}

export default ReviewDetail;
