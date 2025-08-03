import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/yoga_class_session.dart';
import '../models/yoga_course.dart';
import '../services/cart_service.dart';
import '../services/firebase_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();
  final FirebaseService _firebaseService = FirebaseService();

  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _error;
  double _total = 0.0;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get total => _total;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _cartItems.isEmpty;

  CartViewModel() {
    loadCart();
  }

  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();

    try {
      _cartItems = await _cartService.getCartItems();
      await _calculateTotal();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> addCourseToCart(YogaCourse course) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.addCourseToCart(course);
      await loadCart();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> addToCart(YogaClassSession session) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.addToCart(session);
      await loadCart();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> removeFromCart(String itemId) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.removeFromCart(itemId);
      await loadCart();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> updateItemQuantity(String itemId, int quantity) async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.updateItemQuantity(itemId, quantity);
      await loadCart();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> clearCart() async {
    _setLoading(true);
    _clearError();

    try {
      await _cartService.clearCart();
      _cartItems = [];
      _total = 0.0;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> submitBooking(String userId, String userEmail) async {
    _setLoading(true);
    _clearError();

    try {
      if (_cartItems.isEmpty) {
        _setError('Cart is empty');
        _setLoading(false);
        return false;
      }

      final cartItemsData = _cartItems.map((item) => item.toJson()).toList();

      await _firebaseService.createBooking(
        userId: userId,
        userEmail: userEmail,
        cartItems: cartItemsData,
        totalAmount: _total,
      );

      await clearCart();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> isCourseInCart(String courseId) async {
    try {
      return await _cartService.isCourseInCart(courseId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isItemInCart(String sessionId) async {
    try {
      return await _cartService.isItemInCart(sessionId);
    } catch (e) {
      return false;
    }
  }

  Future<void> _calculateTotal() async {
    try {
      _total = await _cartService.getCartTotal();
    } catch (e) {
      _total = 0.0;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
