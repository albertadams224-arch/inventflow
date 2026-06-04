import 'package:flutter/material.dart';

class AllButton extends StatelessWidget {
  const AllButton({
    super.key,
    required this.kBodySmallTextStyle,
    required this.allTap,
    required this.isSelected,
  });

  final TextStyle kBodySmallTextStyle;
  final void Function() allTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: allTap,
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.all(10),
          shape: StadiumBorder(),
        ),
        child: Text(
          'All',
          style: kBodySmallTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
