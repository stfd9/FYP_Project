import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/manage_accounts_view_model.dart';

class ManageAccountsView extends StatelessWidget {
  const ManageAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageAccountsViewModel(),
      child: const _ManageAccountsBody(),
    );
  }
}

class _ManageAccountsBody extends StatelessWidget {
  const _ManageAccountsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManageAccountsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Manage Accounts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: viewModel.users.isEmpty
          ? Center(
              child: Text('No users found.', style: theme.textTheme.bodyLarge),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = viewModel.users[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          viewModel.confirmDeleteUser(context, user),
                      tooltip: 'Remove User',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
