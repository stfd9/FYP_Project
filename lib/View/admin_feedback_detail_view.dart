import 'package:flutter/material.dart';
import '../ViewModel/admin_feedback_view_model.dart'; // Import for FeedbackItem class

class AdminFeedbackDetailView extends StatelessWidget {
  const AdminFeedbackDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Capture arguments passed from List View
    final item = ModalRoute.of(context)!.settings.arguments as FeedbackItem;

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(item.category),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade900),
                ),
                Text(item.date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sent by: ${item.sender}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Divider(height: 32),
            Text(
              item.message,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
