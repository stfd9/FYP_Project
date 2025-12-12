import 'package:flutter/material.dart';
import 'base_view_model.dart';

class ManageAccountsViewModel extends BaseViewModel {
  // Dummy Data for users
  final List<UserAccount> _users = [
    UserAccount(
      id: '1',
      name: 'Ahmad Faiz bin Abdullah',
      email: 'ahmad.faiz@gmail.com',
      joinDate: '2024-12-01',
    ),
    UserAccount(
      id: '2',
      name: 'Nurul Aisyah binti Razak',
      email: 'nurul.aisyah@yahoo.com',
      joinDate: '2025-01-15',
    ),
    UserAccount(
      id: '3',
      name: 'Tan Wei Ming',
      email: 'weiming.tan@hotmail.com',
      joinDate: '2025-01-20',
    ),
  ];

  List<UserAccount> get users => List.unmodifiable(_users);

  // Show confirmation dialog before deleting
  void confirmDeleteUser(BuildContext context, UserAccount user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to permanently delete ${user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              _deleteUser(context, user);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Actual delete logic
  void _deleteUser(BuildContext context, UserAccount user) {
    _users.remove(user);
    notifyListeners();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${user.name} has been removed.')));
  }
}

class UserAccount {
  final String id;
  final String name;
  final String email;
  final String joinDate;
  final String phone;
  final String status;
  final int petsCount;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
    this.phone = '',
    this.status = 'Active',
    this.petsCount = 0,
  });
}
