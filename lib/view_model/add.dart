import 'package:flutter/material.dart';

class Add {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController pricesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;
  DateTime? expiryDate;
  String? validateInput() {
    if (nameController.text.isEmpty ||
        categoryController.text.isEmpty ||
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
    final category = categoryController.text;
    final price = double.tryParse(pricesController.text) ?? 0.0;
    final qty = int.tryParse(quantityController.text) ?? 0;

    print('Saving: $name, $category, $price, $qty');
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    pricesController.dispose();
    quantityController.dispose();
  }
}
