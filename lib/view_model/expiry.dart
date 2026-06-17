import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';

class ExpiryViewModel extends ChangeNotifier {
  final List<Product> _products;

  ExpiryViewModel(this._products);

  List<Product> get allProducts => _products;

  List<Product> get expiredProducts {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _products.where((p) {
      final daysLeft = p.productExpiryDate.difference(today).inDays;
      return daysLeft < 0; // ← strictly expired
    }).toList();
  }

  List<Product> get nearExpiredProducts {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return _products.where((p) {
      final daysLeft = p.productExpiryDate.difference(today).inDays;
      return daysLeft >= 0 && daysLeft <= 7;
    }).toList();
  }

  String getStatus(Product product) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final daysLeft = product.productExpiryDate.difference(today).inDays;

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
