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

    void Save() {
      final error = vm.validateAndAdd(product, quantityController.text);
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      vm.confirmSale(ref);
      Navigator.of(context).pop();
    }

    return Container(
      height: 500,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [
            SizedBox(height: 50),
            InputFields(
              controller: quantityController,
              label: 'Quantity',
              hintText: 'qty 0.00',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(double.infinity, 70),
              ),
              onPressed: Save,
              child: Text(
                'Save',
                style: kLargeTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
