import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../calendar_event.dart';
import 'base_view_model.dart';

class AddScheduleViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _selectedPetName;

  String? get selectedPetName => _selectedPetName;

  set selectedPetName(String? v) {
    _selectedPetName = v;
    notifyListeners();
  }

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

    if (selectedDate == null || !context.mounted) return;

    final initialTime = _scheduledAt != null
        ? TimeOfDay.fromDateTime(_scheduledAt!)
        : TimeOfDay.fromDateTime(now);

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime == null || !context.mounted) return;

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

<<<<<<< HEAD
    if (_scheduledAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time')),
=======
    if (_startDateTime == null || _endDateTime == null) {
      _showSnack(context, 'Please select start and end date & time.');
      return;
    }

    if (_endDateTime!.isBefore(_startDateTime!)) {
      _showSnack(context, 'End time cannot be before start time.');
      return;
    }

    if (_reminderEnabled && _reminderDateTime == null) {
      _showSnack(context, 'Please select a reminder date & time.');
      return;
    }

    if (_reminderEnabled &&
        _reminderDateTime != null &&
        _reminderDateTime!.isAfter(_startDateTime!)) {
      _showSnack(context, 'Reminder must be before the start time.');
      return;
    }

    final start = _startDateTime!;
    final end = _endDateTime!;

    runAsync(() async {
      final resolvedUserId = await _resolveUserId();
      if (resolvedUserId == null || resolvedUserId.isEmpty) {
        if (context.mounted) {
          _showSnack(context, 'User not found. Please log in again.');
        }
        return;
      }

      final payload = ScheduleCreate(
        scheTitle: titleController.text.trim(),
        scheDescription: descriptionController.text.trim(),
        startDateTime: start,
        endDateTime: end,
        reminderEnabled: _reminderEnabled,
        reminderDateTime: _reminderDateTime,
        petId: _selectedPet?.id,
        userId: resolvedUserId,
>>>>>>> 83a1e546d7253223782158454cca43600bece61d
      );
      return;
    }

    final timeString = DateFormat('h:mm a').format(_scheduledAt!);

    final newEvent = CalendarEvent(
      day: _scheduledAt!.day,
      petName: selectedPetName?.trim() ?? '',
      activity: activityController.text.trim(),
      location: locationController.text.trim(),
      time: timeString,
    );

<<<<<<< HEAD
    Navigator.pop(context, newEvent);
=======
      final timeString = DateFormat('h:mm a').format(start);
      final newEvent = CalendarEvent(
        day: start.day,
        petName: _selectedPet?.name ?? '',
        activity: titleController.text.trim(),
        location: descriptionController.text.trim(),
        time: timeString,
      );

      Navigator.pop(context, newEvent);
    });
  }

  Future<String?> _resolveUserId() async {
    if (userId != null && userId!.trim().isNotEmpty) {
      return userId!.trim();
    }

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

  String _formatDateTimeLabel(DateTime? value, {required String placeholder}) {
    if (value == null) return placeholder;
    return DateFormat('EEE, d MMM yyyy • h:mm a').format(value);
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
>>>>>>> 83a1e546d7253223782158454cca43600bece61d
  }

  @override
  void dispose() {
    activityController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
