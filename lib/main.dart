import 'package:flutter/material.dart';
import 'View/home_view.dart';
import 'View/login_view.dart';
import 'View/register_view.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare Auth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
