import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        count != null ? '$label ($count)' : label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
