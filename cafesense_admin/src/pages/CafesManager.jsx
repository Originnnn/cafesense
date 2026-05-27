import React, { useEffect, useState } from 'react';
import { db } from '../firebase';
import { collection, getDocs, doc, setDoc, deleteDoc, updateDoc } from 'firebase/firestore';

function CafesManager() {
  const [cafes, setCafes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [editingCafe, setEditingCafe] = useState(null);
  const [showReviewModal, setShowReviewModal] = useState(false);
  const [selectedCafeForReviews, setSelectedCafeForReviews] = useState(null);

  // Form states
  const [formData, setFormData] = useState({
    id: '', name: '', fullName: '', description: '', imageUrl: '', priceLabel: '$$', tagline: ''
  });

  const fetchCafes = async () => {
    setLoading(true);
    try {
      const querySnapshot = await getDocs(collection(db, 'cafes'));
      const cafesList = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setCafes(cafesList);
    } catch (error) {
      console.error("Error fetching cafes: ", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCafes();
  }, []);

  const handleOpenModal = (cafe = null) => {
    if (cafe) {
      setEditingCafe(cafe.id);
      setFormData({
        id: cafe.id,
        name: cafe.name || '',
        fullName: cafe.fullName || '',
        description: cafe.description || '',
        imageUrl: cafe.imageUrl || '',
        priceLabel: cafe.priceLabel || '$$',
        tagline: cafe.tagline || ''
      });
    } else {
      setEditingCafe(null);
      setFormData({
        id: `cafe_${Date.now()}`,
        name: '', fullName: '', description: '', imageUrl: '', priceLabel: '$$', tagline: ''
      });
    }
    setShowModal(true);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      if (editingCafe) {
        await updateDoc(doc(db, 'cafes', editingCafe), formData);
      } else {
        await setDoc(doc(db, 'cafes', formData.id), formData);
      }
      setShowModal(false);
      fetchCafes();
    } catch (err) {
      console.error("Error saving cafe: ", err);
      alert("Lỗi khi lưu!");
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Bạn có chắc chắn muốn xóa quán cafe này?")) {
      try {
        await deleteDoc(doc(db, 'cafes', id));
        fetchCafes();
      } catch (err) {
        console.error("Error deleting: ", err);
      }
    }
  };

  const handleDeleteReview = async (cafe, reviewId) => {
    if (window.confirm("Bạn có chắc chắn muốn xóa đánh giá này?")) {
      try {
        const updatedReviews = (cafe.reviews || []).filter(r => r.id !== reviewId);
        await updateDoc(doc(db, 'cafes', cafe.id), { reviews: updatedReviews });
        
        // Update local state to reflect UI changes immediately
        setSelectedCafeForReviews({ ...cafe, reviews: updatedReviews });
        setCafes(cafes.map(c => c.id === cafe.id ? { ...c, reviews: updatedReviews } : c));
      } catch (err) {
        console.error("Error deleting review: ", err);
        alert("Lỗi khi xóa đánh giá!");
      }
    }
  };

  return (
    <div>
      <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px'}}>
        <h1 style={{margin: 0}}>Quản lý Quán Cafe</h1>
        <button className="primary" onClick={() => handleOpenModal()}>+ Thêm Quán Mới</button>
      </div>
      
      {loading ? <p>Đang tải dữ liệu...</p> : (
        <table>
          <thead>
            <tr>
              <th>Hình ảnh</th>
              <th>Tên quán</th>
              <th>Mức giá</th>
              <th>Slogan</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            {cafes.map(cafe => (
              <tr key={cafe.id}>
                <td>
                  {cafe.imageUrl ? 
                    <img src={cafe.imageUrl.startsWith('http') ? cafe.imageUrl : `https://via.placeholder.com/60?text=${cafe.name}`} alt={cafe.name} style={{width: '60px', height: '40px', objectFit: 'cover', borderRadius: '4px'}} />
                    : 'N/A'
                  }
                </td>
                <td style={{fontWeight: '500'}}>{cafe.name}</td>
                <td>{cafe.priceLabel}</td>
                <td>{cafe.tagline}</td>
                <td style={{display: 'flex', gap: '8px'}}>
                  <button className="primary" onClick={() => { setSelectedCafeForReviews(cafe); setShowReviewModal(true); }}>Đánh giá</button>
                  <button className="primary" onClick={() => handleOpenModal(cafe)}>Sửa</button>
                  <button className="danger" onClick={() => handleDelete(cafe.id)}>Xóa</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {showModal && (
        <div className="modal-overlay" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <h2 style={{marginTop: 0}}>{editingCafe ? 'Sửa thông tin quán' : 'Thêm quán mới'}</h2>
            <form onSubmit={handleSave}>
              <div className="form-group">
                <label>ID</label>
                <input type="text" value={formData.id} disabled={!!editingCafe} onChange={e => setFormData({...formData, id: e.target.value})} required />
              </div>
              <div className="form-group">
                <label>Tên quán (Ngắn gọn)</label>
                <input type="text" value={formData.name} onChange={e => setFormData({...formData, name: e.target.value})} required />
              </div>
              <div className="form-group">
                <label>Tên đầy đủ (Kèm địa chỉ)</label>
                <input type="text" value={formData.fullName} onChange={e => setFormData({...formData, fullName: e.target.value})} required />
              </div>
              <div className="form-group">
                <label>URL Hình ảnh</label>
                <input type="text" value={formData.imageUrl} onChange={e => setFormData({...formData, imageUrl: e.target.value})} />
              </div>
              <div className="form-group">
                <label>Mô tả chi tiết</label>
                <textarea rows="3" value={formData.description} onChange={e => setFormData({...formData, description: e.target.value})}></textarea>
              </div>
              <div style={{display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '20px'}}>
                <button type="button" onClick={() => setShowModal(false)} style={{padding: '8px 16px', background: '#ccc', border: 'none', borderRadius: '4px', cursor: 'pointer'}}>Hủy</button>
                <button type="submit" className="primary">Lưu thay đổi</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {showReviewModal && selectedCafeForReviews && (
        <div className="modal-overlay" onClick={() => setShowReviewModal(false)}>
          <div className="modal" style={{maxWidth: '800px'}} onClick={e => e.stopPropagation()}>
            <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px'}}>
              <h2 style={{marginTop: 0}}>Quản lý Đánh giá - {selectedCafeForReviews.name}</h2>
              <button onClick={() => setShowReviewModal(false)} style={{background: 'transparent', border: 'none', fontSize: '18px', cursor: 'pointer'}}>✖</button>
            </div>
            
            <table style={{boxShadow: 'none', border: '1px solid #eee'}}>
              <thead>
                <tr>
                  <th>Người dùng</th>
                  <th>Đánh giá (Sao)</th>
                  <th>Nội dung</th>
                  <th>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {(!selectedCafeForReviews.reviews || selectedCafeForReviews.reviews.length === 0) ? (
                  <tr><td colSpan="4" style={{textAlign: 'center'}}>Chưa có đánh giá nào</td></tr>
                ) : (
                  selectedCafeForReviews.reviews.map(review => (
                    <tr key={review.id}>
                      <td><strong>{review.userName}</strong> {review.userAvatar}</td>
                      <td>{review.rating} ⭐</td>
                      <td>{review.comment}</td>
                      <td>
                        <button className="danger" onClick={() => handleDeleteReview(selectedCafeForReviews, review.id)}>Xóa</button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}

export default CafesManager;
