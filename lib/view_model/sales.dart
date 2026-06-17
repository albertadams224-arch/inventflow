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

  String? validateAndAdd(Product product, String qtyText) {
    if (qtyText.isEmpty) return 'Quantity must not be empty';
    final qty = int.tryParse(qtyText);
    if (qty == null) return 'Quantity must be a valid whole number';
    if (qty <= 0) return 'Quantity must be greater than 0';
    if (qty > product.productQuantity) return 'Not enough stock available';
    addCart(product, qty);
    return null;
  }

  void addCart(Product product, quantity) {
    //checking if product already exits in cart
    final isExisting = state.where((i) => i.product == product).firstOrNull;
    // updating the quantity, help prevent duplicates
    if (isExisting != null) {
      state = state.map((i) {
        if (i.product == product) i.quantity = quantity;
        return i;
      }).toList();
    } else {
      state = [...state, SaleItem(product: product, quantity: quantity)];
    }
  }

  // getting total amount on sales
  double get total => state.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> confirmSale(WidgetRef ref) async {
    if (state.isEmpty) return;

    final item = state.first;

    /// save to firebase
    final sale = Sale(
      soldAt: DateTime.now(),
      productId: item.product.id,
      productName: item.product.productName,
      pricePerUnit: item.product.productPrice,
      quantity: item.quantity,
      subtotal: item.subtotal,
    );
    await _db.collection('sales').add(sale.toMap());

    // deducting from product
    await ref
        .read(inventoryProvider.notifier)
        .deductStock(item.product, item.quantity);

    // clear cart
    state = [];
  }

  void removeCart(Product product) {
    state = state.where((i) => i.product != product).toList();
  }
}
