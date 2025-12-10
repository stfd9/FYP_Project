import 'package:flutter/material.dart';

class NotificationsViewModel extends ChangeNotifier {
  final List<NotificationItem> _todayNotifications = [
    NotificationItem(
      title: 'Upcoming vaccination',
      message: 'Milo has a vaccination scheduled for today at 4:00 PM.',
      timeLabel: 'Just now',
      linkedDate: DateTime(2025, 1, 10),
    ),
    NotificationItem(
      title: 'Scan reminder',
      message: 'It’s been a week since Luna’s last skin scan.',
      timeLabel: '10 min ago',
    ),
  ];

  final List<NotificationItem> _earlierNotifications = [
    NotificationItem(
      title: 'New feature',
      message: 'Try the new scan history feature in your Scan tab.',
      timeLabel: 'Yesterday',
      isUnread: false,
    ),
    NotificationItem(
      title: 'Welcome to PetCare AI',
      message:
          'Thanks for joining! Add your pets to get personalized insights.',
      timeLabel: '2 days ago',
      isUnread: false,
    ),
  ];

  List<NotificationItem> get todayNotifications =>
      List.unmodifiable(_todayNotifications);
  List<NotificationItem> get earlierNotifications =>
      List.unmodifiable(_earlierNotifications);

  bool get hasUnread =>
      _todayNotifications.any((n) => n.isUnread) ||
      _earlierNotifications.any((n) => n.isUnread);

  void markAllAsRead() {
    for (final item in _todayNotifications) {
      item.isUnread = false;
    }
    for (final item in _earlierNotifications) {
      item.isUnread = false;
    }
    notifyListeners();
  }

  void markAsRead(NotificationItem item) {
    if (!item.isUnread) return;
    item.isUnread = false;
    notifyListeners();
  }

  // --- NEW FUNCTION: Handles Navigation Logic ---
  void openNotificationDetail(BuildContext context, NotificationItem item) {
    // 1. Logic: Mark as read immediately
    markAsRead(item);

    // 2. Logic: Decide where to go (Navigate to Detail Page)
    Navigator.pushNamed(context, '/notification_detail', arguments: item);
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String timeLabel;
  bool isUnread;
  final DateTime? linkedDate;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timeLabel,
    this.isUnread = true,
    this.linkedDate,
  });
}
