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

    final bottomPadding = MediaQuery.of(context).padding.bottom + 24;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // App Theme Background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Admin Panel',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            Text(
              'System Overview',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          // Logout Button
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
              icon: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 20,
              ),
              onPressed: () => viewModel.onLogoutPressed(context),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Welcome Banner ---
            _AdminWelcomeBanner(colorScheme: colorScheme),

            const SizedBox(height: 32),

            // --- 2. Key Statistics ---
            Text(
              'Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            const _DashboardStatsRow(),

            const SizedBox(height: 32),

            // --- 3. Management Grid ---
            Text(
              'Manage',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
                fontSize: 18,
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
                  subtitle: 'Users & Admins',
                  icon: Icons.people_alt_rounded,
                  iconColor: Colors.white,
                  iconBgColor: colorScheme.primary, // Cobalt
                  onTap: () => viewModel.onManageAccountsPressed(context),
                ),
                _AdminActionCard(
                  title: 'Records',
                  subtitle: 'AI Analysis Logs',
                  icon: Icons.analytics_rounded,
                  iconColor: Colors.white,
                  iconBgColor: const Color(0xFF29B6F6), // Light Blue
                  onTap: () => viewModel.onAnalysisRecordsPressed(context),
                ),
                _AdminActionCard(
                  title: 'Feedback',
                  subtitle: 'User Reports',
                  icon: Icons.reviews_rounded,
                  iconColor: Colors.white,
                  iconBgColor: const Color(0xFFFFB74D), // Orange
                  onTap: () => viewModel.onUserFeedbackPressed(context),
                ),
                _AdminActionCard(
                  title: 'FAQ',
                  subtitle: 'Help Content',
                  icon: Icons.live_help_rounded,
                  iconColor: Colors.white,
                  iconBgColor: const Color(0xFF66BB6A), // Green
                  onTap: () => viewModel.onManageFaqPressed(context),
                ),
                _AdminActionCard(
                  title: 'Community Tips',
                  subtitle: 'Manage Tips',
                  icon: Icons.local_library_rounded,
                  iconColor: Colors.white,
                  iconBgColor: const Color(0xFF9C27B0), // Purple
                  onTap: () => viewModel.onManageCommunityTipsPressed(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- 4. System Activity ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Log',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                    fontSize: 18,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _RecentActivityList(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: Welcome Banner ---
class _AdminWelcomeBanner extends StatelessWidget {
  final ColorScheme colorScheme;

  const _AdminWelcomeBanner({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Good Morning, Admin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'System status is normal. There are 5 pending user reports to review.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
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
      children: const [
        Expanded(
          child: _StatCard(
            label: 'Users',
            value: '1.2k',
            icon: Icons.group_rounded,
            color: Color(0xFF6C63FF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Scans',
            value: '856',
            icon: Icons.center_focus_strong_rounded,
            color: Color(0xFF29B6F6),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Issues',
            value: '5',
            icon: Icons.warning_rounded,
            color: Color(0xFFFF7043),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
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

// --- WIDGET: Admin Action Card ---
class _AdminActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: iconBgColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET: Recent Activity List ---
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
            color: const Color(0xFF6C63FF),
            isFirst: true,
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _ActivityItem(
            text: 'Skin analysis #402 flagged',
            time: '1h ago',
            color: const Color(0xFF29B6F6),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          const _ActivityItem(
            text: 'Feedback received: "Crash bug"',
            time: '3h ago',
            color: Color(0xFFFF7043),
            isLast: true,
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
  final bool isFirst;
  final bool isLast;

  const _ActivityItem({
    required this.text,
    required this.time,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isFirst ? 20 : 16, 20, isLast ? 20 : 16),
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
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
