import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> sendResetLink(BuildContext context) async {
    // 1. Reset Error
    errorMessage = null;
    notifyListeners();

    // 2. Input Validation
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorMessage = 'Please enter your email address.';
      notifyListeners();
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return;
    }

    // 3. Start Loading
    isLoading = true;
    notifyListeners();

    try {
      // 4. Check if User Exists in Firestore first (Optional but good UX)
      final userQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('userEmail', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        errorMessage = 'No account found with this email.';
        isLoading = false;
        notifyListeners();
        return;
      }

      // 5. SEND FIREBASE RESET EMAIL
      // This sends a reliable email from "noreply@your-project.firebaseapp.com"
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        // 6. Success Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent! Check your email.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );

        // 7. Go back to Login Page (No need for OTP screen)
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else {
        errorMessage = e.message ?? 'An error occurred.';
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
