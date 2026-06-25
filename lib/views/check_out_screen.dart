import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/sales.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(salesProvider);
    final total = ref.watch(salesProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            title: Text(item.product.productName),
            subtitle: Text(
              'Qty ${item.quantity} × GH₵ ${item.product.productPrice}',
            ),
            trailing: Text('GH₵ ${item.subtotal.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(salesProvider.notifier).confirmSale(ref);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text('Complete sale · GH₵ ${total.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
