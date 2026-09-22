import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/sales_analytics.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/views/expiry_screen.dart';
import 'package:inventflow/widgets/containers/alert_banner.dart';
import 'package:inventflow/widgets/containers/info_badge.dart';
import 'package:inventflow/widgets/containers/overview_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inventoryProvider);
    ref.watch(salesAnalyticsProvider);

    final inventory = ref.watch(inventoryProvider.notifier);
    final analytics = ref.watch(salesAnalyticsProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 30, fontWeight: FontWeight.bold);
    var kSectionTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 18, fontWeight: FontWeight.bold);

    void goToExpiry() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => ExpiryScreen()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hello Albert!')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: kLargeTextStyle),
            const SizedBox(height: 20),

            if (inventory.expiredProducts.isNotEmpty)
              AlertBanner(
                key: const ValueKey('expired'),
                message:
                    '${inventory.expiredProducts.length} item(s) EXPIRED! Remove them.',
                icon: Icons.info_outline,
                themeColor: colorScheme.error,
                onDismissed: goToExpiry,
              ),

            if (inventory.nearExpiredProducts.isNotEmpty)
              AlertBanner(
                key: const ValueKey('near_expiry'),
                message:
                    '${inventory.nearExpiredProducts.length} items expiring within 7 days.',
                icon: Icons.access_time,
                themeColor: colorScheme.tertiary,
                onDismissed: goToExpiry,
              ),

            // revenue card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Revenue",
                      style: kSectionTextStyle.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'GH₵ ${analytics.todayRevenue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        InfoBadge(
                          icon: Icons.shopping_cart_outlined,
                          title: '${analytics.todaySales.length} Sales Today',
                        ),
                        InfoBadge(
                          icon: Icons.trending_up,
                          title:
                              'GH₵ ${analytics.totalRevenue.toStringAsFixed(2)} Total',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
            Text('Overview', style: kSectionTextStyle),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OverviewCard(
                    icon: Icons.inventory_2_outlined,
                    accentColor: colorScheme.primary,
                    accentBackgroundColor: colorScheme.primaryContainer,
                    value: '${inventory.allProducts.length}',
                    label: 'Total Items',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OverviewCard(
                    icon: Icons.access_time,
                    accentColor: colorScheme.tertiary,
                    accentBackgroundColor: colorScheme.tertiaryContainer,
                    value: '${inventory.nearExpiredProducts.length}',
                    label: 'Near Expiry',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OverviewCard(
                    icon: Icons.cancel_outlined,
                    accentColor: colorScheme.error,
                    accentBackgroundColor: colorScheme.errorContainer,
                    value: '${inventory.expiredProducts.length}',
                    label: 'Expired',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OverviewCard(
                    icon: Icons.shopping_bag_outlined,
                    accentColor: colorScheme.secondary,
                    accentBackgroundColor: colorScheme.secondaryContainer,
                    value: '${analytics.todayItemsSold}',
                    label: 'Items Sold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
