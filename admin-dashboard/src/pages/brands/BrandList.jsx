import '../../styles/layout.css';
import { useEffect, useState } from 'react';
import api from '../../api/adminApi';

function BrandList() {
  const [brands, setBrands] = useState([]);

  const fetchBrands = () => {
    api.get('/admin/get-all-banner').then(res => setBrands(res.data));
  };

  useEffect(() => {
    fetchBrands();
  }, []);

  const handleDelete = (id) => {
    if (window.confirm('Xóa brand này?')) {
      api.delete(`/admin/delete-brand/${id}`).then(fetchBrands);
    }
  };

  return (
    <div className="layout-content">
      <h2>All Brands</h2>
      <ul>
        {brands.map(brand => (
          <li key={brand._id}>
            {brand.name}
            <button onClick={() => handleDelete(brand._id)}>Xóa</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BrandList;