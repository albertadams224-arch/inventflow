import 'package:flutter/material.dart';
import 'package:inventflow/view_model/auth/login.dart';
import 'package:inventflow/views/auth/sign_screen.dart';
import 'package:inventflow/views/tabs.dart';
import 'package:inventflow/widgets/input_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _vm = LoginViewModel();
  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _vm.submit();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => TabScreen()));
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
                SizedBox(height: 40),
                Row(children: [Text('Welcome back', style: kLargeTextStyle)]),
                SizedBox(height: 20),
                Row(children: [Text('Email', style: kBodyLargeTextStyle)]),
                SizedBox(height: 10),
                InputFields(
                  hintText: 'Email Address',
                  controller: _vm.emailController,
                  validator: (value) => _vm.validateEmail(),
                ),
                SizedBox(height: 20),
                Row(children: [Text('Password', style: kBodyLargeTextStyle)]),
                SizedBox(height: 10),
                InputFields(
                  hintText: 'Password',
                  controller: _vm.passwordController,
                  validator: (value) => _vm.validatePassword(),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
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
                  child: Text('Log in', style: kBodyLargeTextStyle),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No account?', style: kBodyLargeTextStyle),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => SignUp()),
                        );
                      },
                      child: Text(
                        'Sign up',
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
