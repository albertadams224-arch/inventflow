import 'package:flutter/material.dart';
import 'package:inventflow/model/product.dart';
import 'package:inventflow/view_model/expiry.dart';

class ExpriyListviewContent extends StatelessWidget {
  const ExpriyListviewContent({
    super.key,
    required this.product,
    required this.vm,
    required this.onDismissed,
  });
  final Product product;
  final ExpiryViewModel vm;
  final VoidCallback onDismissed;
  @override
  Widget build(BuildContext context) {
    final status = vm.getStatus(product);
    final statusColor = vm.getStatusColor(status);
    var kMediumTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Dismissible(
      key: Key(product.productName),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName, style: kMediumTextStyle),
                  Text('Expires: ${vm.formatDate(product.productExpiryDatet)}'),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
