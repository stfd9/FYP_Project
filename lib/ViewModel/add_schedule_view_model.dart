import 'package:flutter/material.dart';

import '../calendar_event.dart';
import 'base_view_model.dart';

class AddScheduleViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  int _selectedDay = 1;

  int get selectedDay => _selectedDay;

  void selectDay(int day) {
    _selectedDay = day;
    notifyListeners();
  }

  void saveSchedule(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final newEvent = CalendarEvent(
      day: _selectedDay,
      petName: petNameController.text.trim(),
      activity: activityController.text.trim(),
      location: locationController.text.trim(),
      time: timeController.text.trim(),
    );

    Navigator.pop(context, newEvent);
  }

  @override
  void dispose() {
    petNameController.dispose();
    activityController.dispose();
    locationController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
