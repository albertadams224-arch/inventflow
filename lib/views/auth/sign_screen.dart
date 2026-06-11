import 'package:flutter/material.dart';
import 'package:inventflow/view_model/auth/sign_up.dart';
import 'package:inventflow/views/auth/login_screen.dart';
import 'package:inventflow/widgets/input_fields.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _vm = SignUpViewModel();
  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _vm.submit();
    }
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    var kBodyLargeTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Icon(Icons.grid_view, size: 70),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('InventFlow', style: kLargeTextStyle)],
                ),
                SizedBox(height: 30),
                Row(
                  children: [Text(' Create account', style: kLargeTextStyle)],
                ),
                SizedBox(height: 10),
                Row(children: [Text('Name', style: kBodyLargeTextStyle)]),
                SizedBox(height: 10),
                InputFields(
                  hintText: 'Enter name',
                  controller: _vm.nameController,
                  validator: (value) => _vm.validateName(),
                ),
                SizedBox(height: 10),
                Row(children: [Text('Email', style: kBodyLargeTextStyle)]),
                SizedBox(height: 10),
                InputFields(
                  hintText: 'Email Address',
                  controller: _vm.emailController,
                  validator: (value) => _vm.validateEmail(),
                ),
                SizedBox(height: 10),
                Row(children: [Text('Password', style: kBodyLargeTextStyle)]),
                SizedBox(height: 10),
                InputFields(
                  hintText: 'Password',
                  controller: _vm.passwordController,
                  validator: (value) => _vm.validatePassword(),
                ),
                SizedBox(height: 30),

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: Text('Create account', style: kBodyLargeTextStyle),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account?', style: kBodyLargeTextStyle),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => Login()),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
