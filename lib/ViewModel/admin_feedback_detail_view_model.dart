import 'package:flutter/material.dart';
import 'base_view_model.dart';
import 'admin_feedback_view_model.dart';

class AdminFeedbackDetailViewModel extends BaseViewModel {
  FeedbackItem? _feedback;
  bool _isMarkedReviewed = false;
  final List<Map<String, String>> _replies = [];
  bool _showReplyField = false;
  final TextEditingController replyController = TextEditingController();

  FeedbackItem? get feedback => _feedback;
  bool get isMarkedReviewed => _isMarkedReviewed;
  List<Map<String, String>> get replies => List.unmodifiable(_replies);
  bool get showReplyField => _showReplyField;

  void initialize(FeedbackItem feedback) {
    _feedback = feedback;
    _isMarkedReviewed = false;
    _showReplyField = false;
    notifyListeners();
  }

  void toggleReplyField() {
    _showReplyField = !_showReplyField;
    notifyListeners();
  }

  void sendReply(BuildContext context) {
    if (replyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a reply message'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateString = '${now.day}/${now.month}/${now.year}';

    _replies.add({
      'message': replyController.text.trim(),
      'time': timeString,
      'date': dateString,
    });
    _showReplyField = false;
    replyController.clear();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Reply sent successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void markAsReviewed(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Mark as Reviewed'),
          ],
        ),
        content: const Text(
          'Are you sure you want to mark this feedback as reviewed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _isMarkedReviewed = true;
              notifyListeners();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Marked as reviewed'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void deleteFeedback(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Feedback'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this feedback? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feedback deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void archiveFeedback(BuildContext context) {
    if (_feedback == null) return;

    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback archived successfully')),
    );
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }
}
