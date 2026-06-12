import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';

class ExpiryViewModel extends ChangeNotifier {
  final List<Product> _products;

  ExpiryViewModel(this._products);

  List<Product> get allProducts => _products;

  List<Product> get expiredProducts {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return _products
        .where((p) => p.productExpiryDatet.isBefore(today))
        .toList();
  }

  List<Product> get nearExpiredProducts {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return _products.where((p) {
      final daysLeft = p.productExpiryDatet.difference(today).inDays;
      return daysLeft >= 0 && daysLeft <= 7;
    }).toList();
  }

  // status logic moves here, not in the widget
  String getStatus(Product product) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final daysLeft = product.productExpiryDatet.difference(today).inDays;

    if (daysLeft < 0) return 'Expired';
    if (daysLeft <= 7) return 'Near Expired';
    return 'Good';
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Expired':
        return Colors.red;
      case 'Near Expired':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }
}
