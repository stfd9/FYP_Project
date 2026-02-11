enum ReminderDuration {
  thirtyMinutes,
  oneHour,
  oneDay,
}

extension ReminderDurationExtension on ReminderDuration {
  String get displayName {
    switch (this) {
      case ReminderDuration.thirtyMinutes:
        return '30 minutes before';
      case ReminderDuration.oneHour:
        return '1 hour before';
      case ReminderDuration.oneDay:
        return '1 day before';
    }
  }

  String get shortName {
    switch (this) {
      case ReminderDuration.thirtyMinutes:
        return '30 min';
      case ReminderDuration.oneHour:
        return '1 hour';
      case ReminderDuration.oneDay:
        return '1 day';
    }
  }

  Duration get duration {
    switch (this) {
      case ReminderDuration.thirtyMinutes:
        return const Duration(minutes: 30);
      case ReminderDuration.oneHour:
        return const Duration(hours: 1);
      case ReminderDuration.oneDay:
        return const Duration(days: 1);
    }
  }

  DateTime calculateReminderTime(DateTime startDateTime) {
    return startDateTime.subtract(duration);
  }

  static ReminderDuration? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'thirtyMinutes':
        return ReminderDuration.thirtyMinutes;
      case 'oneHour':
        return ReminderDuration.oneHour;
      case 'oneDay':
        return ReminderDuration.oneDay;
      default:
        return null;
    }
  }

  String toFirestore() {
    return toString().split('.').last;
  }
}
