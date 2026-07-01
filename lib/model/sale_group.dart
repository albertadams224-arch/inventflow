import 'package:inventflow/model/sale.dart';

class SaleGroup {
  final String transactionId;
  final List<Sale> items;

  SaleGroup({required this.transactionId, required this.items});

  DateTime get soldAt => items.first.soldAt;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
