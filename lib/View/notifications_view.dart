import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/notifications_view_model.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsViewModel(),
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<NotificationsViewModel>();

    final todayNotifications = viewModel.todayNotifications;
    final earlierNotifications = viewModel.earlierNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // App Theme Background
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D3142),
        actions: [
          // --- CHANGED TO ICON BUTTON ---
          if (viewModel.hasUnread)
            IconButton(
              icon: Icon(
                Icons.done_all_rounded, // Icon representing "Mark All As Read"
                color: colorScheme.primary,
                size: 24,
              ),
              onPressed: viewModel.markAllAsRead,
              tooltip: 'Mark All As Read',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todayNotifications.isEmpty && earlierNotifications.isEmpty)
                _EmptyState(textTheme: textTheme, colorScheme: colorScheme)
              else ...[
                // --- Today's Notifications ---
                if (todayNotifications.isNotEmpty) ...[
                  Text(
                    'Today',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...todayNotifications.map(
                    (item) => _NotificationTileCard(
                      item: item,
                      onTap: () =>
                          viewModel.openNotificationDetail(context, item),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- Earlier Notifications ---
                if (earlierNotifications.isNotEmpty) ...[
                  Text(
                    'Earlier',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...earlierNotifications.map(
                    (item) => _NotificationTileCard(
                      item: item,
                      onTap: () =>
                          viewModel.openNotificationDetail(context, item),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- Notification Card Widget (Used in the list) ---
class _NotificationTileCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationTileCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Highlight unread items with a slight border and heavier shadow
        border: Border.all(
          color: item.isUnread
              ? colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: item.isUnread ? 0.05 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            // Icon Background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondaryContainer, // Arctic blue background
              ),
              child: Icon(
                Icons.notifications_rounded,
                color: colorScheme.primary, // Cobalt icon color
                size: 24,
              ),
            ),
            // Unread Dot
            if (item.isUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.error, // Red dot for unread status
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          item.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: item.isUnread ? colorScheme.onSurface : Colors.grey.shade700,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              item.timeLabel,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }
}

// --- Empty State Widget ---
class _EmptyState extends StatelessWidget {
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _EmptyState({required this.textTheme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondaryContainer,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                color: colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'All Caught Up!',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No new reminders or updates about your pets.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
