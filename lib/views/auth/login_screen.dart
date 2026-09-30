import 'package:flutter/material.dart';
import 'package:inventflow/view_model/auth/login.dart';
import 'package:inventflow/views/auth/forgot_password_screen.dart';
import 'package:inventflow/views/auth/sign_screen.dart';
import 'package:inventflow/widgets/input_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _vm = LoginViewModel();
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
                const SizedBox(height: 36),
                Text('Welcome back', style: kLargeTextStyle),
                const SizedBox(height: 4),
                Text(
                  'Log in to keep managing your inventory',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),

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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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
                          'Log in',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),
                const SizedBox(height: 20),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 58),
                    side: BorderSide(color: colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          final result = await _vm.signInWithGoogle();
                          if (mounted) setState(() => isLoading = false);
                          if (!mounted) return;

                          if (result.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.error!)),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result.isNewUser
                                    ? 'Account created with Google!'
                                    : 'Welcome back! You already have an account.',
                              ),
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );

                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                  icon: const Icon(Icons.g_mobiledata, size: 26),
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No account? ",
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
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (ctx) => SignUp()),
                              );
                            },
                      child: Text(
                        'Sign up',
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
