import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/yoga_class_session.dart';
import '../models/yoga_course.dart';
import '../services/firebase_service.dart';

class CartService {
  static const String _cartKey = 'yoga_cart';
  final FirebaseService _firebaseService = FirebaseService();

  // Get cart items from local storage
  Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> cartList = json.decode(cartJson);
        return cartList.map((item) => CartItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Add course to cart
  Future<void> addCourseToCart(YogaCourse course) async {
    try {
      final cartItems = await getCartItems();

      // Check if course already exists in cart
      final existingIndex = cartItems.indexWhere(
        (item) => item.isCourse && item.course?.courseId == course.courseId,
      );

      if (existingIndex != -1) {
        // Update quantity if course exists
        final existingItem = cartItems[existingIndex];
        cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        // Add new course
        final newItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          course: course,
          quantity: 1,
          addedAt: DateTime.now(),
          isCourse: true,
        );
        cartItems.add(newItem);
      }

      await _saveCartItems(cartItems);
    } catch (e) {
      throw Exception('Failed to add course to cart: $e');
    }
  }

  // Add session to cart (for backward compatibility)
  Future<void> addToCart(YogaClassSession session) async {
    try {
      final cartItems = await getCartItems();

      // Check if session already exists in cart
      final existingIndex = cartItems.indexWhere(
        (item) =>
            !item.isCourse && item.session?.sessionId == session.sessionId,
      );

      if (existingIndex != -1) {
        // Update quantity if session exists
        final existingItem = cartItems[existingIndex];
        cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        // Add new session
        final newItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          session: session,
          quantity: 1,
          addedAt: DateTime.now(),
          isCourse: false,
        );
        cartItems.add(newItem);
      }

      await _saveCartItems(cartItems);
    } catch (e) {
      throw Exception('Failed to add session to cart: $e');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      final cartItems = await getCartItems();
      cartItems.removeWhere((item) => item.id == itemId);
      await _saveCartItems(cartItems);
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    try {
      final cartItems = await getCartItems();
      final index = cartItems.indexWhere((item) => item.id == itemId);

      if (index != -1) {
        if (quantity <= 0) {
          cartItems.removeAt(index);
        } else {
          cartItems[index] = cartItems[index].copyWith(quantity: quantity);
        }
        await _saveCartItems(cartItems);
      }
    } catch (e) {
      throw Exception('Failed to update item quantity: $e');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Get cart total
  Future<double> getCartTotal() async {
    try {
      final cartItems = await getCartItems();
      double total = 0.0;

      for (final item in cartItems) {
        if (item.isCourse && item.course != null) {
          // For courses, multiply by quantity
          total += (item.quantity * item.course!.coursePrice);
        } else if (!item.isCourse && item.session != null) {
          // For sessions, get course price from Firebase
          final course = await _firebaseService.getCourseById(
            item.session!.parentCourseId,
          );
          if (course != null) {
            total += (item.quantity * course.coursePrice);
          } else {
            // Fallback to default price if course not found
            total += (item.quantity * 10.0);
          }
        }
      }

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    try {
      final cartItems = await getCartItems();
      int total = 0;
      for (final item in cartItems) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Save cart items to local storage
  Future<void> _saveCartItems(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(
        cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      throw Exception('Failed to save cart items: $e');
    }
  }

  // Check if course is in cart
  Future<bool> isCourseInCart(String courseId) async {
    try {
      final cartItems = await getCartItems();
      return cartItems.any(
        (item) => item.isCourse && item.course?.courseId == courseId,
      );
    } catch (e) {
      return false;
    }
  }

  // Check if session is in cart (for backward compatibility)
  Future<bool> isItemInCart(String sessionId) async {
    try {
      final cartItems = await getCartItems();
      return cartItems.any(
        (item) => !item.isCourse && item.session?.sessionId == sessionId,
      );
    } catch (e) {
      return false;
    }
  }
}
