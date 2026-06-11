import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';
import 'package:inventflow/view_model/inventory.dart';

class AddViewModel {
  final InventoryViewModel iViewModel;

  AddViewModel({required this.iViewModel});
  TextEditingController nameController = TextEditingController();
  TextEditingController pricesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;
  DateTime? expiryDate;

  ProductCategory? selectedCategory;

  String? validateInput() {
    if (nameController.text.isEmpty ||
        selectedCategory == null ||
        pricesController.text.isEmpty ||
        quantityController.text.isEmpty) {
      return 'Field must not be empty';
    }
    return null;
  }

  bool isvalid() {
    return validateInput() == null;
  }

  Future<void> saveProduct() async {
    if (!isvalid()) return;

    final name = nameController.text;
    final category = selectedCategory;
    final price = double.tryParse(pricesController.text) ?? 0.0;
    final qty = int.tryParse(quantityController.text) ?? 0;
    final expiry = expiryDate ?? DateTime.now();
    final selectDate = selectedDate ?? DateTime.now();
    iViewModel.addProdut(
      Product(
        productName: name,
        productQuantity: qty,
        productPrice: price,
        productExpiryDatet: expiry,
        category: category!,
        producDate: selectDate,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    pricesController.dispose();
    quantityController.dispose();
  }
}
