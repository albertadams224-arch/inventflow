import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/sale.dart';
import 'package:inventflow/view_model/inventory.dart';

final salesProvider = NotifierProvider<SalesViewModel, List<SaleItem>>(
  SalesViewModel.new,
);

class SalesViewModel extends Notifier<List<SaleItem>> {
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

  void confirmSale(WidgetRef ref) {
    // deduct stock from inventory
    for (final item in state) {
      ref
          .read(inventoryProvider.notifier)
          .deductStock(item.product, item.quantity);
    }
    state = [];
  }

  void removeCart(Product product) {
    state = state.where((i) => i.product != product).toList();
  }
}
