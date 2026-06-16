import 'package:inventflow/model/product_category.dart';

class Product {
  final String id;
  final String productName;
  final int productQuantity;
  final double productPrice;
  final DateTime productExpiryDate;
  final DateTime productDate;
  final String imageUrl;
  final ProductCategory category;

  Product({
    required this.id,
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.productExpiryDate,
    required this.productDate,
    required this.category,
    required this.imageUrl,
  });

  // converting to map for firebase
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productQuantity': productQuantity,
      'productPrice': productPrice,
      'productExpiryDatet': productExpiryDate.toIso8601String(),
      'producDate': productDate.toIso8601String(),
      'category': category.name,
      'imageUrl': imageUrl,
    };
  }

  //returns data from firebase
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      productName: map['productName'],
      productQuantity: map['productQuantity'],
      productPrice: map['productPrice'],
      productExpiryDate: DateTime.parse(map['productExpiryDatet']),
      productDate: DateTime.parse(map['producDate']),
      category: ProductCategory.values.byName(map['category']),
      imageUrl: map['imageUrl'],
    );
  }
}
