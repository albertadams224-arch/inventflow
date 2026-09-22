import 'package:flutter/material.dart';
import 'package:inventflow/model/product_category.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key, required this.onChange});

  final void Function(ProductCategory) onChange;

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  ProductCategory selectedCategory = ProductCategory.beverages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      hint: const Text('Select category'),
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      items: ProductCategory.values.map((cat) {
        return DropdownMenuItem(value: cat, child: Text(cat.label));
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          selectedCategory = value;
        });
        widget.onChange(value);
      },
    );
  }
}
