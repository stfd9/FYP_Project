import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar_event.dart';
import '../models/pet_info.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'base_view_model.dart';

class AddScheduleViewModel extends BaseViewModel {
  AddScheduleViewModel({this.userId, ScheduleService? scheduleService})
    : _scheduleService = scheduleService ?? ScheduleService();

  final ScheduleService _scheduleService;
  final String? userId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PetInfo? _selectedPet;

  PetInfo? get selectedPet => _selectedPet;

  set selectedPet(PetInfo? value) {
    _selectedPet = value;
    notifyListeners();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;
  bool _reminderEnabled = false;
  DateTime? _reminderDateTime;

  String get startLabel => _formatDateTimeLabel(
    _startDateTime,
    placeholder: 'Select start date & time',
  );
  String get endLabel =>
      _formatDateTimeLabel(_endDateTime, placeholder: 'Select end date & time');
  String get reminderLabel => _formatDateTimeLabel(
    _reminderDateTime,
    placeholder: 'Select reminder date & time',
  );
  bool get reminderEnabled => _reminderEnabled;

  void onPickStartDateTimePressed(BuildContext context) {
    pickStartDateTime(context);
  }

  void onPickEndDateTimePressed(BuildContext context) {
    pickEndDateTime(context);
  }

  void onPickReminderDateTimePressed(BuildContext context) {
    pickReminderDateTime(context);
  }

  void setReminderEnabled(bool value) {
    if (_reminderEnabled == value) return;
    _reminderEnabled = value;
    notifyListeners();
  }

  Future<DateTime?> _pickDateTime(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null || !context.mounted) return null;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
    );

    if (selectedTime == null || !context.mounted) return null;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  Future<void> pickStartDateTime(BuildContext context) async {
    final now = DateTime.now();
    final initial = _startDateTime ?? now;
    final picked = await _pickDateTime(context, initial);
    if (picked == null) return;

    _startDateTime = picked;
    if (_endDateTime != null && _endDateTime!.isBefore(picked)) {
      _endDateTime = picked;
    }
    if (_reminderDateTime != null && _reminderDateTime!.isAfter(picked)) {
      _reminderDateTime = null;
    }
    notifyListeners();
  }

  Future<void> pickEndDateTime(BuildContext context) async {
    if (_startDateTime == null) {
      _showSnack(context, 'Please select a start date & time first.');
      return;
    }

    final initial = _endDateTime ?? _startDateTime!;
    final picked = await _pickDateTime(context, initial);
    if (picked == null) return;

    _endDateTime = picked;
    notifyListeners();
  }

  Future<void> pickReminderDateTime(BuildContext context) async {
    if (_startDateTime == null) {
      _showSnack(context, 'Please select a start date & time first.');
      return;
    }

    final initial = _reminderDateTime ?? _startDateTime!;
    final picked = await _pickDateTime(context, initial);
    if (picked == null) return;

    _reminderDateTime = picked;
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

    if (userId == null || userId!.trim().isEmpty) {
      _showSnack(context, 'User not found. Please log in again.');
      return;
    }

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
      final payload = ScheduleCreate(
        scheTitle: titleController.text.trim(),
        scheDescription: descriptionController.text.trim(),
        startDateTime: start,
        endDateTime: end,
        reminderEnabled: _reminderEnabled,
        reminderDateTime: _reminderDateTime,
        petId: _selectedPet?.id,
        userId: userId!.trim(),
      );

      await _scheduleService.createSchedule(payload);

      if (!context.mounted) return;

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

  String _formatDateTimeLabel(DateTime? value, {required String placeholder}) {
    if (value == null) return placeholder;
    return DateFormat('EEE, d MMM yyyy • h:mm a').format(value);
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
