import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../View/home_view.dart';
import '../View/register_view.dart';
import '../View/admin_login_view.dart';
import '../View/forgot_password_view.dart';
import '../Services/activity_service.dart';
import 'base_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  // Renamed controller for clarity, but kept logic compatible
  final TextEditingController emailOrUsernameController =
      TextEditingController();
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

  // --- Email/Username + Password Login ---
  Future<void> onLoginPressed(BuildContext context) async {
    setMessage(null, null);

    final input = emailOrUsernameController.text.trim();
    final password = passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      setMessage(
        'Please enter username/email and password.',
        MessageType.error,
      );
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
      String finalEmail = input;

      // 1. Check if input is NOT an email (assume it's a username)
      if (!input.contains('@')) {
        final emailFromUsername = await _getEmailFromUsername(input);
        if (emailFromUsername == null) {
          _isLoading = false;
          setMessage('Username not found.', MessageType.error);
          return;
        }
        finalEmail = emailFromUsername;
      }

      // 2. Attempt Authentication with Email
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: finalEmail, password: password);

      // 3. Check Suspension Status
      bool isAllowed = await _checkUserStatus(userCredential.user!);

      _isLoading = false;
      notifyListeners();

      if (isAllowed && context.mounted) {
        // --- LOG ACTIVITY ---
        final user = userCredential.user!;
        await ActivityService.log(
          action: 'User Login',
          description: '${user.email ?? "User"} logged in via Email/Username',
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
        errorMsg = 'No user found for that account.';
      else if (e.code == 'wrong-password')
        errorMsg = 'Wrong password provided.';
      else if (e.code == 'invalid-credential')
        errorMsg = 'Invalid credentials.';
      else if (e.code == 'user-disabled')
        errorMsg = 'This user account has been disabled.';
      else if (e.code == 'too-many-requests')
        errorMsg = 'Too many attempts. Try again later.';

      setMessage(errorMsg, MessageType.error);
    } catch (e) {
      _isLoading = false;
      setMessage('An error occurred: ${e.toString()}', MessageType.error);
    }
  }

  // --- Helper: Get Email from Username ---
  Future<String?> _getEmailFromUsername(String username) async {
    try {
      // Assuming you have a 'userName' field in your 'user' collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('userName', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['userEmail'] as String?;
      }
    } catch (e) {
      print('Error finding username: $e');
    }
    return null;
  }

  // --- SOCIAL SIGN-IN LOGIC (Unchanged logic, just keeping structure) ---
  Future<void> onProviderPressed(
    BuildContext context,
    String providerName,
  ) async {
    if (!_isTermsAccepted) {
      setMessage('Please accept the Terms & Conditions.', MessageType.error);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential? userCredential;

      if (providerName == 'Google') {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          _isLoading = false;
          notifyListeners();
          return;
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
          return;
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

      if (userCredential != null && userCredential.user != null) {
        await _saveSocialUserToFirestore(
          userCredential.user!,
          providerName.toLowerCase(),
        );

        bool isAllowed = await _checkUserStatus(userCredential.user!);

        _isLoading = false;
        notifyListeners();

        if (isAllowed && context.mounted) {
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

  // --- Helper: Check User Status ---
  Future<bool> _checkUserStatus(User user) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final data = result.docs.first.data() as Map<String, dynamic>;
        final status = data['accountStatus'] as String? ?? 'Active';

        if (status == 'Suspended') {
          await FirebaseAuth.instance.signOut();
          final GoogleSignIn googleSignIn = GoogleSignIn();
          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.signOut();
          }

          setMessage(
            'Your account has been suspended. Please contact support.',
            MessageType.error,
          );
          return false;
        }
      }
      return true;
    } catch (e) {
      print("Error checking status: $e");
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

    final QuerySnapshot result = await firestore
        .collection('user')
        .where('providerId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      return;
    }

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
        'authProvider': providerName,
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
    emailOrUsernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
