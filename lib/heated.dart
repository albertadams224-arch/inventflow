import 'package:flutter/material.dart';

class Albert extends StatelessWidget {
  const Albert({super.key});
  @override
  Widget build(BuildContext context) {
    return Text('Heated');
  }
}

class Heated extends StatefulWidget {
  const Heated({super.key});

  @override
  State<Heated> createState() => _HeatedState();
}

class _HeatedState extends State<Heated> {
  @override
  Widget build(BuildContext context) {
    return Text('Heated');
  }
}
