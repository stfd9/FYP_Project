import 'package:flutter/material.dart';
import 'base_view_model.dart';

class AdminDashboardViewModel extends BaseViewModel {
  // -- Navigation Methods --

  void navigateToManageAccounts(BuildContext context) {
    // Navigate to User List Page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manage Accounts page coming soon.')),
    );
  }

  void navigateToAnalysisRecords(BuildContext context) {
    // Navigate to Analysis History
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analysis Records page coming soon.')),
    );
  }

  void navigateToUserFeedback(BuildContext context) {
    // Navigate to Feedback Review
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User Feedback page coming soon.')),
    );
  }

  void navigateToManageFAQ(BuildContext context) {
    // Navigate to FAQ Editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ Management page coming soon.')),
    );
  }

  void logout(BuildContext context) {
    // Navigate back to login and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
