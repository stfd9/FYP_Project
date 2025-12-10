import 'package:flutter/material.dart';

import 'base_view_model.dart';

class NotificationSettingsViewModel extends BaseViewModel {
  bool _medicationReminders = true;
  bool _vaccinationReminders = true;
  bool _generalUpdates = false;

  bool get medicationReminders => _medicationReminders;
  bool get vaccinationReminders => _vaccinationReminders;
  bool get generalUpdates => _generalUpdates;

  void toggleMedication(bool value) {
    _medicationReminders = value;
    notifyListeners();
  }

  void toggleVaccination(bool value) {
    _vaccinationReminders = value;
    notifyListeners();
  }

  void toggleGeneralUpdates(bool value) {
    _generalUpdates = value;
    notifyListeners();
  }

  void showInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved automatically.'),
      ),
    );
  }
}
