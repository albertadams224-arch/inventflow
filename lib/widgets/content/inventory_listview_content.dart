import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';

class InventoryContentCard extends StatelessWidget {
  const InventoryContentCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    // var kLargeTextStyle = Theme.of(
    //   context,
    // ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    var kBodyLargeTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 10, fontWeight: FontWeight.bold);

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
                padding: EdgeInsets.all(20),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.add),
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
                          bg: Colors.purple.shade50,
                          textColor: Colors.purple.shade700,
                          title: 'Qty: ${product.productQuantity}',
                        ),
                        SizedBox(width: 10),
                        DisplayItemContainer(
                          bg: Color(0xFFB2DFDB),
                          textColor: Color(0xFF004D40),
                          title: 'GH₵ ${product.productPrice}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              DisplayItemContainer(
                bg: Color(0xFFB2DFDB),
                textColor: Color(0xFF004D40),
                title: 'Fresh',
                icon: Icons.check,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InventoryInteractButton(
                bg: Colors.deepPurple.shade50,
                icon: Icons.edit_outlined,
                iconColor: Colors.deepPurple.shade400,
                onPressed: () {},
              ),
              SizedBox(width: 5),
              InventoryInteractButton(
                bg: Colors.green.shade50,
                icon: Icons.shopping_cart_outlined,
                iconColor: Colors.green.shade600,
                onPressed: () {},
              ),
              SizedBox(width: 5),
              InventoryInteractButton(
                bg: Colors.red.shade50,
                icon: Icons.delete_outline,
                iconColor: Colors.red.shade400,
                onPressed: () {},
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
