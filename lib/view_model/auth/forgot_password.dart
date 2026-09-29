import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel {
  final emailController = TextEditingController();

  String? validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) return 'Email required';

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(email)) return 'Invalid email address';

    return null;
  }

  Future<String?> submit() async {
    final error = validateEmail();
    if (error != null) return error;

    try {
      debugPrint('Sending reset email to: ${emailController.text.trim()}');
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      debugPrint('Reset email sent successfully');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with that email';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return e.message ?? 'Something went wrong. Please try again.';
      }
    }
  }

  void dispose() {
    emailController.dispose();
  }
}
