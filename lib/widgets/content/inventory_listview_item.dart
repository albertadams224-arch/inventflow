import 'package:flutter/material.dart';
import 'package:inventflow/model/product_category.dart';

class InventoryCategoryItem extends StatelessWidget {
  const InventoryCategoryItem({
    super.key,
    required this.category,
    required this.kBodySmallTextStyle,
    required this.onTap,
    this.isSelected,
  });

  final ProductCategory category;
  final TextStyle kBodySmallTextStyle;
  final VoidCallback onTap;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = isSelected == true;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          shape: const StadiumBorder(),
        ),
        child: Text(
          category.name,
          style: kBodySmallTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
