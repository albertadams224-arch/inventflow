import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/sales_analytics.dart';
import 'package:inventflow/widgets/containers/transaction_card.dart';
import 'package:intl/intl.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);

    ref.watch(salesAnalyticsProvider);
    final dailySections = ref
        .read(salesAnalyticsProvider.notifier)
        .dailyTransactions;

    return Scaffold(
      appBar: AppBar(title: Text('Sales', style: kLargeTextStyle)),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: dailySections.length,
        itemBuilder: (context, index) {
          final section = dailySections[index];
          final label = section.key;
          final dayTransactions = section.value;

          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ...dayTransactions.map(
                  (txn) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TransactionCard(
                      transaction: txn,
                      timeLabel: DateFormat('h:mm a').format(txn.soldAt),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
