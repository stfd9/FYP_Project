import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/admin_dashboard_view_model.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminDashboardViewModel(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminDashboardViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Reverted to standard background color
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // --- CENTER THE TITLE ---
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Admin Dashboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Welcome back, Admin',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.logout, color: colorScheme.error, size: 20),
              onPressed: () => viewModel.onLogoutPressed(context),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      // Removed the Container with Gradient
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _DashboardStatsRow(),

            const SizedBox(height: 32),

            Text(
              'Management',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _AdminActionCard(
                  title: 'Accounts',
                  subtitle: 'Manage Users',
                  icon: Icons.people_alt_outlined,
                  iconColor: colorScheme.primary,
                  backgroundColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.1,
                  ),
                  onTap: () => viewModel.onManageAccountsPressed(context),
                ),
                _AdminActionCard(
                  title: 'Records',
                  subtitle: 'AI Analysis Logs',
                  icon: Icons.analytics_outlined,
                  iconColor: colorScheme.tertiary,
                  backgroundColor: colorScheme.tertiaryContainer.withValues(
                    alpha: 0.1,
                  ),
                  onTap: () => viewModel.onAnalysisRecordsPressed(context),
                ),
                _AdminActionCard(
                  title: 'Feedback',
                  subtitle: 'User Reports',
                  icon: Icons.rate_review_outlined,
                  iconColor: const Color(0xFF2F6FD6),
                  backgroundColor: colorScheme.secondaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  onTap: () => viewModel.onUserFeedbackPressed(context),
                ),
                _AdminActionCard(
                  title: 'FAQ',
                  subtitle: 'Help Center',
                  icon: Icons.quiz_outlined,
                  iconColor: colorScheme.onSurface,
                  backgroundColor: Colors.grey.shade200,
                  onTap: () => viewModel.onManageFaqPressed(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              'System Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            const _RecentActivityList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: Stats Row ---
class _DashboardStatsRow extends StatelessWidget {
  const _DashboardStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Users',
            value: '1.2k',
            icon: Icons.group,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Scans',
            value: '856',
            icon: Icons.center_focus_strong,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Issues',
            value: '5',
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET: Recent Activity ---
class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ActivityItem(
            text: 'New user "Alex" registered',
            time: '2m ago',
            color: Theme.of(context).colorScheme.primary,
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _ActivityItem(
            text: 'Skin analysis #402 flagged',
            time: '1h ago',
            color: Theme.of(context).colorScheme.tertiary,
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          const _ActivityItem(
            text: 'Feedback received: "Crash bug"',
            time: '3h ago',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String text;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.text,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const Spacer(),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
