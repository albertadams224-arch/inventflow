import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

class InventoryViewModel extends ChangeNotifier {
  ProductCategory? _selectedCategory;

  final TextEditingController searchQuary = TextEditingController();
  ProductCategory? get selectedCategory => _selectedCategory;

  InventoryViewModel() {
    searchQuary.addListener(notifyListeners);
  }

  // add product to empty list
  final List<Product> _addProduct = [];

  void addProdut(Product product) {
    _addProduct.insert(0, product);
    notifyListeners();
  }

  void selectAll() {
    _selectedCategory = null;
    notifyListeners();
  }

  void selectCategory(ProductCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    var result = _selectedCategory == null
        ? _addProduct
        : _addProduct.where((p) => p.category == _selectedCategory).toList();

    if (searchQuary.text.isNotEmpty) {
      final query = searchQuary.text.toLowerCase();
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

  @override
  void dispose() {
    searchQuary.dispose();
    super.dispose();
  }
}
