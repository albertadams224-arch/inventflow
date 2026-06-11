import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

final inventoryProvider = NotifierProvider<InventoryViewModel, List<Product>>(
  InventoryViewModel.new,
);

class InventoryViewModel extends Notifier<List<Product>> {
  ProductCategory? _selectedCategory;
  ProductCategory? get selectedCategory => _selectedCategory;

  final TextEditingController searchQuery = TextEditingController();

  @override
  List<Product> build() {
    searchQuery.addListener(() => ref.notifyListeners());
    return [];
  }

  void addProduct(Product product) {
    state = [product, ...state];
  }

  void selectAll() {
    _selectedCategory = null;
    ref.notifyListeners();
  }

  void selectCategory(ProductCategory category) {
    _selectedCategory = category;
    ref.notifyListeners();
  }

  List<Product> get filteredProducts {
    var result = _selectedCategory == null
        ? state
        : state.where((p) => p.category == _selectedCategory).toList();

    if (searchQuery.text.isNotEmpty) {
      final query = searchQuery.text.toLowerCase();
      result = result
          .where((p) => p.productName.toLowerCase().contains(query))
          .toList();

      result.sort((a, b) {
        final aIndex = a.productName.toLowerCase().indexOf(query);
        final bIndex = b.productName.toLowerCase().indexOf(query);
        return aIndex.compareTo(bIndex);
      });
    }
    return result;
  }
}
