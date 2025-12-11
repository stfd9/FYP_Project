import 'package:flutter/material.dart';
import 'View/home_view.dart';
import 'View/login_view.dart';
import 'View/register_view.dart';
import 'theme/app_theme.dart';
import 'View/admin_login_view.dart';
import 'View/admin_dashboard_view.dart';
import 'View/calendar_view.dart';
import 'View/notification_detail_view.dart';
import 'View/manage_accounts_view.dart';
import 'View/admin_feedback_list_view.dart';
import 'View/admin_feedback_detail_view.dart';
import 'View/analysis_record_list_view.dart';
import 'View/analysis_record_detail_view.dart';
import 'View/manage_faq_view.dart';
import 'View/admin_account_detail_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare Auth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/admin_login': (context) => const AdminLoginView(),
        '/admin_dashboard': (context) => const AdminDashboardView(),
        '/calendar': (context) => const CalendarView(),
        '/notification_detail': (context) => const NotificationDetailView(),
        '/manage_accounts': (context) => const ManageAccountsView(),
        '/admin/account-detail': (context) => const AdminAccountDetailView(),
        '/admin_feedback_list': (context) => const AdminFeedbackListView(),
        '/admin_feedback_detail': (context) => const AdminFeedbackDetailView(),
        '/analysis_records': (context) => const AnalysisRecordListView(),
        '/analysis_record_detail': (context) =>
            const AnalysisRecordDetailView(),
        '/manage_faq': (context) => const ManageFAQView(),
      },
    );
  }
}
