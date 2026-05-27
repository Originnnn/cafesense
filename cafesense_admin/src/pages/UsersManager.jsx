import React, { useEffect, useState } from 'react';
import { db } from '../firebase';
import { collection, getDocs } from 'firebase/firestore';

function UsersManager() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState('');

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, 'users'));
        const usersList = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        setUsers(usersList);
      } catch (error) {
        console.error("Error fetching users: ", error);
        setErrorMsg(error.message || 'Lỗi không xác định');
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) return <p>Đang tải dữ liệu...</p>;
  if (errorMsg) return <p style={{color: 'red'}}>Lỗi khi tải danh sách người dùng: {errorMsg}</p>;

  return (
    <div>
      <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px'}}>
        <h1 style={{margin: 0}}>Quản lý Người dùng</h1>
      </div>
      
      <table>
        <thead>
          <tr>
            <th>UID</th>
            <th>Tên hiển thị</th>
            <th>Email</th>
            <th>Sở thích</th>
          </tr>
        </thead>
        <tbody>
          {users.map(user => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.displayName || 'N/A'}</td>
              <td>{user.email || 'N/A'}</td>
              <td>{user.mainPurpose || 'Chưa có'} {user.occupation ? `- ${user.occupation}` : ''}</td>
            </tr>
          ))}
          {users.length === 0 && (
            <tr>
              <td colSpan="4" style={{textAlign: 'center'}}>Không có dữ liệu</td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}

export default UsersManager;
