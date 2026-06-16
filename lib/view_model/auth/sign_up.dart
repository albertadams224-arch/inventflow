import 'package:flutter/material.dart';

class SignUpViewModel {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validateName() {
    final name = nameController.text.trim();
    if (name.isEmpty) return 'Name required';
    if (name.length < 2) return 'Name too short';
    if (name.contains(RegExp(r'[0-9]'))) return 'Name cannot contain numbers';
    if (name.contains(RegExp(r'[!@#\$%^&*]'))) {
      return 'Name cannot contain special characters';
    }
    return null;
  }

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

  bool isValidate() {
    return validateName() == null &&
        validateEmail() == null &&
        validatePassword() == null;
  }

  void submit() {
    if (!isValidate()) return;
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    print(name);
    print(email);
    print(password);
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
