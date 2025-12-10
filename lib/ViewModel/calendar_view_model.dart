import 'package:flutter/material.dart';

import '../View/add_schedule_view.dart';
import '../View/schedule_detail_view.dart';
import '../calendar_event.dart';
import 'base_view_model.dart';

class CalendarViewModel extends BaseViewModel {
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

  int _selectedDay = 10;

  int get selectedDay => _selectedDay;
  List<CalendarEvent> get events => List.unmodifiable(_events);
  CalendarEvent? get selectedEvent =>
      _events.where((event) => event.day == _selectedDay).firstOrNull;
  List<int?> get days => _buildDays();

  void selectDay(int day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    notifyListeners();
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

  Future<void> openSelectedEvent(BuildContext context) async {
    final event = selectedEvent;
    if (event == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No event for this day.')));
      return;
    }

    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ScheduleDetailView(event: event)),
    );

    if (removed == true) {
      _events.remove(event);
      notifyListeners();
    }
  }

  List<int?> _buildDays() {
    const totalSlots = 35;
    final days = List<int?>.generate(31, (index) => index + 1);
    final padding = List<int?>.filled(totalSlots - days.length, null);
    return [...days, ...padding];
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
