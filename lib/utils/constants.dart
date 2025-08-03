class AppConstants {
  // App info
  static const String appName = 'Universal Yoga App';
  static const String appVersion = '1.0.0';

  // Firebase
  static const String firebaseDatabaseUrl =
      'https://universayogaapp-default-rtdb.asia-southeast1.firebasedatabase.app/';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String courseListRoute = '/courses';
  static const String courseDetailRoute = '/course-detail';
  static const String cartRoute = '/cart';
  static const String profileRoute = '/profile';

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userEmailKey = 'user_email';
  static const String cartKey = 'yoga_cart';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Days of week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Time slots
  static const List<String> timeSlots = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  // Error messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String generalError = 'Something went wrong. Please try again.';
  static const String emptyCartError = 'Your cart is empty.';
  static const String bookingSuccess = 'Booking submitted successfully!';

  // Success messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String itemAddedToCart = 'Item added to cart!';
  static const String itemRemovedFromCart = 'Item removed from cart!';
}
