import 'package:flutter/material.dart';

import '../calendar_event.dart';
import 'base_view_model.dart';

class ScheduleDetailViewModel extends BaseViewModel {
  final CalendarEvent event;

  ScheduleDetailViewModel(this.event);

  Future<void> removeSchedule(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove schedule'),
          content: const Text('Are you sure you want to remove this schedule?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) {
        return;
      }
      Navigator.pop(context, true);
    }
  }

  String get formattedDay => _ordinalDay(event.day);

  String _ordinalDay(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
}
