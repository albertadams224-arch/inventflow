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

  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);

    final products = ref.watch(inventoryProvider);
    final vm = ExpiryViewModel(products);

    final displayedProducts = switch (_selectedIndex) {
      0 => vm.allProducts,
      1 => vm.expiredProducts,
      2 => vm.nearExpiredProducts,
      _ => vm.allProducts,
    };

    Widget? content;

    if (displayedProducts.isEmpty) {
      content = Center(child: Text('No iterm'));
    } else {
      content = ListView.builder(
        itemCount: displayedProducts.length,
        itemBuilder: (context, index) => ExpriyListviewContent(
          product: displayedProducts[index],
          vm: vm,
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
                FilterButton(
                  label: 'All',
                  isSelected: _selectedIndex == 0,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 12),
                FilterButton(
                  label: 'Expired',
                  isSelected: _selectedIndex == 1,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                const SizedBox(width: 12),
                FilterButton(
                  label: 'Near Expired',
                  isSelected: _selectedIndex == 2,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
