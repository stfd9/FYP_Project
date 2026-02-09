import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../calendar_event.dart';
import 'base_view_model.dart';

class AddScheduleViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // --- Controllers (Renamed to match the new logic) ---
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // --- State Variables ---
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  DateTime? _reminderDateTime;
  bool _reminderEnabled = false;

  // Placeholder for Pet object (Change 'dynamic' to 'Pet' if you have the model imported)
  dynamic _selectedPet;
  String? userId; // To store resolved User ID

  // --- Getters ---
  DateTime? get startDateTime => _startDateTime;
  DateTime? get endDateTime => _endDateTime;
  DateTime? get reminderDateTime => _reminderDateTime;
  bool get reminderEnabled => _reminderEnabled;
  dynamic get selectedPet => _selectedPet;

  // --- Setters ---
  void setStartDate(DateTime? date) {
    _startDateTime = date;
    notifyListeners();
  }

  void setEndDate(DateTime? date) {
    _endDateTime = date;
    notifyListeners();
  }

  void setReminderDate(DateTime? date) {
    _reminderDateTime = date;
    notifyListeners();
  }

  void toggleReminder(bool value) {
    _reminderEnabled = value;
    notifyListeners();
  }

  void setSelectedPet(dynamic pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  // --- Helper to Format Date for UI ---
  String formatDateTimeLabel(
    DateTime? value, {
    String placeholder = 'Select Date',
  }) {
    if (value == null) return placeholder;
    return DateFormat('EEE, d MMM yyyy • h:mm a').format(value);
  }

  // --- Date Picker Logic ---
  Future<void> pickDateTime(
    BuildContext context, {
    required bool isStart,
  }) async {
    final now = DateTime.now();
    final initial = isStart ? (_startDateTime ?? now) : (_endDateTime ?? now);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null || !context.mounted) return;

    final timeInitial = TimeOfDay.fromDateTime(initial);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: timeInitial,
    );

    if (selectedTime == null || !context.mounted) return;

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (isStart) {
      _startDateTime = result;
    } else {
      _endDateTime = result;
    }
    notifyListeners();
  }

  // --- Main Save Logic ---
  void onSaveSchedulePressed(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    // 1. Validation
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

    // 2. Async Save Operation
    runAsync(() async {
      await _performSave(context);
    });
  }

  Future<void> _performSave(BuildContext context) async {
    final start = _startDateTime!;
    final end = _endDateTime!;

    // 3. Resolve User ID
    final resolvedUserId = await _resolveUserId();
    if (resolvedUserId == null || resolvedUserId.isEmpty) {
      if (context.mounted) {
        _showSnack(context, 'User not found. Please log in again.');
      }
      return;
    }

    // 4. Create Payload
    final scheduleId = await _createSchedule(
      scheTitle: titleController.text.trim(),
      scheDescription: descriptionController.text.trim(),
      startDateTime: start,
      endDateTime: end,
      reminderEnabled: _reminderEnabled,
      reminderDateTime: _reminderDateTime,
      petId: _selectedPet?.id,
      userId: resolvedUserId,
    );

    if (!context.mounted) return;

    // 5. Create Local Event for Calendar (Immediate UI update)
    final timeString = DateFormat('h:mm a').format(start);
    final newEvent = CalendarEvent(
      day: start.day,
      petName: _selectedPet?.name ?? '',
      activity: titleController.text.trim(),
      location: descriptionController.text.trim(),
      time: timeString,
      scheduleId: scheduleId,
      startDateTime: start,
      endDateTime: end,
      reminderEnabled: _reminderEnabled,
      reminderDateTime: _reminderDateTime,
      petId: _selectedPet?.id,
    );

    if (context.mounted) {
      Navigator.pop(context, newEvent);
    }
  }

  // --- Helpers ---

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

  Future<String> _createSchedule({
    required String scheTitle,
    required String scheDescription,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required bool reminderEnabled,
    required DateTime? reminderDateTime,
    required String? petId,
    required String userId,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('schedules').doc();
    await docRef.set({
      'scheduleId': docRef.id,
      'scheTitle': scheTitle,
      'scheDescription': scheDescription,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'reminderEnabled': reminderEnabled,
      'reminderDateTime': reminderEnabled && reminderDateTime != null
          ? Timestamp.fromDate(reminderDateTime)
          : null,
      'scheCreatedAt': FieldValue.serverTimestamp(),
      'petId': petId,
      'userId': userId,
    });
    return docRef.id;
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
