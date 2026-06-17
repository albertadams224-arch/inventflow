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
    // check if this product is already in the cart
    final cart = ref.watch(salesProvider);
    final cartItem = cart.where((i) => i.product == product).firstOrNull;
    final qtyInCart = cartItem?.quantity ?? 0;
    final remainingQty = product.productQuantity - qtyInCart;

    var kBodyLargeTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);
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
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(5),
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.memory(
                  base64Decode(product.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported_outlined);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: kBodyLargeTextStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      product.category.name,
                      style: kBodySmallTextStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        DisplayItemContainer(
                          bg: Theme.of(context).colorScheme.tertiaryContainer,
                          textColor: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                          title: 'Qty: $remainingQty',
                        ),
                        SizedBox(width: 10),
                        DisplayItemContainer(
                          bg: Theme.of(context).colorScheme.primaryContainer,
                          textColor: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          title: 'GH₵ ${product.productPrice}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // DisplayItemContainer(
              //   bg: Color(0xFFB2DFDB),
              //   textColor: Color(0xFF004D40),
              //   title: 'Fresh',
              //   icon: Icons.check,
              //   fontWeight: FontWeight.w900,
              // ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // InventoryInteractButton(
              //   bg: Colors.deepPurple.shade50,
              //   icon: Icons.edit_outlined,
              //   iconColor: Colors.deepPurple.shade400,
              //   onPressed: () {},
              // ),
              SizedBox(width: 5),
              InventoryInteractButton(
                bg: Theme.of(context).colorScheme.primaryContainer,
                icon: Icons.shopping_cart_outlined,
                iconColor: Colors.green.shade600,
                onPressed: () {
                  showBottomSheet();
                },
              ),
              SizedBox(width: 5),
              InventoryInteractButton(
                bg: Colors.red.shade50,
                icon: Icons.delete_outline,
                iconColor: Theme.of(context).colorScheme.error,
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
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: IconButton.styleFrom(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      ),
      onPressed: onPressed,
      label: Icon(icon, color: iconColor),
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
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 15),

          Text(
            title,
            style:
                textStyle ??
                kBodySmallTextStyle.copyWith(
                  color: textColor,
                  fontWeight: fontWeight ?? FontWeight.bold,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
