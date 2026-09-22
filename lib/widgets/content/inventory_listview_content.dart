import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/view_model/sales.dart';
import 'package:inventflow/widgets/containers/show_modal_bottom.dart';
import 'dart:convert';

class InventoryContentCard extends ConsumerWidget {
  const InventoryContentCard({
    super.key,
    required this.product,
    required this.onDismissed,
  });
  final Product product;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(salesProvider);
    final cartItem = cart.where((i) => i.product == product).firstOrNull;
    final qtyInCart = cartItem?.quantity ?? 0;
    final remainingQty = product.productQuantity - qtyInCart;

    final colorScheme = Theme.of(context).colorScheme;

    var kBodyLargeTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 10, fontWeight: FontWeight.bold);

    void showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) => ShowModalBottomSheets(product: product),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                width: 56,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.memory(
                  base64Decode(product.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.onSurfaceVariant,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kBodyLargeTextStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kBodySmallTextStyle.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              DisplayItemContainer(
                bg: colorScheme.tertiaryContainer,
                textColor: colorScheme.onTertiaryContainer,
                title: 'Qty: $remainingQty',
              ),
              const SizedBox(width: 8),
              DisplayItemContainer(
                bg: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
                title: 'GH₵ ${product.productPrice}',
              ),
              const Spacer(),
              InventoryInteractButton(
                bg: colorScheme.primaryContainer,
                icon: Icons.shopping_cart_outlined,
                iconColor: colorScheme.onPrimaryContainer,
                onPressed: showBottomSheet,
              ),
              const SizedBox(width: 8),
              InventoryInteractButton(
                bg: colorScheme.errorContainer,
                icon: Icons.delete_outline,
                iconColor: colorScheme.onErrorContainer,
                onPressed: onDismissed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InventoryInteractButton extends StatelessWidget {
  const InventoryInteractButton({
    super.key,
    required this.bg,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 19, color: iconColor),
      ),
    );
  }
}

class DisplayItemContainer extends StatelessWidget {
  const DisplayItemContainer({
    super.key,
    required this.bg,
    required this.textColor,
    required this.title,
    this.icon,
    this.fontWeight,
    this.textStyle,
  });
  final String title;
  final Color bg;
  final Color textColor;
  final IconData? icon;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 10, fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            title,
            style:
                textStyle ??
                kBodySmallTextStyle.copyWith(
                  color: textColor,
                  fontWeight: fontWeight ?? FontWeight.bold,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}
