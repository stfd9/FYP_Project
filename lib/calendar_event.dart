// lib/calendar_event.dart
class CalendarEvent {
  const CalendarEvent({
    required this.day,
    required this.petName,
    required this.activity,
    required this.location,
    required this.time,
    this.scheduleId,
    this.startDateTime,
    this.endDateTime,
    this.reminderEnabled = false,
    this.reminderDateTime,
    this.petId,
    this.isCompleted = false,
  });

  final int day;
  final String petName;
  final String activity;
  final String location;
  final String time;
  final String? scheduleId;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final bool reminderEnabled;
  final DateTime? reminderDateTime;
  final String? petId;
  final bool isCompleted;
}
