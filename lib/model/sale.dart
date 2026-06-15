import 'package:inventflow/model/product.dart';

class SaleItem {
  final Product product;
  int quantity;
  SaleItem({required this.product, required this.quantity});

  double get subtotal => product.productPrice * quantity;
}
