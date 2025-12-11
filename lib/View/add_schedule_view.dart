import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/add_schedule_view_model.dart';

class AddScheduleView extends StatelessWidget {
  const AddScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddScheduleViewModel(),
      child: const _AddScheduleForm(),
    );
  }
}

class _AddScheduleForm extends StatelessWidget {
  const _AddScheduleForm();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddScheduleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add schedule'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Date & time',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      viewModel.scheduledLabel,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  trailing: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: const Text('Select'),
                    onPressed: () => viewModel.pickDateTime(context),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: viewModel.petNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pet name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter pet name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: viewModel.activityController,
                  decoration: const InputDecoration(
                    labelText: 'Activity',
                    hintText: 'e.g. Vaccination, Grooming',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the activity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: viewModel.locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => viewModel.saveSchedule(context),
                    child: const Text(
                      'Save schedule',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
