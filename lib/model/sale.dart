class Sale {
  final DateTime soldAt;
  final String productId;
  final String productName;
  final double pricePerUnit;
  final int quantity;
  final double subtotal;

  Sale({
    required this.soldAt,
    required this.productId,
    required this.productName,
    required this.pricePerUnit,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'soldAt': soldAt.toIso8601String(),
      'productId': productId,
      'productName': productName,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory Sale.fromMap(String id, Map<String, dynamic> map) {
    return Sale(
      soldAt: DateTime.parse(map['soldAt']),
      productId: map['productId'],
      productName: map['productName'],
      pricePerUnit: (map['pricePerUnit'] as num).toDouble(),
      quantity: map['quantity'],
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }
}
