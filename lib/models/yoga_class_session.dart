class YogaClassSession {
  final String sessionId;
  final String parentCourseId;
  final String classDate;
  final String assignedInstructor;
  final String classNotes;
  final int localDatabaseId;

  YogaClassSession({
    required this.sessionId,
    required this.parentCourseId,
    required this.classDate,
    required this.assignedInstructor,
    required this.classNotes,
    required this.localDatabaseId,
  });

  factory YogaClassSession.fromJson(Map<String, dynamic> json) {
    return YogaClassSession(
      sessionId: json['sessionId'] ?? json['id'] ?? '',
      parentCourseId: json['parentCourseId'] ?? json['courseId'] ?? '',
      classDate: json['classDate'] ?? json['date'] ?? '',
      assignedInstructor: json['assignedInstructor'] ?? json['teacher'] ?? '',
      classNotes: json['classNotes'] ?? json['note'] ?? '',
      localDatabaseId: json['localDatabaseId'] ?? json['localId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'parentCourseId': parentCourseId,
      'classDate': classDate,
      'assignedInstructor': assignedInstructor,
      'classNotes': classNotes,
      'localDatabaseId': localDatabaseId,
    };
  }

  YogaClassSession copyWith({
    String? sessionId,
    String? parentCourseId,
    String? classDate,
    String? assignedInstructor,
    String? classNotes,
    int? localDatabaseId,
  }) {
    return YogaClassSession(
      sessionId: sessionId ?? this.sessionId,
      parentCourseId: parentCourseId ?? this.parentCourseId,
      classDate: classDate ?? this.classDate,
      assignedInstructor: assignedInstructor ?? this.assignedInstructor,
      classNotes: classNotes ?? this.classNotes,
      localDatabaseId: localDatabaseId ?? this.localDatabaseId,
    );
  }

  @override
  String toString() {
    return 'YogaClassSession(sessionId: $sessionId, parentCourseId: $parentCourseId, classDate: $classDate, assignedInstructor: $assignedInstructor, classNotes: $classNotes, localDatabaseId: $localDatabaseId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YogaClassSession &&
        other.sessionId == sessionId &&
        other.parentCourseId == parentCourseId &&
        other.classDate == classDate &&
        other.assignedInstructor == assignedInstructor &&
        other.classNotes == classNotes &&
        other.localDatabaseId == localDatabaseId;
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^
        parentCourseId.hashCode ^
        classDate.hashCode ^
        assignedInstructor.hashCode ^
        classNotes.hashCode ^
        localDatabaseId.hashCode;
  }
} 