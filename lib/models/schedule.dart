import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleCreate {
  const ScheduleCreate({
    required this.scheTitle,
    required this.scheDescription,
    required this.startDateTime,
    required this.endDateTime,
    required this.reminderEnabled,
    required this.reminderDateTime,
    required this.petId,
    required this.userId,
  });

  final String scheTitle;
  final String scheDescription;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool reminderEnabled;
  final DateTime? reminderDateTime;
  final String? petId;
  final String userId;

  Map<String, dynamic> toFirestore(String scheduleId) {
    return {
      'scheduleId': scheduleId,
      'scheTitle': scheTitle,
      'scheDescription': scheDescription,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'reminderEnabled': reminderEnabled,
      'reminderDateTime': reminderEnabled && reminderDateTime != null
          ? Timestamp.fromDate(reminderDateTime!)
          : null,
      'scheCreatedAt': FieldValue.serverTimestamp(),
      'petId': petId,
      'userId': userId,
    };
  }
}
