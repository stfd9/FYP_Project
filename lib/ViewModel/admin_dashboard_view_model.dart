import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_view_model.dart';

class AdminDashboardViewModel extends BaseViewModel {
  List<Map<String, dynamic>> _recentActivities = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get recentActivities => _recentActivities;
  bool get isLoading => _isLoading;

  AdminDashboardViewModel() {
    _fetchActivityLog();
  }

  Future<void> _fetchActivityLog() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get 3 newest users
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .orderBy('dateCreated', descending: true)
          .limit(3)
          .get();

      _recentActivities = snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['userName'] ?? 'User';

        // --- CALCULATE "TIME AGO" ---
        String timeAgo = 'Just now';
        if (data['dateCreated'] != null) {
          final timestamp = data['dateCreated'] as Timestamp;
          final createdTime = timestamp.toDate();
          final diff = DateTime.now().difference(createdTime);

          if (diff.inMinutes < 60) {
            timeAgo = '${diff.inMinutes}m ago';
          } else if (diff.inHours < 24) {
            timeAgo = '${diff.inHours}h ago';
          } else {
            timeAgo = '${diff.inDays}d ago';
          }
        }

        return {
          'text': 'New user "$name" registered',
          'time': timeAgo,
          'color': const Color(0xFF6C63FF),
        };
      }).toList();
    } catch (e) {
      print("Error fetching dashboard: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // -- Navigation Actions --
  void onManageAccountsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_accounts');
  }

  void onAnalysisRecordsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/analysis_records');
  }

  void onUserFeedbackPressed(BuildContext context) {
    Navigator.pushNamed(context, '/admin_feedback_list');
  }

  void onManageFaqPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_faq');
  }

  void onManageCommunityTipsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_community_tips');
  }

  void onLogoutPressed(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

// Simple class to hold activity data for the UI
class ActivityLogItem {
  final String text;
  final String time;
  final Color color;

  ActivityLogItem({
    required this.text,
    required this.time,
    required this.color,
  });
}
