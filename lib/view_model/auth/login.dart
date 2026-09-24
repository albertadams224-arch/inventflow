import 'package:firebase_auth/firebase_auth.dart';
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

  Future<String?> submit() async {
    if (!isValid()) return 'Please fix the errors above';

    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-credential':
          return 'No account found with that email/password';
        case 'wrong-password':
          return 'Incorrect password';
        case 'too-many-requests':
          return 'Too many attempts. Try again later';
        default:
          return e.message ?? 'Login failed. Please try again.';
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
