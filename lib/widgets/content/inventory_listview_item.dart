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
  final void Function() onTap;
  final bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          backgroundColor: isSelected == true
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.onPrimary,
          shape: StadiumBorder(side: BorderSide(color: Colors.blueGrey)),
        ),
        child: Text(
          category.name,
          style: kBodySmallTextStyle.copyWith(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
