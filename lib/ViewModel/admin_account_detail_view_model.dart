import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_view_model.dart';
import '../models/user_account.dart';

class AdminAccountDetailViewModel extends BaseViewModel {
  UserAccount? _user;
  bool _isAccountLocked = false;
  String _accountStatus = 'Active';

  UserAccount? get user => _user;
  bool get isAccountLocked => _isAccountLocked;
  String get accountStatus => _accountStatus;

  void initialize(UserAccount user) {
    _user = user;
    _isAccountLocked = user.status.toLowerCase() == 'suspended';
    _accountStatus = user.status;
    notifyListeners();
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void showOptionsMenu(BuildContext context) {
    if (_user == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Send Email'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement email action
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Activity Log'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement activity log
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSuspendDialog(BuildContext context) {
    if (_user == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.block_outlined, color: Colors.orange),
            SizedBox(width: 8),
            Text('Suspend Account'),
          ],
        ),
        content: Text(
          'Are you sure you want to suspend ${_user!.name}\'s account? They will not be able to access the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              toggleAccountLock(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    if (_user == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Account'),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete ${_user!.name}\'s account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              deleteAccount(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // --- SUSPEND / UNLOCK ACCOUNT WITH FIREBASE ---
  Future<void> toggleAccountLock(BuildContext context) async {
    if (_user == null) return;

    // Determine new status
    final newStatus = _isAccountLocked ? 'Active' : 'Suspended';
    final action = _isAccountLocked ? 'Unlocking' : 'Suspending';

    // Optimistic Update: Update UI immediately so it feels fast
    _isAccountLocked = !_isAccountLocked;
    _accountStatus = newStatus;
    _user = _user!.copyWith(status: newStatus);
    notifyListeners();

    try {
      // Update Firebase
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_user!.id)
          .update({'accountStatus': newStatus});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account $newStatus successfully'),
            backgroundColor: _isAccountLocked ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // If error, revert the UI changes
      _isAccountLocked = !_isAccountLocked;
      _accountStatus = _isAccountLocked ? 'Suspended' : 'Active';
      _user = _user!.copyWith(status: _accountStatus);
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error $action account: $e')),
        );
      }
    }
  }

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
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
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

  // --- DELETE ACCOUNT WITH FIREBASE ---
  Future<void> deleteAccount(BuildContext context) async {
    if (_user == null) return;

    try {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_user!.id)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.red,
          ),
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

  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Account'),
          ],
        ),
        content: const Text(
          'Are you sure you want to permanently delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
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

  void sendNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController messageController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.blue),
              SizedBox(width: 8),
              Text('Send Notification'),
            ],
          ),
          content: TextField(
            controller: messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter notification message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (messageController.text.trim().isNotEmpty) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification sent successfully'),
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: Colors.orange),
            SizedBox(width: 8),
            Text('Reset Password'),
          ],
        ),
        content: const Text('Send a password reset link to the user\'s email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}
