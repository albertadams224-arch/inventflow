import 'package:flutter/material.dart';

class AllButton extends StatelessWidget {
  const AllButton({
    super.key,
    required this.kBodySmallTextStyle,
    required this.allTap,
  });

  final TextStyle kBodySmallTextStyle;
  final void Function() allTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: allTap,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(10),
          shape: StadiumBorder(),
        ),
        child: Text(
          'All',
          style: kBodySmallTextStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
