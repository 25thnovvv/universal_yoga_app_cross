import 'yoga_class_session.dart';
import 'yoga_course.dart';

class CartItem {
  final String id;
  final YogaCourse? course;
  final YogaClassSession? session;
  final int quantity;
  final DateTime addedAt;
  final bool isCourse; // true if this is a course, false if it's a session

  CartItem({
    required this.id,
    this.course,
    this.session,
    this.quantity = 1,
    required this.addedAt,
    required this.isCourse,
  }) : assert(
         (course != null && session == null && isCourse) ||
             (session != null && course == null && !isCourse),
       );

  factory CartItem.fromJson(Map<String, dynamic> json) {
    try {
      final isCourse = json['isCourse'] ?? false;

      DateTime addedAt;
      try {
        addedAt = DateTime.parse(
          json['addedAt'] ?? DateTime.now().toIso8601String(),
        );
      } catch (e) {
        addedAt = DateTime.now();
      }

      YogaCourse? course;
      YogaClassSession? session;

      if (isCourse) {
        try {
          final courseData = json['course'];
          if (courseData is Map) {
            // Convert Map<Object?, Object?> to Map<String, dynamic>
            final Map<String, dynamic> courseMap = {};
            courseData.forEach((key, value) {
              if (key is String) {
                courseMap[key] = value;
              } else if (key != null) {
                courseMap[key.toString()] = value;
              }
            });
            course = YogaCourse.fromJson(courseMap);
          }
        } catch (e) {
          course = null;
        }
      } else {
        try {
          final sessionData = json['session'];
          if (sessionData is Map) {
            final Map<String, dynamic> sessionMap = {};
            sessionData.forEach((key, value) {
              if (key is String) {
                sessionMap[key] = value;
              } else if (key != null) {
                sessionMap[key.toString()] = value;
              }
            });
            session = YogaClassSession.fromJson(sessionMap);
          }
        } catch (e) {
          session = null;
        }
      }

      final quantity = (json['quantity'] ?? 1) is int ? json['quantity'] : 1;

      return CartItem(
        id: json['id']?.toString() ?? '',
        course: course,
        session: session,
        quantity: quantity,
        addedAt: addedAt,
        isCourse: isCourse,
      );
    } catch (e) {
      return CartItem(
        id: json['id']?.toString() ?? '',
        course: null,
        session: null,
        quantity: 1,
        addedAt: DateTime.now(),
        isCourse: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course?.toJson(),
      'session': session?.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'isCourse': isCourse,
    };
  }

  CartItem copyWith({
    String? id,
    YogaCourse? course,
    YogaClassSession? session,
    int? quantity,
    DateTime? addedAt,
    bool? isCourse,
  }) {
    return CartItem(
      id: id ?? this.id,
      course: course ?? this.course,
      session: session ?? this.session,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      isCourse: isCourse ?? this.isCourse,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, course: $course, session: $session, quantity: $quantity, addedAt: $addedAt, isCourse: $isCourse)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.course == course &&
        other.session == session &&
        other.quantity == quantity &&
        other.addedAt == addedAt &&
        other.isCourse == isCourse;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        course.hashCode ^
        session.hashCode ^
        quantity.hashCode ^
        addedAt.hashCode ^
        isCourse.hashCode;
  }
}
