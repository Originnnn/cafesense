import React, { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Link, Navigate, useNavigate } from 'react-router-dom';
import { auth } from './firebase';
import { signInWithEmailAndPassword, signOut, onAuthStateChanged } from 'firebase/auth';
import CafesManager from './pages/CafesManager';
import UsersManager from './pages/UsersManager';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      await signInWithEmailAndPassword(auth, email, password);
      navigate('/');
    } catch (err) {
      setError('Đăng nhập thất bại. Kiểm tra lại email/mật khẩu.');
    }
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h1>CafeSense Admin</h1>
        <form onSubmit={handleLogin}>
          <div className="form-group">
            <label>Email Admin</label>
            <input type="email" value={email} onChange={e => setEmail(e.target.value)} required />
          </div>
          <div className="form-group">
            <label>Mật khẩu</label>
            <input type="password" value={password} onChange={e => setPassword(e.target.value)} required />
          </div>
          {error && <p style={{color: 'red', fontSize: '14px'}}>{error}</p>}
          <button type="submit" className="primary" style={{width: '100%', marginTop: '10px'}}>Đăng nhập</button>
        </form>
      </div>
    </div>
  );
}

function AdminLayout({ children }) {
  const navigate = useNavigate();
  
  return (
    <div className="admin-layout">
      <div className="sidebar">
        <h2>CafeSense</h2>
        <nav>
          <Link to="/">Quản lý Quán</Link>
          <Link to="/users">Quản lý Người dùng</Link>
        </nav>
      </div>
      <div className="main-content">
        <div className="header">
          <button onClick={() => {
            signOut(auth);
            navigate('/login');
          }}>Đăng xuất</button>
        </div>
        <div className="content-area">
          {children}
        </div>
      </div>
    </div>
  );
}

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setLoading(false);
    });
    return unsubscribe;
  }, []);

  if (loading) return <div>Loading...</div>;

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={user ? <Navigate to="/" /> : <Login />} />
        
        <Route path="/" element={user ? <AdminLayout><CafesManager /></AdminLayout> : <Navigate to="/login" />} />
        
        <Route path="/users" element={user ? <AdminLayout><UsersManager /></AdminLayout> : <Navigate to="/login" />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
