import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

class AddViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController pricesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;
  DateTime? expiryDate;
  ProductCategory? selectedCategory;
  File? selectedImage;

  String? validateInput() {
    if (nameController.text.isEmpty) return 'Product name must not be empty';
    if (selectedCategory == null) return 'Please select a category';
    if (pricesController.text.isEmpty) return 'Price must not be empty';
    if (double.tryParse(pricesController.text) == null)
      return 'Price must be a valid number';

    if (quantityController.text.isEmpty) return 'Quantity must not be empty';
    if (int.tryParse(quantityController.text) == null)
      return 'Quantity must be a valid whole number';
    return null;
  }

  bool isValid() => validateInput() == null;

  Product buildProduct() {
    return Product(
      productName: nameController.text,
      category: selectedCategory!,
      productPrice: double.tryParse(pricesController.text) ?? 0.0,
      productQuantity: int.tryParse(quantityController.text) ?? 0,
      productExpiryDatet: expiryDate ?? DateTime.now(),
      producDate: selectedDate ?? DateTime.now(),
      image: selectedImage!,
    );
  }

  void dispose() {
    nameController.dispose();
    pricesController.dispose();
    quantityController.dispose();
  }
}
