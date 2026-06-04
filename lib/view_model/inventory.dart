import 'package:flutter/material.dart';
import 'package:inventflow/data/dummy_data.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

class InventoryViewModel extends ChangeNotifier {
  ProductCategory? _selectedCategory;

  ProductCategory? get selectedCategory => _selectedCategory;

  void selectAll() {
    _selectedCategory = null;
    notifyListeners();
  }

  void selectCategory(ProductCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == null) return dummyData;
    return dummyData.where((p) => p.category == _selectedCategory).toList();
  }
}
