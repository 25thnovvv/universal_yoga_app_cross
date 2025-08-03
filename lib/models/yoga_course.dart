class YogaCourse {
  final String courseId;
  final String courseName;
  final String weeklySchedule;
  final String classTime;
  final String instructorName;
  final int maxStudents;
  final double coursePrice;
  final int sessionDuration;
  final String courseDescription;
  final String additionalNotes;
  final String nextClassDate;
  final int databaseId;

  YogaCourse({
    required this.courseId,
    required this.courseName,
    required this.weeklySchedule,
    required this.classTime,
    required this.instructorName,
    required this.maxStudents,
    required this.coursePrice,
    required this.sessionDuration,
    required this.courseDescription,
    required this.additionalNotes,
    required this.nextClassDate,
    required this.databaseId,
  });

  factory YogaCourse.fromJson(Map<String, dynamic> json) {
    return YogaCourse(
      courseId: json['courseId'] ?? json['id'] ?? '',
      courseName: json['courseName'] ?? json['name'] ?? '',
      weeklySchedule: json['weeklySchedule'] ?? json['schedule'] ?? '',
      classTime: json['classTime'] ?? json['time'] ?? '',
      instructorName: json['instructorName'] ?? json['teacher'] ?? '',
      maxStudents: json['maxStudents'] ?? json['capacity'] ?? 0,
      coursePrice: (json['coursePrice'] ?? json['price'] ?? 0.0).toDouble(),
      sessionDuration: json['sessionDuration'] ?? json['duration'] ?? 0,
      courseDescription: json['courseDescription'] ?? json['description'] ?? '',
      additionalNotes: json['additionalNotes'] ?? json['note'] ?? '',
      nextClassDate: json['nextClassDate'] ?? json['upcomingDate'] ?? '',
      databaseId: json['databaseId'] ?? json['localId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'weeklySchedule': weeklySchedule,
      'classTime': classTime,
      'instructorName': instructorName,
      'maxStudents': maxStudents,
      'coursePrice': coursePrice,
      'sessionDuration': sessionDuration,
      'courseDescription': courseDescription,
      'additionalNotes': additionalNotes,
      'nextClassDate': nextClassDate,
      'databaseId': databaseId,
    };
  }

  YogaCourse copyWith({
    String? courseId,
    String? courseName,
    String? weeklySchedule,
    String? classTime,
    String? instructorName,
    int? maxStudents,
    double? coursePrice,
    int? sessionDuration,
    String? courseDescription,
    String? additionalNotes,
    String? nextClassDate,
    int? databaseId,
  }) {
    return YogaCourse(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      classTime: classTime ?? this.classTime,
      instructorName: instructorName ?? this.instructorName,
      maxStudents: maxStudents ?? this.maxStudents,
      coursePrice: coursePrice ?? this.coursePrice,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      courseDescription: courseDescription ?? this.courseDescription,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      nextClassDate: nextClassDate ?? this.nextClassDate,
      databaseId: databaseId ?? this.databaseId,
    );
  }

  @override
  String toString() {
    return 'YogaCourse(courseId: $courseId, courseName: $courseName, weeklySchedule: $weeklySchedule, classTime: $classTime, instructorName: $instructorName, maxStudents: $maxStudents, coursePrice: $coursePrice, sessionDuration: $sessionDuration, courseDescription: $courseDescription, additionalNotes: $additionalNotes, nextClassDate: $nextClassDate, databaseId: $databaseId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YogaCourse &&
        other.courseId == courseId &&
        other.courseName == courseName &&
        other.weeklySchedule == weeklySchedule &&
        other.classTime == classTime &&
        other.instructorName == instructorName &&
        other.maxStudents == maxStudents &&
        other.coursePrice == coursePrice &&
        other.sessionDuration == sessionDuration &&
        other.courseDescription == courseDescription &&
        other.additionalNotes == additionalNotes &&
        other.nextClassDate == nextClassDate &&
        other.databaseId == databaseId;
  }

  @override
  int get hashCode {
    return courseId.hashCode ^
        courseName.hashCode ^
        weeklySchedule.hashCode ^
        classTime.hashCode ^
        instructorName.hashCode ^
        maxStudents.hashCode ^
        coursePrice.hashCode ^
        sessionDuration.hashCode ^
        courseDescription.hashCode ^
        additionalNotes.hashCode ^
        nextClassDate.hashCode ^
        databaseId.hashCode;
  }
} 