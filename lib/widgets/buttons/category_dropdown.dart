import 'package:flutter/material.dart';
import 'package:inventflow/model/product_category.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key, required this.onChange});

  final void Function(ProductCategory) onChange;

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  ProductCategory _selectedCategory = ProductCategory.beverages;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text('Selected Category'),
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: ProductCategory.values.map((cat) {
        return DropdownMenuItem(value: cat, child: Text(cat.name));
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedCategory = value;
        });

        widget.onChange(value);
      },
    );
  }
}
