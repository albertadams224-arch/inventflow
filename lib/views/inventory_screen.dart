import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product_category.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/views/add_screen.dart';
import 'package:inventflow/views/check_out_screen.dart';
import 'package:inventflow/widgets/buttons/all_button.dart';
import 'package:inventflow/widgets/content/cart_bar.dart';
import 'package:inventflow/widgets/content/inventory_listview_content.dart';
import 'package:inventflow/widgets/content/inventory_listview_item.dart';
import 'package:inventflow/widgets/input_fields.dart';
import 'package:inventflow/view_model/sales.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inventoryProvider);
    final cart = ref.watch(salesProvider);
    final vm = ref.read(inventoryProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final products = vm.products(cart);
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 30, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);

    final categoryItems = [
      AllButton(
        kBodySmallTextStyle: kBodySmallTextStyle.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        allTap: vm.selectAll,
        isSelected: vm.selectedCategory == null,
      ),
      ...ProductCategory.values.map(
        (category) => InventoryCategoryItem(
          category: category,
          kBodySmallTextStyle: kBodySmallTextStyle,
          onTap: () => vm.selectCategory(category),
          isSelected: vm.selectedCategory == category,
        ),
      ),
    ];

    final Widget content = products.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 44,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 10),
                Text(
                  'No products found',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: products.length,
            itemBuilder: (context, index) => InventoryContentCard(
              product: products[index],
              onDismissed: () => ref
                  .read(inventoryProvider.notifier)
                  .removeProduct(products[index]),
            ),
          );

    return Scaffold(
      appBar: AppBar(title: Text('Inventory', style: kLargeTextStyle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => AddScreen()));
        },
        child: Icon(Icons.add, color: colorScheme.onSecondaryContainer),
      ),
      bottomNavigationBar: CartBar(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => CheckoutScreen()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(
          children: [
            InputFields(
              icon: Icons.search,
              hintText: 'search item',
              controller: vm.searchQuery,
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (context, index) => categoryItems[index],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
