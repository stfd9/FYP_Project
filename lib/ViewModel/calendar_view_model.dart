import 'package:flutter/material.dart';

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

  final List<CalendarEvent> _events = [
    const CalendarEvent(
      day: 10,
      petName: 'Luna',
      activity: 'Vaccination',
      location: 'KL Vet',
      time: '2:00 p.m.',
    ),
    const CalendarEvent(
      day: 23,
      petName: 'CoCo',
      activity: 'Grooming',
      location: 'Furii Style',
      time: '10:00 a.m.',
    ),
  ];

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
  }

  int get selectedDay => _selectedDay;
  int get currentMonth => _currentMonth;
  int get currentYear => _currentYear;
  String get monthYearLabel =>
      '${_monthNames[_currentMonth - 1]} $_currentYear';
  List<CalendarEvent> get events => List.unmodifiable(_events);

  CalendarEvent? get selectedEvent =>
      _events.where((event) => event.day == _selectedDay).firstOrNull;

  List<int?> get days => _buildDays();

  void selectDay(int day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    notifyListeners();
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
}

// Helper extension if you are on an older Dart version
extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
