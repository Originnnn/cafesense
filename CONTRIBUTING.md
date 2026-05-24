# Contributing to CafeSense

Cảm ơn bạn đã quan tâm đến việc đóng góp cho CafeSense! Hướng dẫn này sẽ giúp bạn bắt đầu.

## 🤝 Cách Đóng Góp

### 1. Fork & Clone Repository

```bash
# Fork trên GitHub, sau đó clone
git clone https://github.com/yourusername/cafesense.git
cd cafesense
```

### 2. Tạo Branch Mới

```bash
git checkout -b feature/your-feature-name
# hoặc
git checkout -b fix/your-bug-fix
```

### 3. Thực Hiện Thay Đổi

- Tuân theo code style hiện tại
- Viết clear commit messages
- Test code của bạn trước khi commit

### 4. Commit & Push

```bash
git add .
git commit -m "feat: Describe your changes clearly"
git push origin feature/your-feature-name
```

### 5. Tạo Pull Request

- Mô tả rõ ràng những gì bạn đã thay đổi
- Reference các issues liên quan (nếu có)
- Chờ code review

---

## 📝 Commit Message Convention

Sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting, etc)
- `refactor`: Code refactoring
- `test`: Test additions/updates
- `chore`: Build, dependencies, etc

### Examples:
```
feat(auth): Add Firebase authentication
fix(match): Fix cafe matching algorithm
docs(readme): Update installation instructions
```

---

## 🎯 Code Style Guide

### Flutter/Dart
- Tuân theo [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Chạy `dart format` trước khi commit
- Sử dụng `flutter analyze` để kiểm tra lỗi
- Maximum line length: 80 characters

### Backend/JavaScript
- Tuân theo [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Chạy `npx prettier --write .` để format code
- Sử dụng 2 spaces cho indentation
- Thêm JSDoc comments cho public functions

---

## ✅ Trước Khi Submit PR

- [ ] Code đã được format
- [ ] Không có linting errors
- [ ] Tests vẫn pass
- [ ] Commit messages rõ ràng
- [ ] README/docs đã cập nhật (nếu cần)
- [ ] Không có console.log hay debug code

---

## 🐛 Báo Cáo Issues

Khi báo cáo bug, hãy cung cấp:

1. **Mô tả rõ ràng** của vấn đề
2. **Steps to reproduce** để lặp lại lỗi
3. **Expected behavior** vs **Actual behavior**
4. **Screenshots/Videos** (nếu có)
5. **Environment info**:
   - Flutter version
   - Dart version
   - Device/Emulator info
   - Node version (backend)

---

## 📚 Architecture Guidelines

### Frontend (Flutter)
```
lib/
├── core/              # Shared code
│   ├── network/      # API client
│   ├── providers/    # Riverpod providers
│   ├── routes/       # Navigation
│   └── theme/        # App theme
└── features/         # Feature modules
    └── [feature]/
        ├── data/     # API/Database
        ├── domain/   # Business logic
        └── presentation/  # UI
```

### Backend (Node.js)
```
backend/
├── routes/           # API routes
├── controllers/      # Request handlers
├── models/           # Database models
├── services/         # Business logic
├── middleware/       # Middleware
└── utils/            # Utilities
```

---

## 🧪 Testing

### Flutter
```bash
cd cafesense
flutter test              # Run all tests
flutter test test/file_test.dart  # Run specific test
```

### Backend
```bash
cd backend
npm test               # Run all tests
npm test -- test/api.test.js  # Run specific test
```

---

## 📖 Documentation

- Update [README.md](./README.md) nếu thay đổi setup/installation
- Update [roadmap.md](./roadmap.md) nếu thay đổi scope
- Thêm comments cho code phức tạp
- Update CHANGELOG.md cho major changes

---

## 🆘 Cần Giúp Đỡ?

- **Documentation**: [Flutter Docs](https://flutter.dev/docs), [Node.js Docs](https://nodejs.org/en/docs/)
- **Issues**: Check [existing issues](https://github.com/yourusername/cafesense/issues)
- **Discussions**: Sử dụng GitHub Discussions nếu có câu hỏi

---

## 📜 Code of Conduct

- Tôn trọng tất cả contributors
- Không spam hoặc tấn công cá nhân
- Feedback nên xây dựng và hữu ích
- Violations có thể dẫn đến ban

---

**Cảm ơn đã đóng góp! ☕**
