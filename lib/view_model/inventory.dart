import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';
import 'package:flutter/material.dart';

final inventoryProvider = NotifierProvider<InventoryViewModel, List<Product>>(
  InventoryViewModel.new,
);

class InventoryViewModel extends Notifier<List<Product>> {
  final _db = FirebaseFirestore.instance;
  ProductCategory? _selectedCategory;
  ProductCategory? get selectedCategory => _selectedCategory;
  final TextEditingController searchQuery = TextEditingController();

  @override
  List<Product> build() {
    searchQuery.addListener(() => ref.notifyListeners());
    _listenToProducts(); // start listening to Firestore
    return [];
  }

  // listens to Firestore in real time
  void _listenToProducts() {
    _db.collection('products').snapshots().listen((snapshot) {
      state = snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // adds product to Firestore
  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }

  // removes product from Firestore
  Future<void> removeProduct(Product product) async {
    await _db.collection('products').doc(product.id).delete();
  }

  // deducts stock in Firestore
  Future<void> deductStock(Product product, int quantity) async {
    await _db.collection('products').doc(product.id).update({
      'productQuantity': product.productQuantity - quantity,
    });
  }

  void selectAll() {
    _selectedCategory = null;
    ref.notifyListeners();
  }

  void selectCategory(ProductCategory category) {
    _selectedCategory = category;
    ref.notifyListeners();
  }

  List<Product> get filteredProducts {
    var result = _selectedCategory == null
        ? state
        : state.where((p) => p.category == _selectedCategory).toList();

    if (searchQuery.text.isNotEmpty) {
      final query = searchQuery.text.toLowerCase();
      result = result
          .where((p) => p.productName.toLowerCase().contains(query))
          .toList();
      result.sort((a, b) {
        final aIndex = a.productName.toLowerCase().indexOf(query);
        final bIndex = b.productName.toLowerCase().indexOf(query);
        return aIndex.compareTo(bIndex);
      });
    }
    return result;
  }

  List<Product> get allProducts => state;

  List<Product> get expiredProducts {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.where((p) {
      final daysLeft = p.productExpiryDate.difference(today).inDays;
      return daysLeft < 0;
    }).toList();
  }

  List<Product> get nearExpiredProducts {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.where((p) {
      final daysLeft = p.productExpiryDate.difference(today).inDays;
      return daysLeft >= 0 && daysLeft <= 7;
    }).toList();
  }
}
