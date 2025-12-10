import 'package:flutter/material.dart';
import 'base_view_model.dart';
import 'notifications_view_model.dart';

class NotificationDetailViewModel extends BaseViewModel {
  final NotificationItem notification;

  NotificationDetailViewModel({required this.notification});

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void deleteNotification(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notification deleted')));
    Navigator.pop(context);
  }

  // --- UPDATED NAVIGATION ---
  void goToCalendar(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
      arguments: 1,
    );
  }
}
