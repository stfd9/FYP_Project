// lib/calendar_event.dart
class CalendarEvent {
  const CalendarEvent({
    required this.day,
    required this.petName,
    required this.activity,
    required this.location,
    required this.time,
  });

  final int day;
  final String petName;
  final String activity;
  final String location;
  final String time;
}
