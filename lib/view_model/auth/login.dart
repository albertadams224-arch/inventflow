import 'package:flutter/material.dart';

class LoginViewModel {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) return 'Email required';

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(email)) return 'Invalid email address';

    return null;
  }

  String? validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) return 'Password required';
    if (password.length < 8) return 'At least 8 characters';
    if (!password.contains(RegExp(r'[A-Z]'))) return 'Add an uppercase letter';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Add a number';
    if (!password.contains(RegExp(r'[!@#\$%^&*]'))) {
      return 'Add a special character';
    }
    return null;
  }

  bool isValid() {
    return validateEmail() == null && validatePassword() == null;
  }

  void submit() {
    if (!isValid()) return;
    String email = emailController.text;
    String password = passwordController.text;
    print(email);
    print(password);
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
