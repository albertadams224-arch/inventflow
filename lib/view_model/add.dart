import 'dart:typed_data';
import 'dart:convert';

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
  Uint8List? selectedImage;

  String? validateInput() {
    if (nameController.text.isEmpty) return 'Product name must not be empty';
    if (selectedCategory == null) return 'Please select a category';
    if (selectedImage == null) return 'Please select an image';
    if (pricesController.text.isEmpty) return 'Price must not be empty';
    if (double.tryParse(pricesController.text) == null) {
      return 'Price must be a valid number';
    }
    if (quantityController.text.isEmpty) return 'Quantity must not be empty';
    if (int.tryParse(quantityController.text) == null) {
      return 'Quantity must be a valid whole number';
    }
    return null;
  }

  bool isValid() => validateInput() == null;

  // builds product — image bytes are already in memory, no file read needed
  Future<Product> buildProduct() async {
    final imageBase64 = base64Encode(selectedImage!);
    return Product(
      id: '',
      productName: nameController.text,
      category: selectedCategory!,
      productPrice: double.tryParse(pricesController.text) ?? 0.0,
      productQuantity: int.tryParse(quantityController.text) ?? 0,
      productExpiryDate: expiryDate ?? DateTime.now(),
      productDate: selectedDate ?? DateTime.now(),
      imageUrl: imageBase64,
    );
  }

  void dispose() {
    nameController.dispose();
    pricesController.dispose();
    quantityController.dispose();
  }
}
