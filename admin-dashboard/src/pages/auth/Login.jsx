import { useState } from 'react';
import api from '../../api/adminApi';
import '../../styles/layout.css';
import { useNavigate } from 'react-router-dom';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const res = await api.post('/auth/web-login', { email, password });
      console.log('Đăng nhập thành công:', res.data);
      console.log('Cookie sau đăng nhập:', document.cookie);
      navigate('/dashboard');
    } catch (err) {
      console.error('Đăng nhập thất bại:', err.response?.data || err.message);
      alert('Đăng nhập thất bại: ' + (err.response?.data?.message || 'Lỗi không xác định'));
    }
  };

  return (
    <form onSubmit={handleLogin}>
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Mật khẩu"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <button type="submit">Đăng nhập</button>
    </form>
  );
}

export default Login;