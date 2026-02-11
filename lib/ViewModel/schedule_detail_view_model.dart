import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../calendar_event.dart';
import '../services/notification_service.dart';
import 'base_view_model.dart';

class ScheduleDetailViewModel extends BaseViewModel {
  final CalendarEvent event;

  ScheduleDetailViewModel(this.event);

  Future<void> removeSchedule(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) {
        return LayoutBuilder(
          builder: (ctx, constraints) {
            final maxWidth = constraints.maxWidth;
            final dialogMaxWidth = maxWidth * 0.96;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Remove Schedule')),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: dialogMaxWidth),
                child: const Text(
                  'Are you sure you want to remove this schedule? This action cannot be undone.',
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Remove'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;

      // Delete from Firestore
      runAsync(() async {
        final scheduleId = event.scheduleId;
        if (scheduleId != null && scheduleId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('schedules')
              .doc(scheduleId)
              .delete();
        }

        await Future.delayed(const Duration(milliseconds: 120));
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      });
    }
  }

  Future<void> markAsCompleted(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) {
        return LayoutBuilder(
          builder: (ctx, constraints) {
            final maxWidth = constraints.maxWidth;
            final dialogMaxWidth = maxWidth * 0.96;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF4ECDC4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Mark Complete')),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: dialogMaxWidth),
                child: Text(
                  'Mark "${event.activity}" for ${event.petName} as completed?',
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4ECDC4),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Complete'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;

      // Mark as completed in Firestore instead of deleting
      runAsync(() async {
        final scheduleId = event.scheduleId;
        if (scheduleId != null && scheduleId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('schedules')
              .doc(scheduleId)
              .update({'isCompleted': true});

          // Cancel the notification for this schedule
          await NotificationService().cancelReminder(scheduleId);
        }

        await Future.delayed(const Duration(milliseconds: 120));
        if (context.mounted) {
          // Return boolean result to align with caller expectations
          Navigator.pop(context, true);
        }
      });
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
