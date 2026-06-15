import 'dart:io';

import 'package:inventflow/model/product_category.dart';

class Product {
  final String productName;
  final int productQuantity;
  final double productPrice;
  final DateTime productExpiryDatet;
  final DateTime producDate;
  final File image;
  final ProductCategory category;

  Product({
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.productExpiryDatet,
    required this.producDate,
    required this.category,
    required this.image,
  });

  Product copyWith({
    String? productName,
    int? productQuantity,
    double? productPrice,
    DateTime? productExpiryDatet,
    DateTime? producDate,
    File? image,
    ProductCategory? category,
  }) {
    return Product(
      productName: productName ?? this.productName,
      productQuantity: productQuantity ?? this.productQuantity,
      productPrice: productPrice ?? this.productPrice,
      productExpiryDatet: productExpiryDatet ?? this.productExpiryDatet,
      producDate: producDate ?? this.producDate,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }
}
