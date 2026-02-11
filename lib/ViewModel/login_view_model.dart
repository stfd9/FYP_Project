import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../View/home_view.dart';
import '../View/register_view.dart';
import '../View/admin_login_view.dart';
import '../View/forgot_password_view.dart';
import '../Services/activity_service.dart'; // <--- Import ActivityService
import 'base_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isTermsAccepted = false;

  String? _message;
  MessageType? _messageType;

  // Getters
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  bool get isTermsAccepted => _isTermsAccepted;
  String? get errorMessage => _message;
  String? get message => _message;
  MessageType? get messageType => _messageType;

  void setMessage(String? msg, [MessageType? type]) {
    _message = msg;
    _messageType = type;
    notifyListeners();
  }

  void clearMessage() {
    if (_message == null && _messageType == null) return;
    _message = null;
    _messageType = null;
    notifyListeners();
  }

  void onTogglePasswordPressed() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleTerms(bool? value) {
    _isTermsAccepted = value ?? false;
    notifyListeners();
  }

  // --- Email/Password Login ---
  Future<void> onLoginPressed(BuildContext context) async {
    setMessage(null, null);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setMessage('Please provide both email and password.', MessageType.error);
      return;
    }

    if (!_isTermsAccepted) {
      setMessage(
        'Please accept the Terms & Conditions to login.',
        MessageType.error,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Attempt Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      // 2. Check Suspension Status
      bool isAllowed = await _checkUserStatus(userCredential.user!);

      _isLoading = false;
      notifyListeners();

      if (isAllowed && context.mounted) {
        // --- LOG ACTIVITY ---
        final user = userCredential.user!;
        await ActivityService.log(
          action: 'User Login',
          description: '${user.email ?? "User"} logged in via Email',
          actorName: user.displayName ?? 'User',
          type: 'INFO',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      String errorMsg = 'Login failed. Please try again.';
      if (e.code == 'user-not-found')
        errorMsg = 'No user found for that email.';
      else if (e.code == 'wrong-password')
        errorMsg = 'Wrong password provided.';
      else if (e.code == 'invalid-credential')
        errorMsg = 'Invalid email or password.';
      else if (e.code == 'user-disabled')
        errorMsg = 'This user account has been disabled.';

      setMessage(errorMsg, MessageType.error);
    } catch (e) {
      _isLoading = false;
      setMessage('An error occurred: ${e.toString()}', MessageType.error);
    }
  }

  // --- SOCIAL SIGN-IN LOGIC (Google & Facebook) ---
  Future<void> onProviderPressed(
    BuildContext context,
    String providerName,
  ) async {
    // Terms Check for Social Login
    if (!_isTermsAccepted) {
      setMessage('Please accept the Terms & Conditions.', MessageType.error);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential? userCredential;

      if (providerName == 'Google') {
        // --- GOOGLE LOGIN ---
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          _isLoading = false;
          notifyListeners();
          return; // User cancelled
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      } else if (providerName == 'Facebook') {
        // --- FACEBOOK LOGIN ---
        final LoginResult result = await FacebookAuth.instance.login();

        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken.token,
          );

          userCredential = await FirebaseAuth.instance.signInWithCredential(
            credential,
          );
        } else if (result.status == LoginStatus.cancelled) {
          _isLoading = false;
          notifyListeners();
          return; // User cancelled
        } else {
          throw FirebaseAuthException(
            code: 'facebook-login-failed',
            message: result.message,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$providerName sign-in coming soon.')),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      // --- SAVE TO FIRESTORE & NAVIGATE ---
      if (userCredential != null && userCredential.user != null) {
        // 1. Create user doc if it doesn't exist
        await _saveSocialUserToFirestore(
          userCredential.user!,
          providerName.toLowerCase(),
        );

        // 2. Check Suspension Status
        bool isAllowed = await _checkUserStatus(userCredential.user!);

        _isLoading = false;
        notifyListeners();

        if (isAllowed && context.mounted) {
          // --- LOG ACTIVITY ---
          final user = userCredential.user!;
          await ActivityService.log(
            action: 'User Login',
            description:
                '${user.displayName ?? "User"} logged in via $providerName',
            actorName: user.displayName ?? 'User',
            type: 'INFO',
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      setMessage(
        e.message ?? '$providerName Sign-In failed',
        MessageType.error,
      );
    } catch (e) {
      _isLoading = false;
      setMessage('An error occurred: $e', MessageType.error);
    }
  }

  // --- Helper: Check User Status (Active vs Suspended) ---
  Future<bool> _checkUserStatus(User user) async {
    try {
      // Query by providerId because your doc ID is custom (U00001), not the Auth UID
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final data = result.docs.first.data() as Map<String, dynamic>;
        final status = data['accountStatus'] as String? ?? 'Active';

        if (status == 'Suspended') {
          // Force Sign Out
          await FirebaseAuth.instance.signOut();

          // Clear any Google/Facebook cache if needed
          final GoogleSignIn googleSignIn = GoogleSignIn();
          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.signOut();
          }

          setMessage(
            'Your account has been suspended. Please contact support.',
            MessageType.error,
          );
          return false; // Deny access
        }
      }
      return true; // Allow access
    } catch (e) {
      print("Error checking status: $e");
      // Fallback: If DB check fails, we generally allow access or block safe.
      // Blocking safe prevents suspended users from sneaking in during outages.
      setMessage('Unable to verify account status.', MessageType.error);
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }

  // --- Helper: Save Social User to Firestore ---
  Future<void> _saveSocialUserToFirestore(
    User user,
    String providerName,
  ) async {
    final firestore = FirebaseFirestore.instance;

    // Check if user already exists
    final QuerySnapshot result = await firestore
        .collection('user')
        .where('providerId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      return; // User exists, do nothing
    }

    // Generate Custom ID (U00000X)
    final counterRef = firestore.collection('counters').doc('userCounter');

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

      int currentCount = 0;
      if (counterSnapshot.exists) {
        currentCount = counterSnapshot.get('count') as int;
      }

      int newCount = currentCount + 1;
      String customUserId = 'U${newCount.toString().padLeft(6, '0')}';
      final userDocRef = firestore.collection('user').doc(customUserId);

      final userData = {
        'userName': user.displayName ?? '$providerName User',
        'userEmail': user.email ?? '',
        'password_hash': '${providerName.toUpperCase()}_AUTH',
        'authProvider': providerName, // Saves 'google' or 'facebook'
        'providerId': user.uid,
        'userRole': 'User',
        'accountStatus': 'Active',
        'dateCreated': FieldValue.serverTimestamp(),
        'dateOfBirth': null,
      };

      transaction.set(counterRef, {'count': newCount});
      transaction.set(userDocRef, userData);
    });
  }

  // --- Navigation Helpers ---
  void onRegisterPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterView()),
    );
  }

  void onAdminLoginPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginView()),
    );
  }

  void onForgotPasswordPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}