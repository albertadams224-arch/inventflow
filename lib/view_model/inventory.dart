import 'package:flutter/material.dart';
import 'package:inventflow/data/dummy_data.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

class InventoryViewModel extends ChangeNotifier {
  ProductCategory? _selectedCategory;
  final TextEditingController searchQuary = TextEditingController();

  ProductCategory? get selectedCategory => _selectedCategory;

  InventoryViewModel() {
    searchQuary.addListener(notifyListeners);
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
        ? dummyData
        : dummyData.where((p) => p.category == _selectedCategory).toList();

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
