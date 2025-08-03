import 'cart_item.dart';

class Booking {
  final String bookingId;
  final String userId;
  final String userEmail;
  final List<CartItem> cartItems;
  final double totalAmount;
  final DateTime bookingDate;
  final String status;
  final String bookingType;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.userEmail,
    required this.cartItems,
    required this.totalAmount,
    required this.bookingDate,
    required this.status,
    required this.bookingType,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    try {
      final cartItemsData = json['cartItems'] as List<dynamic>? ?? [];
      final List<CartItem> cartItems = [];

      for (final item in cartItemsData) {
        try {
          if (item is Map) {
            // Convert Map<Object?, Object?> to Map<String, dynamic>
            final Map<String, dynamic> cartItemData = {};
            item.forEach((key, value) {
              if (key is String) {
                cartItemData[key] = value;
              } else if (key != null) {
                cartItemData[key.toString()] = value;
              }
            });

            final cartItem = CartItem.fromJson(cartItemData);
            cartItems.add(cartItem);
          }
        } catch (e) {
          continue;
        }
      }

      return Booking(
        bookingId: json['bookingId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        userEmail: json['userEmail']?.toString() ?? '',
        cartItems: cartItems,
        totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
        bookingDate: DateTime.parse(
          json['bookingDate']?.toString() ?? DateTime.now().toIso8601String(),
        ),
        status: json['status']?.toString() ?? 'pending',
        bookingType: json['bookingType']?.toString() ?? 'mixed',
      );
    } catch (e) {
      return Booking(
        bookingId: json['bookingId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        userEmail: json['userEmail']?.toString() ?? '',
        cartItems: [],
        totalAmount: 0.0,
        bookingDate: DateTime.now(),
        status: 'error',
        bookingType: 'unknown',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'userEmail': userEmail,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'bookingType': bookingType,
    };
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  String get formattedDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }

  String get formattedTime {
    return '${bookingDate.hour.toString().padLeft(2, '0')}:${bookingDate.minute.toString().padLeft(2, '0')}';
  }
}
