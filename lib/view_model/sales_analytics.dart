import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/sale.dart';
import 'package:inventflow/model/sale_group.dart';
import 'package:intl/intl.dart';

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

  // total items sold today
  int get todayItemsSold =>
      todaySales.fold(0, (sum, sale) => sum + sale.quantity);

  /*
  This creates an empty map. We loop through state (the flat list of sales), and for each
  sale, we look up its transactionId in the map — if no list exists yet for that ID, one gets
  created on the spot; either way, we add the sale into whichever list is sitting at that key.
  Once every sale has been filed away, we convert each key-value pair in the map into a
  SaleGroup object, collect those into an actual list, and finally sort that list so the most
  recent transaction comes first.
  */
  List<SaleGroup> get groupedTransactions {
    final Map<String, List<Sale>> grouped = {};

    for (final sale in state) {
      grouped.putIfAbsent(sale.transactionId, () => []).add(sale);
    }

    final transactions = grouped.entries
        .map((e) => SaleGroup(transactionId: e.key, items: e.value))
        .toList();

    transactions.sort((a, b) => b.soldAt.compareTo(a.soldAt));
    return transactions;
  }

  // sorting by day
  List<MapEntry<String, List<SaleGroup>>> get dailyTransactions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<SaleGroup>> buckets = {};

    for (final txn in groupedTransactions) {
      final day = DateTime(txn.soldAt.year, txn.soldAt.month, txn.soldAt.day);
      String label;
      if (day == today) {
        label = 'Today';
      } else if (day == yesterday) {
        label = 'Yesterday';
      } else {
        label = DateFormat('MMM d').format(day);
      }
      buckets.putIfAbsent(label, () => []).add(txn);
    }

    return buckets.entries.toList();
  }
}
