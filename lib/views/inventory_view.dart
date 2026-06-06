import 'package:flutter/material.dart';
import 'package:inventflow/model/product_category.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/views/add_view.dart';
import 'package:inventflow/widgets/buttons/all_button.dart';
import 'package:inventflow/widgets/content/inventory_listview_content.dart';
import 'package:inventflow/widgets/content/inventory_listview_item.dart';
import 'package:inventflow/widgets/input_fields.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late InventoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InventoryViewModel();
  }

  @override
  void dispose() {
    _viewModel.searchQuary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);

    Widget content;

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final List<Widget> _categoryItems = [
          AllButton(
            kBodySmallTextStyle: kBodySmallTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            allTap: _viewModel.selectAll,
            isSelected: _viewModel.selectedCategory == null,
          ),
          ...ProductCategory.values.map(
            (category) => InventoryCategoryItem(
              category: category,
              kBodySmallTextStyle: kBodySmallTextStyle,
              onTap: () => _viewModel.selectCategory(category),
              isSelected: _viewModel.selectedCategory == category,
            ),
          ),
        ];

        if (_viewModel.filteredProducts.isEmpty) {
          content = Center(child: Text('No product found'));
        } else {
          content = ListView.builder(
            itemCount: _viewModel.filteredProducts.length,
            itemBuilder: (context, index) => InventoryContentCard(
              product: _viewModel.filteredProducts[index],
            ),
          );
        }

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
                  controller: _viewModel.searchQuary,
                ),

                SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categoryItems.length,
                    itemBuilder: (context, index) => _categoryItems[index],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(child: content),
              ],
            ),
          ),
        );
      },
    );
  }
}
