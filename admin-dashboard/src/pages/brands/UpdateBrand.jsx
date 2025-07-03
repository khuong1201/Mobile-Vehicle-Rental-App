import '../../styles/layout.css';
import { useState, useEffect } from 'react';
import api from '../../api/adminApi';
import { useParams, useNavigate } from 'react-router-dom';

function UpdateBrand() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [name, setName] = useState('');

  useEffect(() => {
    api.get('/admin/get-all-banner').then(res => {
      const brand = res.data.find(b => b._id === id);
      if (brand) setName(brand.name);
    });
  }, [id]);

  const handleSubmit = (e) => {
    e.preventDefault();
    api.put(`/admin/update-brand/${id}`, { name }).then(() => {
      navigate('/admin/brand');
    });
  };

  return (
    <div className="layout-content">
      <h2>Cập nhật Brand</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Tên brand"
          required
        />
        <button type="submit">Lưu</button>
      </form>
    </div>
  );
}

export default UpdateBrand;