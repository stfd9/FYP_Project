import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../View/add_schedule_view.dart';
import '../View/schedule_detail_view.dart';
import '../calendar_event.dart';
import 'base_view_model.dart';

class CalendarViewModel extends BaseViewModel {
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<CalendarEvent> _events = [];
  StreamSubscription<QuerySnapshot>? _scheduleSubscription;

  late int _selectedDay;
  late int _currentMonth;
  late int _currentYear;

  CalendarViewModel({DateTime? initialDate}) {
    final now = DateTime.now();
    if (initialDate != null) {
      _selectedDay = initialDate.day;
      _currentMonth = initialDate.month;
      _currentYear = initialDate.year;
    } else {
      _selectedDay = now.day;
      _currentMonth = now.month;
      _currentYear = now.year;
    }

    runAsync(() async {
      await _startScheduleListener();
    });
  }

  int get selectedDay => _selectedDay;
  int get currentMonth => _currentMonth;
  int get currentYear => _currentYear;
  String get monthYearLabel =>
      '${_monthNames[_currentMonth - 1]} $_currentYear';
  List<CalendarEvent> get events => List.unmodifiable(_events);

  CalendarEvent? get selectedEvent => _events
      .where((event) => _isSameMonthDay(_eventDate(event), _selectedDay))
      .firstOrNull;

  List<int?> get days => _buildDays();

  // Month statistics
  int get totalEventsThisMonth {
    return _events
        .where(
          (event) =>
              _eventDate(event).year == _currentYear &&
              _eventDate(event).month == _currentMonth,
        )
        .length;
  }

  int get upcomingEvents {
    final today = _normalizeDate(DateTime.now());
    return _events
        .where(
          (event) =>
              _eventDate(event).isAfter(today) ||
              _eventDate(event).isAtSameMomentAs(today),
        )
        .length;
  }

  int get petsWithEvents {
    return _events
        .where(
          (event) =>
              _eventDate(event).year == _currentYear &&
              _eventDate(event).month == _currentMonth,
        )
        .map((event) => event.petName)
        .toSet()
        .length;
  }

  List<CalendarEvent> get upcomingEventsList {
    final today = _normalizeDate(DateTime.now());
    final upcoming = _events
        .where(
          (event) =>
              _eventDate(event).isAfter(today) ||
              _eventDate(event).isAtSameMomentAs(today),
        )
        .toList();
    upcoming.sort((a, b) => _eventDate(a).compareTo(_eventDate(b)));
    return List.unmodifiable(upcoming);
  }

  void selectDay(int day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    notifyListeners();
  }

  bool isEventDay(int day) {
    return _events.any((event) => _isSameMonthDay(_eventDate(event), day));
  }

  bool hasActiveEvent(int day) {
    return _events.any(
      (event) => _isSameMonthDay(_eventDate(event), day) && !event.isCompleted,
    );
  }

  bool hasCompletedOnlyEvent(int day) {
    final eventsForDay = _events.where(
      (event) => _isSameMonthDay(_eventDate(event), day),
    );
    if (eventsForDay.isEmpty) return false;
    return eventsForDay.every((event) => event.isCompleted);
  }

  void goToPreviousMonth() {
    if (_currentMonth == 1) {
      _currentMonth = 12;
      _currentYear--;
    } else {
      _currentMonth--;
    }
    _selectedDay = 1;
    notifyListeners();
  }

  void goToNextMonth() {
    if (_currentMonth == 12) {
      _currentMonth = 1;
      _currentYear++;
    } else {
      _currentMonth++;
    }
    _selectedDay = 1;
    notifyListeners();
  }

  void onAddSchedulePressed(BuildContext context) {
    addSchedule(context);
  }

  Future<void> addSchedule(BuildContext context) async {
    final newEvent = await Navigator.push<CalendarEvent>(
      context,
      MaterialPageRoute(builder: (_) => const AddScheduleView()),
    );

    if (newEvent == null) return;
    _events.add(newEvent);
    _selectedDay = newEvent.day;
    notifyListeners();
  }

  Future<void> _startScheduleListener() async {
    final resolvedUserId = await _resolveUserId();
    if (resolvedUserId == null || resolvedUserId.isEmpty) {
      _events.clear();
      notifyListeners();
      return;
    }

    await _scheduleSubscription?.cancel();
    _scheduleSubscription = FirebaseFirestore.instance
        .collection('schedules')
        .where('userId', isEqualTo: resolvedUserId)
        .snapshots()
        .listen((snapshot) {
          final events = snapshot.docs.map(_mapScheduleDoc).toList();
          _events
            ..clear()
            ..addAll(events);

          if (_events.isNotEmpty) {
            _selectedDay = _events.first.day;
          }

          notifyListeners();
        });
  }

  CalendarEvent _mapScheduleDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final start = _parseTimestamp(data['startDateTime']);
    final end = _parseTimestamp(data['endDateTime']);
    final reminderDateTime = _parseTimestamp(data['reminderDateTime']);
    final status = (data['status'] as String?) ?? 'Active';

    final startDate = start ?? DateTime.now();
    final timeString = DateFormat('h:mm a').format(startDate);

    return CalendarEvent(
      day: startDate.day,
      petName: '',
      activity: (data['scheTitle'] as String?) ?? '',
      location: (data['scheDescription'] as String?) ?? '',
      time: timeString,
      scheduleId: (data['scheduleId'] as String?) ?? doc.id,
      startDateTime: start,
      endDateTime: end,
      reminderEnabled: (data['reminderEnabled'] as bool?) ?? false,
      reminderDateTime: reminderDateTime,
      petId: data['petId'] as String?,
      isCompleted: status.toLowerCase() == 'completed',
    );
  }

  DateTime _eventDate(CalendarEvent event) {
    if (event.startDateTime != null) {
      return _normalizeDate(event.startDateTime!);
    }
    return DateTime(_currentYear, _currentMonth, event.day);
  }

  bool _isSameMonthDay(DateTime date, int day) {
    return date.year == _currentYear &&
        date.month == _currentMonth &&
        date.day == day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    return null;
  }

  Future<String?> _resolveUserId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('providerId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }

  void onOpenSelectedEventPressed(BuildContext context) {
    openSelectedEvent(context);
  }

  Future<void> openSelectedEvent(BuildContext context) async {
    final event = selectedEvent;
    if (event == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No event for this day.')));
      return;
    }

    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(builder: (_) => ScheduleDetailView(event: event)),
    );

    if (result == true) {
      // Event was deleted or marked completed
      _events.remove(event);
      notifyListeners();
    } else if (result is CalendarEvent) {
      // Event was edited - replace old event with updated one
      final index = _events.indexOf(event);
      if (index != -1) {
        _events[index] = result;
        notifyListeners();
      }
    }
  }

  List<int?> _buildDays() {
    // Get the number of days in the current month
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    // Get the weekday of the first day (1=Monday, 7=Sunday)
    final firstWeekday = DateTime(_currentYear, _currentMonth, 1).weekday;
    // Padding for days before the 1st
    final leadingPadding = List<int?>.filled(firstWeekday - 1, null);
    // Actual days
    final days = List<int?>.generate(daysInMonth, (index) => index + 1);
    // Combine and add trailing padding to fill grid
    final allDays = [...leadingPadding, ...days];
    final totalSlots = ((allDays.length / 7).ceil()) * 7;
    final trailingPadding = List<int?>.filled(
      totalSlots - allDays.length,
      null,
    );
    return [...allDays, ...trailingPadding];
  }

  @override
  void dispose() {
    _scheduleSubscription?.cancel();
    super.dispose();
  }
}

// Helper extension if you are on an older Dart version
extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
