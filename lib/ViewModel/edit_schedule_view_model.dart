import 'package:flutter/material.dart';
import '../calendar_event.dart';

class EditScheduleViewModel extends ChangeNotifier {
  final CalendarEvent originalEvent;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController petNameController;
  late TextEditingController activityController;
  late TextEditingController locationController;
  String? _selectedPetName;

  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  EditScheduleViewModel(this.originalEvent)
    : _selectedDate = DateTime.now(),
      _selectedTime = TimeOfDay.now() {
    // Initialize controllers with original event data
    // Initialize selected pet name from the original event
    _selectedPetName = originalEvent.petName;
    activityController = TextEditingController(text: originalEvent.activity);
    locationController = TextEditingController(text: originalEvent.location);

    // Parse the original event's day and time
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, originalEvent.day);

    // Parse time string like "10:00 AM"
    _selectedTime = _parseTimeString(originalEvent.time);
  }

  TimeOfDay _parseTimeString(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;

  String get formattedDateTime {
    final day = _selectedDate.day;
    final suffix = _getDaySuffix(day);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[_selectedDate.month - 1];

    final hour = _selectedTime.hourOfPeriod == 0
        ? 12
        : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    return '$day$suffix $month ${_selectedDate.year} at $hour:$minute $period';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    // Pick Date
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      // Pick Time
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (time != null) {
        _selectedDate = date;
        _selectedTime = time;
        notifyListeners();
      }
    }
  }

  CalendarEvent get updatedEvent {
    final hour = _selectedTime.hourOfPeriod == 0
        ? 12
        : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    final timeString = '$hour:$minute $period';

    return CalendarEvent(
      day: _selectedDate.day,
      petName: _selectedPetName?.trim() ?? '',
      activity: activityController.text.trim(),
      location: locationController.text.trim(),
      time: timeString,
    );
  }

  void saveChanges(BuildContext context) {
    if (formKey.currentState?.validate() != true) return;

    showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(
                  ctx,
                ).colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.save_rounded,
                color: Theme.of(ctx).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Save Changes?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to save these changes to the schedule?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && context.mounted) {
        // Wait a tick for dialog pop animation to unlock navigator
        await Future.delayed(const Duration(milliseconds: 120));
        if (context.mounted) {
          Navigator.pop(context, updatedEvent);
        }
      }
    });
  }

  @override
  void dispose() {
    activityController.dispose();
    locationController.dispose();
    super.dispose();
  }

  String? get selectedPetName => _selectedPetName;

  set selectedPetName(String? v) {
    _selectedPetName = v;
    notifyListeners();
  }
}
