# CafeSense - Smart Coffee Shop Recommendation App

**CafeSense** là một ứng dụng di động thông minh giúp người dùng tìm kiếm quán cà phê phù hợp nhất dựa trên sở thích cá nhân, sử dụng công nghệ định vị địa lý và thuật toán gợi ý thông minh.

🌐 [Xem Roadmap Chi Tiết](./roadmap.md) (Tiếng Việt)

---

## 📋 Yêu Cầu Hệ Thống

### Frontend (Flutter)
- Flutter SDK: >= 3.0.0
- Dart: >= 3.0.0
- Android SDK: API 21+ (hoặc iOS 11+)

### Backend (Node.js)
- Node.js: >= 14.0.0
- npm: >= 6.0.0

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy

### 1️⃣ Clone Repository

```bash
git clone https://github.com/yourusername/cafesense.git
cd cafesense
```

### 2️⃣ Cài Đặt Frontend (Flutter App)

```bash
cd cafesense

# Cài đặt dependencies
flutter pub get

# Chạy app (chọn một trong các tùy chọn)
flutter run                    # Chọn thiết bị
flutter run -d chrome          # Chạy trên web
flutter run -d emulator-5554   # Chạy trên Android emulator
```

#### Cấu Hình Firebase (Bắt Buộc)

1. Tạo Firebase project tại [Firebase Console](https://console.firebase.google.com/)
2. Download `google-services.json` từ Firebase Console
3. Copy vào: `cafesense/android/app/google-services.json`

### 3️⃣ Cài Đặt Backend (Node.js Server)

```bash
cd backend

# Cài đặt dependencies
npm install

# Tạo file .env (xem .env.example)
cp .env.example .env
# Sau đó chỉnh sửa các giá trị cần thiết

# Khởi chạy server
npm start
```

Server sẽ chạy trên `http://localhost:3000` (hoặc cổng được cấu hình trong .env)

---

## 📁 Cấu Trúc Dự Án

```
cafesense/
├── cafesense/              # Flutter App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/           # Utilities, theme, widgets chung
│   │   └── features/       # Các tính năng (auth, home, cafe, match, ...)
│   ├── assets/
│   ├── pubspec.yaml        # Dependencies Flutter
│   ├── android/            # Native Android code
│   └── ios/                # Native iOS code
│
├── backend/                # Node.js Backend
│   ├── server.js           # Entry point
│   ├── db.js               # Database initialization
│   ├── matching.js         # Matching algorithm
│   ├── package.json        # Dependencies Node.js
│   └── .env.example        # Environment variables template
│
├── .gitignore              # Git ignore rules
├── README.md               # This file
└── roadmap.md              # Chi tiết lộ trình phát triển (Tiếng Việt)
```

---

## 🔧 Cấu Hình Biến Môi Trường (Backend)

Tạo file `backend/.env`:

```env
PORT=3000
NODE_ENV=development
DATABASE_PATH=./cafesense.db
JWT_SECRET=your_secret_key_here
CORS_ORIGIN=http://localhost:3000
```

Xem [backend/.env.example](./backend/.env.example) để biết đầy đủ các tùy chọn.

---

## 📱 Các Tính Năng Chính

- ✅ **Authentication**: Đăng ký & đăng nhập với Firebase Auth
- ✅ **Onboarding Survey**: Khảo sát sở thích người dùng
- ✅ **Smart Matching**: Thuật toán gợi ý quán cà phê phù hợp
- ✅ **Map & Geolocation**: Hiển thị quán trên bản đồ
- ✅ **Cafe Details**: Thông tin chi tiết, menu, review quán
- ✅ **Saved Cafes**: Lưu quán yêu thích
- ✅ **User Profile**: Quản lý thông tin cá nhân
- ✅ **Localization**: Hỗ trợ Tiếng Việt & Tiếng Anh

---

## 🛠️ Development

### Chạy Tests

```bash
# Flutter tests
cd cafesense
flutter test

# Backend tests (nếu có)
cd ../backend
npm test
```

### Format Code

```bash
# Flutter
cd cafesense
dart format lib/

# Backend
cd ../backend
npx prettier --write .
```

### Analyze Code

```bash
# Flutter
cd cafesense
flutter analyze
```

---

## 📦 Dependencies Chính

### Flutter
- `flutter_riverpod`: Quản lý trạng thái
- `firebase_auth`: Authentication
- `cloud_firestore`: Cloud database
- `flutter_map`: Map integration
- `easy_localization`: Multi-language support
- `geolocator`: Geolocation services
- `dio`: HTTP client

### Backend
- `express`: Web framework
- `sqlite3`: Database
- `jsonwebtoken`: JWT authentication
- `bcryptjs`: Password hashing
- `cors`: CORS middleware

---

## 🔒 Bảo Mật

- Không commit `google-services.json` hoặc `.env` files
- Sử dụng JWT tokens cho API authentication
- Firebase security rules được cấu hình trong Firebase Console
- Sensitive data được lưu trong secure storage

---

## 🚨 Troubleshooting

### Flutter: "Android SDK not found"
```bash
flutter config --android-sdk=/path/to/android/sdk
```

### Flutter: "CocoaPods dependency error"
```bash
cd cafesense/ios
pod install
cd ../..
```

### Backend: "sqlite3 module not found"
```bash
cd backend
npm install --save sqlite3
```

### Backend: "Port 3000 already in use"
```bash
# Change PORT in .env file or kill process using port 3000
```

---

## 📞 Liên Hệ & Hỗ Trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra [Issues](https://github.com/yourusername/cafesense/issues)
2. Tạo issue mới với chi tiết lỗi
3. Pull request được chào đón!

---

## 📄 License

Dự án này được phát hành dưới [MIT License](./LICENSE)

---

**Happy Coding! ☕** 

Phát triển bởi CafeSense Team
