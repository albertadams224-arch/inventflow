import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/view_model/sales.dart';
import 'package:inventflow/widgets/input_fields.dart';

class ShowModalBottomSheets extends ConsumerStatefulWidget {
  const ShowModalBottomSheets({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ShowModalBottomSheets> createState() =>
      _ShowModalBottomSheetsState();
}

class _ShowModalBottomSheetsState extends ConsumerState<ShowModalBottomSheets> {
  final quantityController = TextEditingController();
  bool isLoading = false;

  Future<void> sellNow() async {
    final vm = ref.read(salesProvider.notifier);
    final error = vm.validateQuantity(widget.product, quantityController.text);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final qty = int.parse(quantityController.text);

    setState(() => isLoading = true);
    try {
      await vm.sellNow(ref, widget.product, qty);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Sale completed! 🎉'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void addToCart() {
    final vm = ref.read(salesProvider.notifier);
    final error = vm.validateAndAdd(widget.product, quantityController.text);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.productName, style: kLargeTextStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 5),
              Text('${widget.product.productQuantity} available'),
              const Spacer(),
              Chip(
                label: Text('GHC ${widget.product.productPrice}'),
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
            onPressed: isLoading ? null : sellNow,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.shopping_bag_outlined),
            label: Text(isLoading ? 'Processing...' : 'Sell Now'),
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
            onPressed: isLoading ? null : addToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
