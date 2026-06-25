import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/sale.dart';
import 'package:inventflow/model/cart_iterm.dart';
import 'package:inventflow/view_model/inventory.dart';

final salesProvider = NotifierProvider<SalesViewModel, List<SaleItem>>(
  SalesViewModel.new,
);

class SalesViewModel extends Notifier<List<SaleItem>> {
  final _db = FirebaseFirestore.instance;
  @override
  List<SaleItem> build() {
    return [];
  }

  String? validateQuantity(Product product, String qtyText) {
    if (qtyText.isEmpty) return 'Quantity must not be empty';
    final qty = int.tryParse(qtyText);
    if (qty == null) return 'Quantity must be a valid whole number';
    if (qty <= 0) return 'Quantity must be greater than 0';
    if (qty > product.productQuantity) return 'Not enough stock available';
    return null;
  }

  String? validateAndAdd(Product product, String qtyText) {
    final error = validateQuantity(product, qtyText);
    if (error != null) return error;
    final qty = int.parse(qtyText);
    addCart(product, qty);
    return null;
  }

  void addCart(Product product, int quantity) {
    // checking if product already exists in cart
    final isExisting = state.where((i) => i.product == product).firstOrNull;
    // updating the quantity, helps prevent duplicates
    if (isExisting != null) {
      state = state.map((i) {
        if (i.product == product) {
          return SaleItem(product: product, quantity: quantity);
        }
        return i;
      }).toList();
    } else {
      state = [...state, SaleItem(product: product, quantity: quantity)];
    }
  }

  // getting total amount on sales
  double get total => state.fold(0, (sum, item) => sum + item.subtotal);

  /// Does the actual work of turning one product+quantity into a recorded
  /// sale: builds the Sale, writes it to Firestore, then deducts stock.
  /// Both confirmSale (whole cart) and sellNow (single item) call this.
  Future<void> _recordSale(
    WidgetRef ref,
    Product product,
    int quantity,
    String transactionId,
  ) async {
    final sale = Sale(
      soldAt: DateTime.now(),
      transactionId: transactionId,
      productId: product.id,
      productName: product.productName,
      pricePerUnit: product.productPrice,
      quantity: quantity,
      subtotal: product.productPrice * quantity,
    );

    await _db.collection('sales').add(sale.toMap());

    await ref.read(inventoryProvider.notifier).deductStock(product, quantity);
  }

  /// Checks out everything currently in the cart.
  Future<void> confirmSale(WidgetRef ref) async {
    if (state.isEmpty) return;

    final transactionId = _db.collection('sales').doc().id;
    final cartItems = List<SaleItem>.from(state);

    for (final item in cartItems) {
      await _recordSale(ref, item.product, item.quantity, transactionId);
    }

    // clear cart
    state = [];
  }

  /// Sells a single product immediately, bypassing the cart entirely.
  /// Used by the "Sell now" button in the bottom sheet.
  Future<void> sellNow(WidgetRef ref, Product product, int quantity) async {
    final transactionId = _db.collection('sales').doc().id;
    await _recordSale(ref, product, quantity, transactionId);
  }

  void removeCart(Product product) {
    state = state.where((i) => i.product != product).toList();
  }
}
