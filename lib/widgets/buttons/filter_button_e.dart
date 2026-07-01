import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: isSelected ? primary : surface,
        foregroundColor: isSelected ? onPrimary : Colors.black,
      ),
      onPressed: onPressed,

      child: Text(
        label,
        // style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
