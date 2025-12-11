import 'package:flutter/material.dart';
import 'base_view_model.dart';

class AdminFeedbackViewModel extends BaseViewModel {
  final List<FeedbackItem> _feedbackList = [
    FeedbackItem(
      id: '101',
      title: 'App crashes on scan',
      message:
          'Whenever I try to scan my cat, the app closes unexpectedly. Please fix this soon.',
      sender: 'john@example.com',
      date: '2025-01-25',
      category: 'Bug Report',
    ),
    FeedbackItem(
      id: '102',
      title: 'Suggestion for Calendar',
      message: 'It would be great if we could sync this with Google Calendar.',
      sender: 'jane@test.com',
      date: '2025-01-24',
      category: 'Feature Request',
    ),
  ];

  List<FeedbackItem> get feedbackList => List.unmodifiable(_feedbackList);

  void openFeedbackDetail(BuildContext context, FeedbackItem item) {
    Navigator.pushNamed(context, '/admin_feedback_detail', arguments: item);
  }
}

class FeedbackItem {
  final String id;
  final String title;
  final String message;
  final String sender;
  final String date;
  final String category;

  FeedbackItem({
    required this.id,
    required this.title,
    required this.message,
    required this.sender,
    required this.date,
    required this.category,
  });
}
