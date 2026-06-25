import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/view_model/sales.dart';
import 'package:inventflow/widgets/input_fields.dart';

class ShowModalBottomSheets extends ConsumerWidget {
  const ShowModalBottomSheets({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(salesProvider.notifier);
    final quantityController = TextEditingController();
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);

    void handleSellNow() {
      final error = vm.validateQuantity(product, quantityController.text);
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      final qty = int.parse(quantityController.text);
      vm.sellNow(ref, product, qty);
      Navigator.of(context).pop();
    }

    void handleAddToCart() {
      final error = vm.validateAndAdd(product, quantityController.text);
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      Navigator.of(context).pop();
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.productName, style: kLargeTextStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 5),
              Text('${product.productQuantity} available'),
              const Spacer(),
              Chip(
                label: Text('GHC ${product.productPrice}'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 25),
          InputFields(
            controller: quantityController,
            label: 'Quantity',
            hintText: 'e.g., 1.00',
            keyboardType: TextInputType.number,
          ),
          const Spacer(),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: handleSellNow,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Sell Now'),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: handleAddToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
