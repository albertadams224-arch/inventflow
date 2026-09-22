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
    final colorScheme = Theme.of(context).colorScheme;
    final itemLabel = transaction.itemCount == 1 ? 'item' : 'items';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_outlined,
              size: 20,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            '${transaction.itemCount} $itemLabel',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            timeLabel,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12.5,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GHS ${transaction.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: colorScheme.primary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          children: [
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 10),
            ...transaction.items.map((sale) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontSize: 13.5,
                                color: colorScheme.onSurfaceVariant,
                              ),
                          children: [
                            TextSpan(text: '${sale.productName} '),
                            TextSpan(
                              text: '×${sale.quantity}',
                              style: TextStyle(color: colorScheme.outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'GHS ${sale.subtotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
