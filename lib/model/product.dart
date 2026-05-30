import 'package:inventflow/model/product_category.dart';

class Product {
  final String productName;
  final int productQuantity;
  final double productPrice;
  final DateTime productExpiryDatet;
  final ProductCategory category;

  Product({
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.productExpiryDatet,
    required this.category,
  });
}
