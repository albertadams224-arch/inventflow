import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/expiry.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/widgets/buttons/filter_button_e.dart';
import 'package:inventflow/widgets/content/expriy_listview_content.dart';

class ExpiryScreen extends ConsumerStatefulWidget {
  const ExpiryScreen({super.key});

  @override
  ConsumerState<ExpiryScreen> createState() => _ExpiryScreenState();
}

class _ExpiryScreenState extends ConsumerState<ExpiryScreen> {
  int _selectedIndex = 0;
  late ExpiryViewModel _vm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 30, fontWeight: FontWeight.bold);

    final products = ref.watch(inventoryProvider);
    _vm = ExpiryViewModel(products);

    final displayedProducts = switch (_selectedIndex) {
      0 => _vm.allProducts,
      1 => _vm.expiredProducts,
      2 => _vm.nearExpiredProducts,
      _ => _vm.allProducts,
    };

    Widget content;
    if (displayedProducts.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 44,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 10),
            Text(
              'No items here',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      content = ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: displayedProducts.length,
        itemBuilder: (context, index) => ExpriyListviewContent(
          product: displayedProducts[index],
          vm: _vm,
          onDismissed: () => ref
              .read(inventoryProvider.notifier)
              .removeProduct(displayedProducts[index]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Expiry', style: kLargeTextStyle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FilterButton(
                    label: 'All',
                    count: _vm.allProducts.length,
                    isSelected: _selectedIndex == 0,
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    label: 'Expired',
                    count: _vm.expiredProducts.length,
                    isSelected: _selectedIndex == 1,
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilterButton(
                    label: 'Near',
                    count: _vm.nearExpiredProducts.length,
                    isSelected: _selectedIndex == 2,
                    onPressed: () => setState(() => _selectedIndex = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
