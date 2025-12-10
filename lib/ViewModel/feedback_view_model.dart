import 'package:flutter/material.dart';

import 'base_view_model.dart';

class FeedbackViewModel extends BaseViewModel {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final List<String> categories = const [
    'General feedback',
    'Bug report',
    'Feature request',
  ];

  String _selectedCategory = 'General feedback';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String value) {
    if (_selectedCategory == value) return;
    _selectedCategory = value;
    notifyListeners();
  }

  void submitFeedback(BuildContext context) {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in subject and message.')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feedback sent. Thank you!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
