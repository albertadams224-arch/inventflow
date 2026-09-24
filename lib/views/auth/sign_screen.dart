import 'package:flutter/material.dart';
import 'package:inventflow/view_model/auth/sign_up.dart';
import 'package:inventflow/views/auth/login_screen.dart';
import 'package:inventflow/views/tabs.dart';
import 'package:inventflow/widgets/input_fields.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _vm = SignUpViewModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final error = await _vm.submit();
    if (mounted) setState(() => isLoading = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (ctx) => TabScreen()));
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 28, fontWeight: FontWeight.bold);
    var kFieldLabelStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: colorScheme.surface, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 42,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'InventFlow',
                    style: kLargeTextStyle.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Create account', style: kLargeTextStyle),
                const SizedBox(height: 4),
                Text(
                  'Sign up to start managing your inventory',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),

                Text('Name', style: kFieldLabelStyle),
                const SizedBox(height: 8),
                InputFields(
                  hintText: 'Enter name',
                  controller: _vm.nameController,
                  validator: (value) => _vm.validateName(),
                ),
                const SizedBox(height: 20),

                Text('Email', style: kFieldLabelStyle),
                const SizedBox(height: 8),
                InputFields(
                  hintText: 'Email address',
                  controller: _vm.emailController,
                  validator: (value) => _vm.validateEmail(),
                ),
                const SizedBox(height: 20),

                Text('Password', style: kFieldLabelStyle),
                const SizedBox(height: 8),
                InputFields(
                  hintText: 'Password',
                  controller: _vm.passwordController,
                  validator: (value) => _vm.validatePassword(),
                ),
                const SizedBox(height: 28),

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleSubmit,
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) => Login()),
                              );
                            },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
