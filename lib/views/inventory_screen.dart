import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product_category.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/views/add_screen.dart';
import 'package:inventflow/widgets/buttons/all_button.dart';
import 'package:inventflow/widgets/content/inventory_listview_content.dart';
import 'package:inventflow/widgets/content/inventory_listview_item.dart';
import 'package:inventflow/widgets/input_fields.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inventoryProvider);

    final vm = ref.read(inventoryProvider.notifier);

    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);

    final categoryItems = [
      AllButton(
        kBodySmallTextStyle: kBodySmallTextStyle.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
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

    final Widget content = vm.filteredProducts.isEmpty
        ? Center(child: Text('No product found'))
        : ListView.builder(
            itemCount: vm.filteredProducts.length,
            itemBuilder: (context, index) => InventoryContentCard(
              product: vm.filteredProducts[index],
              onDismissed: () => ref
                  .read(inventoryProvider.notifier)
                  .removeProduct(vm.filteredProducts[index]),
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
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputFields(
              icon: Icons.search,
              hintText: 'search item',
              controller: vm.searchQuery,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryItems.length,
                itemBuilder: (context, index) => categoryItems[index],
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
