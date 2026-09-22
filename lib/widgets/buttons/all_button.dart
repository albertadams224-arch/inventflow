import 'package:flutter/material.dart';

class AllButton extends StatelessWidget {
  const AllButton({
    super.key,
    required this.kBodySmallTextStyle,
    required this.allTap,
    required this.isSelected,
  });

  final TextStyle kBodySmallTextStyle;
  final VoidCallback allTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: allTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          shape: const StadiumBorder(),
        ),
        child: Text(
          'All',
          style: kBodySmallTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
