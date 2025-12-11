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
      // Uses AppColors.pageBackground from your theme
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // Using Midnight Blue for high contrast on light background
            color: colorScheme.onSurface,
          ),
        ),
        // Theme default is transparent/light, so we don't need to force colors here
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: colorScheme.error,
            ), // Red for logout action
            onPressed: () => viewModel.onLogoutPressed(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary, // Cobalt Blue
              ),
            ),
            const SizedBox(height: 16),

            // Grid Layout
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _AdminActionCard(
                  title: 'Manage Accounts',
                  subtitle: 'View and edit users',
                  icon: Icons.people_alt_outlined,
                  // Use Primary (Cobalt)
                  iconColor: colorScheme.primary,
                  backgroundColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.1,
                  ),
                  onTap: () => viewModel.navigateToManageAccounts(context),
                ),
                _AdminActionCard(
                  title: 'Analysis Records',
                  subtitle: 'Review scan history',
                  icon: Icons.analytics_outlined,
                  // Use Tertiary (Deep Sea)
                  iconColor: colorScheme.tertiary,
                  backgroundColor: colorScheme.tertiaryContainer.withValues(
                    alpha: 0.1,
                  ),
                  onTap: () => viewModel.navigateToAnalysisRecords(context),
                ),
                _AdminActionCard(
                  title: 'User Feedback',
                  subtitle: 'Read customer feedback',
                  icon: Icons.rate_review_outlined,
                  // Use Secondary (Aqua) - Darkened slightly for text visibility if needed
                  iconColor: const Color(
                    0xFF2F6FD6,
                  ), // Using Cobalt for consistency or Scheme Secondary
                  backgroundColor: colorScheme.secondaryContainer.withValues(
                    alpha: 0.5,
                  ),
                  onTap: () => viewModel.navigateToUserFeedback(context),
                ),
                _AdminActionCard(
                  title: 'Manage FAQ',
                  subtitle: 'Edit help content',
                  icon: Icons.quiz_outlined,
                  // Use Midnight (OnSurface)
                  iconColor: colorScheme.onSurface,
                  backgroundColor: colorScheme.surfaceVariant,
                  onTap: () => viewModel.navigateToManageFAQ(context),
                ),
              ],
            ),
          ],
        ),
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
        color: theme.cardTheme.color, // Uses Surface (White)
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Circle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        backgroundColor, // Soft background based on brand color
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const Spacer(),
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface, // Midnight Blue
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
