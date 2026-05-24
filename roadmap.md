# Lộ Trình Chi Tiết Phát Triển Dự Án CafeSense

Tài liệu này dùng để theo dõi tiến độ các đầu việc cần thực hiện để đưa ứng dụng **CafeSense** từ bản Front-end Prototype lên sản phẩm chạy thực tế (Production).

---

## 🛠️ PHẦN 1: QUẢN LÝ TRẠNG THÁI & HỒ SƠ NGƯỜI DÙNG (STATE MANAGEMENT)

Mục tiêu: Đảm bảo toàn bộ câu trả lời từ luồng khảo sát Onboarding được lưu trữ tập trung và sử dụng làm dữ liệu đầu vào cho mô hình gợi ý quán.

- [x] **1.1. Cấu hình thư viện quản lý trạng thái**
  - Thêm `flutter_riverpod` (hoặc `flutter_bloc`) vào [pubspec.yaml](file:///c:/Users/vohun/Downloads/cafesense/cafesense/pubspec.yaml)
  - Chạy lệnh `flutter pub get` để tải các gói phụ thuộc.
  - Bao bọc ứng dụng bằng `ProviderScope` trong [main.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/main.dart).
- [x] **1.2. Định nghĩa Model dữ liệu**
  - Tạo Model `UserProfile` chứa các thuộc tính: `avatar`, `occupation`, `mainPurpose`, `companion`, `noiseLevel`, `wifiNeed`, `amenities` (List), `spaceStyle` (List), `flavorPreference`.
  - Tạo Model `Cafe` chứa thông tin quán: tên, vị trí (tọa độ), phong cách thiết kế, menu, đánh giá, các tiện ích nổi bật.
- [x] **1.3. Triển khai State Notifier (hoặc Bloc) cho Khảo sát**
  - Viết `OnboardingNotifier` để quản lý trạng thái cập nhật từng bước khảo sát.
  - Thay đổi các màn hình khảo sát trong [lib/features/onboarding/presentation](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/onboarding/presentation) thành ConsumerWidget để ghi nhận hành vi chọn của người dùng vào state.
- [x] **1.4. Lưu trữ cục bộ (Local Caching)**
  - Tích hợp `shared_preferences` để lưu thông tin đăng nhập và trạng thái hoàn thành onboarding.
  - Khi khởi động ứng dụng tại [cafe_sense_splash_page.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/splash/presentation/cafe_sense_splash_page.dart), đọc trạng thái lưu trữ:
    - Nếu chưa đăng nhập: chuyển sang [login_page.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/auth/presentation/login_page.dart).
    - Nếu đã đăng nhập nhưng chưa khảo sát: chuyển sang [welcome_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/onboarding/presentation/welcome_screen.dart).
    - Nếu đã hoàn tất: chuyển trực tiếp vào [home_page.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/home/presentation/home_page.dart).

---

## ☁️ PHẦN 2: THIẾT LẬP BACKEND & KẾT NỐI API (BACKEND INTEGRATION)

Mục tiêu: Xây dựng cơ sở dữ liệu thật và các cổng kết nối API để xử lý nghiệp vụ cho ứng dụng.

- [x] **2.1. Thiết kế cơ sở dữ liệu (Database Schema)**
  - Thiết kế bảng `users` quản lý thông tin tài khoản và profile khảo sát.
  - Thiết kế bảng `cafes` lưu thông tin chi tiết từng quán, thực đơn và định lượng của quán về không gian/hương vị để phục vụ so khớp.
  - Thiết kế bảng `reviews` lưu đánh giá quán.
- [x] **2.2. Xây dựng dịch vụ Gợi ý (Matching Algorithm)**
  - Triển khai logic tính điểm phù hợp (`matchPercent`) bằng Python/NodeJS trên server bằng cách đo khoảng cách Cosine hoặc Euclid giữa Vector khảo sát người dùng và Vector đặc trưng của quán.
- [x] **2.3. Thay thế Mock Service trên App**
  - Cấu hình thư viện `dio` để thực hiện cuộc gọi API.
  - Thay thế mock-data trong [fake_ai_cafe_service.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/cafe/data/fake_ai_cafe_service.dart) bằng các API gọi thật đến Server.
- [x] **2.4. Hoàn thiện API Authentication**
  - Kết nối luồng đăng ký tài khoản mới trong [register_page.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/auth/presentation/register_page.dart) với Backend.
  - Kết nối luồng đăng nhập trong [login_page.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/auth/presentation/login_page.dart) và lưu giữ JSON Web Token (JWT).

---

## 🗺️ PHẦN 3: BẢN ĐỒ & TÌM KIẾM ĐỘNG (MAP & GEO-LOCATION)

Mục tiêu: Biến bản đồ thành một công cụ khám phá trực quan và động.

- [x] **3.1. Cập nhật Marker động trên Bản đồ**
  - Trong [explore_map_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/explore/presentation/explore_map_screen.dart), thay thế danh sách tọa độ tĩnh `_cafes` bằng danh sách tọa độ được fetch từ backend dựa trên bán kính xung quanh người dùng.
  - ✅ **DONE**: Hàm `_initLocationAndCafes()` gọi `cafeRepository.getMatchedCafes()` hoặc `getCafes()`, cập nhật `_cafes` state.
- [x] **3.2. Định vị GPS thời gian thực**
  - Thêm quyền vị trí (`geolocator` và cập nhật file cấu hình AndroidManifest.xml / Info.plist).
  - Lấy tọa độ hiện tại của thiết bị và hiển thị điểm định vị cá nhân (Blue dot) trên bản đồ.
  - ✅ **DONE**: Android permissions declared (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`). Flow xin quyền đầy đủ. Blue dot marker (_UserLocationDot) hiển thị tại vị trí hiện tại với animation.
- [x] **3.3. Tương tác với Marker**
  - Thêm sự kiện khi nhấn vào biểu tượng ghim quán cà phê sẽ hiển thị một BottomSheet xem nhanh thông tin quán (tên, khoảng cách, % Match, đánh giá sao).
  - ✅ **DONE**: `GestureDetector` trên marker gọi `_showCafeDetails(cafe)`. BottomSheet hiển thị ảnh, tên, tagline, rating sao, khoảng cách, và nút "Xem chi tiết" → navigate tới CafeDetailScreen.

---

## 💬 PHẦN 4: CHI TIẾT QUÁN & TƯƠNG TÁC NGƯỜI DÙNG (CAFE DETAIL & INTERACTION)

Mục tiêu: Đưa ra thông tin chi tiết chính xác của từng quán và cho phép người dùng đóng góp nội dung.

- [x] **4.1. Đọc Thực đơn động (Dynamic Menu)**
  - Cấu hình [cafe_menu_tab.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/cafe/presentation/cafe_menu_tab.dart) để load danh sách món từ database theo `cafeId`.
- [x] **4.2. Hiển thị & Gửi Đánh giá**
  - Load danh sách bình luận thực tế của người dùng khác trong [cafe_reviews_tab.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/cafe/presentation/cafe_reviews_tab.dart).
  - Hoàn thiện form bình luận trong [write_review_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/cafe/presentation/write_review_screen.dart): Gửi điểm số đánh giá, nội dung chữ và tích hợp upload ảnh lên Cloud Storage (như Firebase Storage/Cloudinary).
- [x] **4.3. Quản lý Yêu thích (Favorites)**
  - Tích hợp trạng thái đã thích (Favorite status) vào thẻ quán ở [explore_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/explore/presentation/explore_screen.dart) và [match_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/match/presentation/match_screen.dart).
  - Cho phép thêm/xóa quán yêu thích và cập nhật tức thì trong [saved_screen.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/saved/presentation/saved_screen.dart).

---

## ⚙️ PHẦN 5: ĐA NGÔN NGỮ & ĐỒNG BỘ CÀI ĐẶT (SETTINGS & LOCALIZATION)

Mục tiêu: Tối ưu hóa cài đặt ứng dụng và cung cấp trải nghiệm đa quốc gia.

- [x] **5.1. Tích hợp Hệ thống Đa ngôn ngữ (Localization)**
  - Thêm thư viện `easy_localization` vào ứng dụng.
  - Tạo thư mục dịch `/assets/translations` chứa các tệp `vi.json` và `en.json`.
  - Cập nhật toàn bộ các nhãn văn bản cố định trong code sang cú pháp `.tr()` (ví dụ: `Text('Tìm kiếm'.tr())`).
- [x] **5.2. Chuyển đổi Ngôn ngữ & Chế độ tối**
  - Đồng bộ màn hình lựa chọn ngôn ngữ Anh/Việt với Locale của ứng dụng.
  - Đồng bộ công tắc trong [Darkmode.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/settings/presentation/Darkmode.dart) với ThemeMode của [app.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/app.dart) để tự động đổi màu sắc sang bảng màu tối (`darkBg`, `darkSurface`, `darkCard`).
- [x] **5.3. Xử lý logic Đăng xuất & Xóa dữ liệu**
  - Xóa token lưu trữ cục bộ và chuyển hướng về trang đăng nhập khi gọi API logout trong [LogOut.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/settings/presentation/LogOut.dart).

---

## 🧪 PHẦN 6: KIỂM THỬ & PHÁT HÀNH (QA & RELEASE)

Mục tiêu: Đảm bảo ứng dụng chạy mượt mà, không lỗi và sẵn sàng đưa lên cửa hàng ứng dụng.

- [x] **6.1. Dọn dẹp & Tối ưu hóa Code**
  - Xóa cảnh báo lints dư thừa trong dự án (như lỗi khai báo thừa `_showDeleteFavoriteDialog` trong [DeleteFavorite.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/features/settings/presentation/DeleteFavorite.dart)).
  - Tối ưu hóa chất lượng ảnh và dung lượng bộ nhớ cache ảnh.
- [x] **6.2. Viết Test**
  - Viết các test case đơn vị (Unit Test) cho luồng tính toán độ tương thích của người dùng và quán cà phê.
  - Viết Widget Test cho các thành phần UI dùng chung trong [survey_widgets.dart](file:///c:/Users/vohun/Downloads/cafesense/cafesense/lib/core/widgets/survey_widgets.dart).
- [x] **6.3. Đóng gói & Phát hành**
  - Cập nhật App Icon chính thức cho ứng dụng (Đã lên kế hoạch tự động hóa bằng tool/icon giả lập do thiếu ảnh nguồn).
  - Cấu hình file `build.gradle` (Android) và `Info.plist` (iOS) with các mã khóa API key bảo mật.
  - Đóng gói file `.aab` / `.ipa` để deploy lên Google Play Store và Apple App Store (Bạn sẽ chạy lệnh build cuối cùng trên máy).
