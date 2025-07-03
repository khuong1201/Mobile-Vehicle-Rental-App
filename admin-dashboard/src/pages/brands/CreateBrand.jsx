import '../../styles/layout.css';
import { useState } from 'react';
import api from '../../api/adminApi';
import { useNavigate } from 'react-router-dom';

function CreateBrand() {
  const [name, setName] = useState('');
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    api.post('/admin/create-brand', { name }).then(() => {
      navigate('/admin/brand');
    });
  };

  return (
    <div className="layout-content">
      <h2>Tạo Brand</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Tên brand"
          required
        />
        <button type="submit">Tạo</button>
      </form>
    </div>
  );
}

export default CreateBrand;