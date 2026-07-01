import 'package:flutter/material.dart';
import 'package:inventflow/model/sale_group.dart';

class TransactionCard extends StatelessWidget {
  final SaleGroup transaction;
  final String timeLabel;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final itemLabel = transaction.itemCount == 1 ? 'item' : 'items';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // removes the default divider ExpansionTile draws when expanded
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Text(
            '${transaction.itemCount} $itemLabel',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
          subtitle: Text(
            timeLabel,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12.5,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GHS ${transaction.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          children: transaction.items.map((sale) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 13.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(text: '${sale.productName} '),
                          TextSpan(
                            text: '×${sale.quantity}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'GHS ${sale.subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 13.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
