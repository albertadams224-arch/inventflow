import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/sale.dart';

final salesAnalyticsProvider =
    NotifierProvider<SalesAnalyticsViewModel, List<Sale>>(
      SalesAnalyticsViewModel.new,
    );

class SalesAnalyticsViewModel extends Notifier<List<Sale>> {
  final _db = FirebaseFirestore.instance;

  @override
  List<Sale> build() {
    _listenToSales();
    return [];
  }

  void _listenToSales() {
    _db.collection('sales').snapshots().listen((snapshot) {
      state = snapshot.docs
          .map((doc) => Sale.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // total revenue
  double get totalRevenue => state.fold(0, (sum, sale) => sum + sale.subtotal);

  // total items sold
  int get totalItemsSold => state.fold(0, (sum, sale) => sum + sale.quantity);

  // sales for today only
  List<Sale> get todaySales {
    final today = DateTime.now();
    return state
        .where(
          (sale) =>
              sale.soldAt.year == today.year &&
              sale.soldAt.month == today.month &&
              sale.soldAt.day == today.day,
        )
        .toList();
  }

  // total revenue today
  double get todayRevenue =>
      todaySales.fold(0, (sum, sale) => sum + sale.subtotal);
}
