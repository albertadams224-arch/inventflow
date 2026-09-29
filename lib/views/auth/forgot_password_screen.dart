import 'package:flutter/material.dart';
import 'package:inventflow/view_model/auth/forgot_password.dart';
import 'package:inventflow/widgets/input_fields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _vm = ForgotPasswordViewModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool emailSent = false;

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

    setState(() => emailSent = true);
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
        child: emailSent
            ? _buildSuccessView(context, colorScheme, kLargeTextStyle)
            : Form(
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
                            Icons.lock_reset_outlined,
                            size: 42,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text('Reset password', style: kLargeTextStyle),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your email and we\'ll send you a link to reset your password',
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
                                'Send reset link',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    ColorScheme colorScheme,
    TextStyle kLargeTextStyle,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 42,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Check your email',
            style: kLargeTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ve sent a password reset link to your email address.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Back to login',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
