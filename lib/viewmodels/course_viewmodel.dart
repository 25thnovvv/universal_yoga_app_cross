import 'package:flutter/foundation.dart';
import '../models/yoga_course.dart';
import '../models/yoga_class_session.dart';
import '../services/firebase_service.dart';

class CourseViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<YogaCourse> _courses = [];
  List<YogaCourse> _filteredCourses = [];
  List<YogaClassSession> _classSessions = [];
  List<YogaClassSession> _filteredSessions = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedDay = '';
  String _selectedTime = '';

  List<YogaCourse> get courses => _filteredCourses;
  List<YogaClassSession> get classSessions => _filteredSessions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedDay => _selectedDay;
  String get selectedTime => _selectedTime;

  CourseViewModel() {
    loadCourses();
    loadClassSessions();
  }

  Future<void> loadCourses() async {
    _setLoading(true);
    _clearError();

    try {
      _courses = await _firebaseService.getAllCourses();
      _applyCourseFilters();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> loadClassSessions() async {
    _setLoading(true);
    _clearError();

    try {
      _classSessions = await _firebaseService.getAllClassSessions();
      _applySessionFilters();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> loadClassSessionsByCourse(String courseId) async {
    _setLoading(true);
    _clearError();

    try {
      _classSessions = await _firebaseService.getClassSessionsByCourseId(
        courseId,
      );
      _applySessionFilters();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> retryLoadClassSessionsByCourse(String courseId) async {
    _setLoading(true);
    _clearError();

    try {
      // Add a small delay before retry
      await Future.delayed(const Duration(milliseconds: 500));

      _classSessions = await _firebaseService.getClassSessionsByCourseId(
        courseId,
      );
      _applySessionFilters();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<List<YogaClassSession>> searchByDayOfWeek(String dayOfWeek) async {
    _setLoading(true);
    _clearError();

    try {
      final sessions = await _firebaseService.searchSessionsByDayOfWeek(
        dayOfWeek,
      );
      _setLoading(false);
      return sessions;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  Future<List<YogaClassSession>> searchByTime(String timeOfDay) async {
    _setLoading(true);
    _clearError();

    try {
      final sessions = await _firebaseService.searchSessionsByTime(timeOfDay);
      _setLoading(false);
      return sessions;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyCourseFilters();
  }

  void setSelectedDay(String day) {
    _selectedDay = day;
    _applyCourseFilters();
  }

  void setSelectedTime(String time) {
    _selectedTime = time;
    _applyCourseFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedDay = '';
    _selectedTime = '';
    _applyCourseFilters();
  }

  void _applyCourseFilters() {
    _filteredCourses = _courses.where((course) {
      bool matchesSearch = true;
      bool matchesDay = true;
      bool matchesTime = true;

      // Apply search query filter
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            course.courseName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            course.instructorName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            course.courseDescription.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }

      // Apply day filter
      if (_selectedDay.isNotEmpty) {
        matchesDay = course.weeklySchedule.toLowerCase().contains(
          _selectedDay.toLowerCase(),
        );
      }

      // Apply time filter
      if (_selectedTime.isNotEmpty) {
        // Convert time slots to English
        String timeFilter = _selectedTime.toLowerCase();
        if (timeFilter == 'morning')
          timeFilter = 'morning';
        else if (timeFilter == 'afternoon')
          timeFilter = 'afternoon';
        else if (timeFilter == 'evening')
          timeFilter = 'evening';
        else if (timeFilter == 'night')
          timeFilter = 'night';

        matchesTime = course.classTime.toLowerCase().contains(timeFilter);
      }

      return matchesSearch && matchesDay && matchesTime;
    }).toList();

    notifyListeners();
  }

  void _applySessionFilters() {
    _filteredSessions = _classSessions.where((session) {
      bool matchesSearch = true;
      bool matchesDay = true;
      bool matchesTime = true;

      // Apply search query filter
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            session.classDate.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            session.assignedInstructor.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            session.classNotes.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }

      // Apply day filter
      if (_selectedDay.isNotEmpty) {
        try {
          final date = DateTime.parse(session.classDate);
          final sessionDay = _getDayOfWeek(date.weekday);
          matchesDay = sessionDay.toLowerCase().contains(
            _selectedDay.toLowerCase(),
          );
        } catch (e) {
          matchesDay = false;
        }
      }

      // Apply time filter
      if (_selectedTime.isNotEmpty) {
        matchesTime = session.classDate.toLowerCase().contains(
          _selectedTime.toLowerCase(),
        );
      }

      return matchesSearch && matchesDay && matchesTime;
    }).toList();

    notifyListeners();
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

  YogaCourse? getCourseById(String courseId) {
    try {
      return _courses.firstWhere((course) => course.courseId == courseId);
    } catch (e) {
      return null;
    }
  }

  int getSessionCountForCourse(String courseId) {
    return _classSessions
        .where((session) => session.parentCourseId == courseId)
        .length;
  }

  List<YogaClassSession> getSessionsForCourse(String courseId) {
    return _classSessions
        .where((session) => session.parentCourseId == courseId)
        .toList();
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
