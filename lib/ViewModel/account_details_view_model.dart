import 'package:flutter/material.dart';

import 'base_view_model.dart';

class AccountDetailsViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController(
    text: 'Jimmy',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'jimmy@email.com',
  );

  void onSaveChangesPressed(BuildContext context) {
    saveChanges(context);
  }

  void saveChanges(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Changes saved.')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
