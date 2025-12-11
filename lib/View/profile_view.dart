import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- Profile Header ---
              Center(
                child: Column(
                  children: [
                    // Avatar Image (No Edit Button)
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.userName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Account Settings ---
              _SectionHeader(title: 'Account Settings'),
              const SizedBox(height: 12),
              _ProfileCard(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () => viewModel.onAccountDetailsPressed(context),
              ),
              _ProfileCard(
                icon: Icons.notifications_none,
                title: 'Notifications',
                onTap: () => viewModel.onNotificationsPressed(context),
              ),
              _ProfileCard(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () => viewModel.onPrivacySecurityPressed(context),
              ),

              const SizedBox(height: 32),

              // --- Support & Logout ---
              _SectionHeader(title: 'Support'),
              const SizedBox(height: 12),
              _ProfileCard(
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                onTap: () => viewModel.onHelpPressed(context),
              ),
              _ProfileCard(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () => viewModel.onFeedbackPressed(context),
              ),

              // --- Log Out Card (Without Arrow) ---
              _ProfileCard(
                icon: Icons.logout,
                title: 'Log Out',
                textColor: Colors.red,
                iconColor: Colors.red,
                showTrailing: false,
                onTap: () => viewModel.onLogoutPressed(context),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper: Section Title ---
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// --- Helper: Profile Menu Card ---
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showTrailing = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F6FA), // Light grey icon background
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? colorScheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor ?? colorScheme.onSurface,
          ),
        ),
        trailing: showTrailing
            ? Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400)
            : null,
      ),
    );
  }
}
