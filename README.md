# Universal Yoga App - Customer App

Ứng dụng khách hàng cho hệ thống đặt lịch yoga, được phát triển bằng Flutter với kiến trúc MVVM.

## Tính năng chính

### 🔐 Authentication
- Đăng ký tài khoản mới
- Đăng nhập với email và mật khẩu
- Quản lý phiên đăng nhập
- Đăng xuất

### 🧘‍♀️ Xem danh sách lớp yoga
- Hiển thị danh sách các lớp yoga có sẵn
- Tìm kiếm lớp theo tên, giảng viên
- Lọc theo ngày trong tuần
- Lọc theo thời gian trong ngày
- Xem chi tiết thông tin lớp

### 🛒 Shopping Cart
- Thêm lớp yoga vào giỏ hàng
- Xem danh sách các lớp đã chọn
- Cập nhật số lượng
- Xóa lớp khỏi giỏ hàng
- Tính tổng tiền

### 📅 Đặt lịch
- Submit booking với thông tin người dùng
- Lưu trữ booking vào cloud service
- Xác nhận đặt lịch thành công

### 👤 Profile
- Xem thông tin cá nhân
- Quản lý tài khoản
- Lịch sử đặt lịch

## Kiến trúc MVVM

```
lib/
├── models/           # Data models
│   ├── yoga_course.dart
│   ├── yoga_class_session.dart
│   ├── yoga_user.dart
│   └── cart_item.dart
├── viewmodels/       # Business logic
│   ├── auth_viewmodel.dart
│   ├── course_viewmodel.dart
│   └── cart_viewmodel.dart
├── views/           # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── course/
│   │   └── course_list_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── services/        # External services
│   ├── firebase_service.dart
│   ├── auth_service.dart
│   └── cart_service.dart
├── utils/          # Utilities
│   ├── constants.dart
│   └── theme.dart
└── widgets/        # Reusable widgets
```

## Cài đặt và chạy

### Yêu cầu hệ thống
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / VS Code
- Firebase project

### Bước 1: Clone repository
```bash
git clone <repository-url>
cd universal_yoga_app_cross
```

### Bước 2: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 3: Cấu hình Firebase
1. Tạo project Firebase mới
2. Thêm ứng dụng Android/iOS
3. Tải file `google-services.json` (Android) hoặc `GoogleService-Info.plist` (iOS)
4. Đặt file vào thư mục tương ứng:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### Bước 4: Cấu hình Firebase Database
1. Vào Firebase Console > Realtime Database
2. Tạo database với URL: `https://universayogaapp-default-rtdb.asia-southeast1.firebasedatabase.app/`
3. Cấu hình rules cho phép read/write

### Bước 5: Chạy ứng dụng
```bash
flutter run
```

## Kết nối với Admin App

Ứng dụng Customer App kết nối với cloud service của Admin App thông qua:

### Firebase Realtime Database
- **Courses**: Lưu trữ thông tin khóa học yoga
- **Class Instances**: Lưu trữ các buổi học cụ thể
- **Bookings**: Lưu trữ đặt lịch của khách hàng

### Cấu trúc dữ liệu
```json
{
  "courses": {
    "courseId": {
      "courseName": "Yoga Basic",
      "instructorName": "John Doe",
      "coursePrice": 15.0,
      "maxStudents": 20,
      "sessionDuration": 60,
      "weeklySchedule": "Monday, Wednesday, Friday",
      "classTime": "9:00 AM"
    }
  },
  "class_instances": {
    "sessionId": {
      "parentCourseId": "courseId",
      "classDate": "2024-01-15",
      "assignedInstructor": "John Doe",
      "classNotes": "Beginner friendly"
    }
  },
  "bookings": {
    "bookingId": {
      "userId": "user123",
      "userEmail": "user@example.com",
      "cartItems": [...],
      "totalAmount": 30.0,
      "bookingDate": "2024-01-10T10:00:00Z",
      "status": "pending"
    }
  }
}
```

## Tính năng tìm kiếm và lọc

### Tìm kiếm theo ngày trong tuần
- Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
- Sử dụng filter chips để lọc nhanh

### Tìm kiếm theo thời gian
- Morning, Afternoon, Evening, Night
- Tìm kiếm text tự do

### Tìm kiếm tổng hợp
- Kết hợp nhiều điều kiện lọc
- Tìm kiếm theo tên lớp, giảng viên, ghi chú

## State Management

Sử dụng Provider pattern để quản lý state:

### AuthViewModel
- Quản lý trạng thái đăng nhập
- Xử lý authentication
- Lưu trữ thông tin user

### CourseViewModel
- Quản lý danh sách khóa học
- Xử lý tìm kiếm và lọc
- Cache dữ liệu

### CartViewModel
- Quản lý giỏ hàng
- Tính toán tổng tiền
- Submit booking

## UI/UX Design

### Theme
- Material Design 3
- Color scheme: Blue primary (#4A90E2)
- Responsive design
- Dark mode support (future)

### Components
- Custom cards với elevation
- Filter chips cho tìm kiếm
- Loading indicators
- Error handling với retry
- Snackbar notifications

## Bảo mật

### Authentication
- Firebase Authentication
- Email/password validation
- Secure password requirements

### Data Protection
- User data encryption
- Secure API calls
- Input validation

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Lỗi Firebase
1. Kiểm tra cấu hình Firebase
2. Verify database rules
3. Check network connectivity

### Lỗi Authentication
1. Verify email format
2. Check password requirements
3. Ensure Firebase Auth is enabled

### Lỗi Build
1. Run `flutter clean`
2. Run `flutter pub get`
3. Check Flutter version compatibility

## Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

MIT License - see LICENSE file for details

## Support

- Email: support@universalyoga.com
- Documentation: [Wiki](link-to-wiki)
- Issues: [GitHub Issues](link-to-issues)
