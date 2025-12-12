import 'package:flutter/gestures.dart'; // REQUIRED for TapGestureRecognizer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Logo Section ---
                    SizedBox(
                      height: 85,
                      width: 300,
                      child: Image.asset(
                        'images/assets/full_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets,
                            size: 60,
                            color: colorScheme.primary,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- Login Form Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log in',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back to PetCare',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email Input
                          TextField(
                            controller: viewModel.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(context, 'Email'),
                          ),
                          const SizedBox(height: 16),

                          // Password Input
                          TextField(
                            controller: viewModel.passwordController,
                            obscureText: viewModel.obscurePassword,
                            decoration: _inputDecoration(
                              context,
                              'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: viewModel.onTogglePasswordPressed,
                              ),
                            ),
                          ),

                          // --- UPDATED: Terms & Conditions Checkbox ---
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: viewModel.isTermsAccepted,
                                  onChanged: viewModel.toggleTerms,
                                  activeColor: colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontFamily: theme
                                          .textTheme
                                          .bodyMedium
                                          ?.fontFamily, // Ensure font matches app
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        // Open Pop-up when clicked
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => viewModel
                                              .openTermsAndConditions(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          if (viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                // Dim button if terms not accepted
                                disabledBackgroundColor: colorScheme.onSurface
                                    .withOpacity(0.12),
                                disabledForegroundColor: colorScheme.onSurface
                                    .withOpacity(0.38),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed:
                                  (viewModel.isLoading ||
                                      !viewModel.isTermsAccepted)
                                  ? null
                                  : () => viewModel.onLoginPressed(context),
                              child: viewModel.isLoading
                                  ? SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: colorScheme.onPrimary,
                                      ),
                                    )
                                  : const Text(
                                      'Log in',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Forgot Password
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () =>
                                  viewModel.onForgotPasswordPressed(context),
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  'or continue with',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Social Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialCircleButton(
                                tooltip: 'Continue with Facebook',
                                icon: Icons.facebook,
                                iconColor: const Color(0xFF1877F2),
                                onTap: () => viewModel.onProviderPressed(
                                  context,
                                  'Facebook',
                                ),
                              ),
                              const SizedBox(width: 20),
                              _SocialCircleButton(
                                tooltip: 'Continue with Google',
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'images/assets/google_logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.red,
                                            ),
                                  ),
                                ),
                                onTap: () => viewModel.onProviderPressed(
                                  context,
                                  'Google',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    viewModel.onRegisterPressed(context),
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Admin Button
            Positioned(
              top: 10,
              right: 16,
              child: IconButton(
                onPressed: () => viewModel.onAdminLoginPressed(context),
                tooltip: 'Admin Login',
                icon: Icon(
                  Icons.manage_accounts_outlined,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label, {
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: theme.scaffoldBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final Widget? child;
  final IconData? icon;
  final Color? iconColor;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialCircleButton({
    this.child,
    this.icon,
    this.iconColor,
    required this.tooltip,
    required this.onTap,
  }) : assert(child != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child:
                child ?? Icon(icon, color: iconColor ?? Colors.black, size: 26),
          ),
        ),
      ),
    );
  }
}
