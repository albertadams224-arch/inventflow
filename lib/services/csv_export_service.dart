import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/model/product_category.dart';

class CsvExportService {
  static Future<void> exportProducts(List<Product> products) async {
    final buffer = StringBuffer();

    buffer.writeln('Name,Category,Price,Quantity,Date Added,Expiry Date');

    for (final product in products) {
      buffer.writeln(
        '${_escape(product.productName)},'
        '${_escape(product.category.label)},'
        '${product.productPrice},'
        '${product.productQuantity},'
        '${product.productDate.toIso8601String().split('T').first},'
        '${product.productExpiryDate.toIso8601String().split('T').first}',
      );
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/inventflow_export.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'InventFlow inventory export');
  }

  static String _escape(String value) {
    if (value.contains(',')) {
      return '"$value"';
    }
    return value;
  }
}
