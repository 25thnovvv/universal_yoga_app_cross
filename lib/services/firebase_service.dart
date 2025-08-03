import 'package:firebase_database/firebase_database.dart';
import '../models/yoga_course.dart';
import '../models/yoga_class_session.dart';

class FirebaseService {
  late final FirebaseDatabase _database;
  late final DatabaseReference _coursesRef;
  late final DatabaseReference _classSessionsRef;
  late final DatabaseReference _bookingsRef;

  FirebaseService() {
    _database = FirebaseDatabase.instance;
    _coursesRef = _database.ref('courses');
    _classSessionsRef = _database.ref('class_instances');
    _bookingsRef = _database.ref('bookings');
  }

  // Course methods
  Future<List<YogaCourse>> getAllCourses() async {
    try {
      final snapshot = await _coursesRef.get();
      if (snapshot.exists) {
        final List<YogaCourse> courses = [];
        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>;
          final course = YogaCourse.fromJson(Map<String, dynamic>.from(data));
          courses.add(course);
        }
        return courses;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  Future<YogaCourse?> getCourseById(String courseId) async {
    try {
      final snapshot = await _coursesRef.child(courseId).get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return YogaCourse.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // Class session methods
  Future<List<YogaClassSession>> getClassSessionsByCourseId(
    String courseId,
  ) async {
    try {
      final snapshot = await _classSessionsRef
          .orderByChild('parentCourseId')
          .equalTo(courseId)
          .get();

      if (snapshot.exists) {
        final List<YogaClassSession> sessions = [];
        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>;
          final session = YogaClassSession.fromJson(
            Map<String, dynamic>.from(data),
          );
          sessions.add(session);
        }
        return sessions;
      }
      return [];
    } catch (e) {
      // Handle index error specifically
      if (e.toString().contains('index-not-defined')) {
        // Fallback: get all sessions and filter locally
        try {
          final allSessions = await getAllClassSessions();
          return allSessions
              .where((session) => session.parentCourseId == courseId)
              .toList();
        } catch (fallbackError) {
          throw Exception('Failed to fetch class sessions: $fallbackError');
        }
      }
      throw Exception('Failed to fetch class sessions: $e');
    }
  }

  Future<List<YogaClassSession>> getAllClassSessions() async {
    try {
      final snapshot = await _classSessionsRef.get();
      if (snapshot.exists) {
        final List<YogaClassSession> sessions = [];
        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>;
          final session = YogaClassSession.fromJson(
            Map<String, dynamic>.from(data),
          );
          sessions.add(session);
        }
        return sessions;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch all class sessions: $e');
    }
  }

  // Booking methods
  Future<void> createBooking({
    required String userId,
    required String userEmail,
    required List<Map<String, dynamic>> cartItems,
    required double totalAmount,
  }) async {
    try {
      final bookingData = {
        'userId': userId,
        'userEmail': userEmail,
        'cartItems': cartItems,
        'totalAmount': totalAmount,
        'bookingDate': DateTime.now().toIso8601String(),
        'status': 'pending',
        'bookingType': 'mixed', // Can be 'course', 'session', or 'mixed'
      };

      await _bookingsRef.push().set(bookingData);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Search methods
  Future<List<YogaClassSession>> searchSessionsByDayOfWeek(
    String dayOfWeek,
  ) async {
    try {
      final allSessions = await getAllClassSessions();
      return allSessions.where((session) {
        // Parse the class date and check if it matches the day of week
        try {
          final date = DateTime.parse(session.classDate);
          final sessionDay = _getDayOfWeek(date.weekday);
          return sessionDay.toLowerCase().contains(dayOfWeek.toLowerCase());
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to search sessions by day: $e');
    }
  }

  Future<List<YogaClassSession>> searchSessionsByTime(String timeOfDay) async {
    try {
      final allSessions = await getAllClassSessions();
      return allSessions.where((session) {
        return session.classDate.toLowerCase().contains(
          timeOfDay.toLowerCase(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search sessions by time: $e');
    }
  }

  // Get user's booking history
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      final snapshot = await _bookingsRef
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final List<Map<String, dynamic>> bookings = [];
        for (final child in snapshot.children) {
          try {
            final data = child.value;
            if (data is Map) {
              // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
              final Map<String, dynamic> booking = {};
              data.forEach((key, value) {
                if (key is String) {
                  booking[key] = value;
                }
              });
              booking['bookingId'] = child.key; // Add the booking ID
              bookings.add(booking);
            }
          } catch (parseError) {
            continue; // Skip this booking if there's an error
          }
        }
        // Sort by booking date (newest first)
        bookings.sort((a, b) {
          try {
            final dateA = DateTime.parse(a['bookingDate'] ?? '');
            final dateB = DateTime.parse(b['bookingDate'] ?? '');
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0; // Keep original order if parsing fails
          }
        });
        return bookings;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch user bookings: $e');
    }
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Delete a booking from Firebase
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _bookingsRef.child(bookingId).remove();
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }
}
