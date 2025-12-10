import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/privacy_security_view_model.dart';

class PrivacySecurityView extends StatelessWidget {
  const PrivacySecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrivacySecurityViewModel(),
      child: const _PrivacySecurityBody(),
    );
  }
}

class _PrivacySecurityBody extends StatelessWidget {
  const _PrivacySecurityBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PrivacySecurityViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const Text(
              'Security',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Change password'),
              subtitle: const Text('Update your current password'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => viewModel.changePassword(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.devices_other_outlined),
              title: const Text('Login sessions'),
              subtitle: const Text('Manage devices that are signed in'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => viewModel.manageSessions(context),
            ),
            const SizedBox(height: 20),
            const Text(
              'Data & privacy',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy policy'),
              subtitle: const Text('How we handle your data'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => viewModel.openPrivacyPolicy(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete account'),
              subtitle: const Text('Permanently remove your data'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => viewModel.deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
