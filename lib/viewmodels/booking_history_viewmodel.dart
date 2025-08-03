import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../services/firebase_service.dart';

class BookingHistoryViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserBookings(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final bookingsData = await _firebaseService.getUserBookings(userId);
      _bookings = bookingsData.map((data) => Booking.fromJson(data)).toList();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
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

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firebaseService.deleteBooking(bookingId);

      // Remove the booking from the local list
      _bookings.removeWhere((booking) => booking.bookingId == bookingId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }
}
