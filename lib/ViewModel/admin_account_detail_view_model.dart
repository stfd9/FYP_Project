import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_view_model.dart';

class AdminAccountDetailViewModel extends BaseViewModel {
  Map<String, dynamic>? _user;
  bool _isAccountLocked = false;
  String _accountStatus = 'Active';

  Map<String, dynamic>? get user => _user;
  bool get isAccountLocked => _isAccountLocked;
  String get accountStatus => _accountStatus;

  // --- Initialize ---
  void initialize(Map<String, dynamic> userData) {
    _user = userData;
    // Check the status from the map passed in
    _accountStatus = userData['accountStatus'] ?? 'Active';
    // If status is 'Suspended', set locked to true
    _isAccountLocked = _accountStatus == 'Suspended';
    notifyListeners();
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  // --- 1. SUSPEND / UNLOCK LOGIC ---
  Future<void> toggleAccountLock(BuildContext context) async {
    if (_user == null) return;

    // Determine new status
    final newStatus = _isAccountLocked ? 'Active' : 'Suspended';
    final action = _isAccountLocked ? 'Unlocking' : 'Suspending';

    // Optimistic Update: Update UI immediately so it feels fast
    _isAccountLocked = !_isAccountLocked;
    _accountStatus = newStatus;
    notifyListeners();

    try {
      // Update Firebase
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_user!['id']) // Uses the Doc ID we saved earlier
          .update({'accountStatus': newStatus});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account $newStatus successfully'),
            backgroundColor: _isAccountLocked ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // If error, revert the UI changes
      _isAccountLocked = !_isAccountLocked;
      _accountStatus = _isAccountLocked ? 'Suspended' : 'Active';
      notifyListeners();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error $action account: $e')),
        );
      }
    }
  }

  // --- 2. DELETE ACCOUNT LOGIC ---
  Future<void> deleteAccount(BuildContext context) async {
    if (_user == null) return;

    try {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_user!['id'])
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        // Go back to the Manage Accounts list
        Navigator.pop(context); // Close dialog
        Navigator.pop(context); // Close page
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    }
  }

  // --- 3. DIALOGS ---
  
  void showLockConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              _isAccountLocked ? Icons.lock_open : Icons.block,
              color: _isAccountLocked ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(_isAccountLocked ? 'Unlock Account' : 'Suspend Account'),
          ],
        ),
        content: Text(
          _isAccountLocked
              ? 'Are you sure you want to unlock this account? They will be able to login again.'
              : 'Are you sure you want to suspend this account? They will NOT be able to login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              toggleAccountLock(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAccountLocked ? Colors.green : Colors.orange,
            ),
            child: Text(_isAccountLocked ? 'Unlock' : 'Suspend'),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); 
              deleteAccount(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}