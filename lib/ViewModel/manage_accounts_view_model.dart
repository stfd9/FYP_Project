import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_view_model.dart';

class ManageAccountsViewModel extends BaseViewModel {
  // Master list (All data from DB)
  List<Map<String, dynamic>> _allUsers = [];

  // Filtered list (What is shown in the list below)
  List<Map<String, dynamic>> _filteredUsers = [];

  bool _isLoading = true;

  // --- Getters for UI ---
  List<Map<String, dynamic>> get users => _filteredUsers;
  bool get isLoading => _isLoading;

  // Stats Getters
  int get totalUsersCount => _allUsers.length;

  int get activeUsersCount {
    return _allUsers.where((user) {
      final status = (user['accountStatus'] ?? 'Active').toString();
      return status == 'Active';
    }).length;
  }

  ManageAccountsViewModel() {
    fetchUsers();
  }

  // --- Fetch Users ---
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .orderBy('dateCreated', descending: true)
          .get();

      // Store raw data
      _allUsers = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Save Doc ID
        return data;
      }).toList();

      // Initialize filtered list with everything
      _filteredUsers = List.from(_allUsers);
    } catch (e) {
      print("Error fetching users: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- Search Logic ---
  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredUsers = _allUsers.where((user) {
        final name = (user['userName'] ?? '').toString().toLowerCase();
        final email = (user['userEmail'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  // --- Delete Logic ---
  void confirmDeleteUser(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete ${user['userName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteUser(context, user);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(
    BuildContext context,
    Map<String, dynamic> user,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user['id'])
          .delete();

      _allUsers.removeWhere((u) => u['id'] == user['id']);
      _filteredUsers.removeWhere((u) => u['id'] == user['id']);
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      }
    } catch (e) {
      print("Error deleting: $e");
    }
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  // --- CRITICAL UPDATE: Refresh on Return ---
  Future<void> onUserCardTapped(
    BuildContext context,
    Map<String, dynamic> user,
  ) async {
    // 1. Wait for the detail page to be popped (closed)
    await Navigator.pushNamed(
      context,
      '/admin/account-detail',
      arguments: user,
    );

    // 2. Fetch fresh data from Firebase immediately
    // This ensures the list updates if the status changed to 'Suspended'
    fetchUsers();
  }
}
