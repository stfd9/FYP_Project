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
      backgroundColor: const Color(0xFFF8F9FD), // Very light cool grey
      // --- Removed AppBar ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Added top spacing
              // --- Profile Header (Clean Style) ---
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Avatar Container
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
                              color: colorScheme.primary, // Cobalt Accent
                            ),
                          ),
                        ),
                        // Edit Button (Floating)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () =>
                                viewModel.onEditProfilePressed(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary, // Aqua Accent
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.secondary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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

              // --- Menu Sections ---
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

              const SizedBox(height: 40),

              // --- Logout Button (Minimalist) ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    backgroundColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => viewModel.onLogoutPressed(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade500,
        letterSpacing: 0.5,
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

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
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 20,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
