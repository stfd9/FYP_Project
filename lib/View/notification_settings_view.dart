import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/notification_settings_view_model.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationSettingsViewModel(),
      child: const _NotificationSettingsBody(),
    );
  }
}

class _NotificationSettingsBody extends StatelessWidget {
  const _NotificationSettingsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationSettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              'Reminders',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Medication reminders'),
              subtitle: const Text(
                'Notify you when it’s time for your pet’s medicine',
              ),
              value: viewModel.medicationReminders,
              onChanged: viewModel.toggleMedication,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Vaccination reminders'),
              subtitle: const Text(
                'Upcoming vaccination and booster reminders',
              ),
              value: viewModel.vaccinationReminders,
              onChanged: viewModel.toggleVaccination,
            ),
            const SizedBox(height: 16),
            const Text(
              'Other',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('General updates'),
              subtitle: const Text('News and tips about pet health'),
              value: viewModel.generalUpdates,
              onChanged: viewModel.toggleGeneralUpdates,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => viewModel.onShowInfoPressed(context),
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text('Learn more about notifications'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
