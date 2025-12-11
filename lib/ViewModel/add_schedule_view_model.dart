import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar_event.dart';
import 'base_view_model.dart';

class AddScheduleViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime? _scheduledAt;

  String get scheduledLabel => _scheduledAt == null
      ? 'Pick date & time'
      : DateFormat('EEE, d MMM yyyy • h:mm a').format(_scheduledAt!);

  void onPickDateTimePressed(BuildContext context) {
    pickDateTime(context);
  }

  Future<void> pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    final initialTime = _scheduledAt != null
        ? TimeOfDay.fromDateTime(_scheduledAt!)
        : TimeOfDay.fromDateTime(now);

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime == null) return;

    _scheduledAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    notifyListeners();
  }

  void onSaveSchedulePressed(BuildContext context) {
    saveSchedule(context);
  }

  void saveSchedule(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    if (_scheduledAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time')),
      );
      return;
    }

    final timeString = DateFormat('h:mm a').format(_scheduledAt!);

    final newEvent = CalendarEvent(
      day: _scheduledAt!.day,
      petName: petNameController.text.trim(),
      activity: activityController.text.trim(),
      location: locationController.text.trim(),
      time: timeString,
    );

    Navigator.pop(context, newEvent);
  }

  @override
  void dispose() {
    petNameController.dispose();
    activityController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
