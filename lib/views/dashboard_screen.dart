import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/model/sales_analytics.dart';
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

    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    var kBodySmallTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: Text('Hello Albert!')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: kLargeTextStyle),
              SizedBox(height: 20),

              if (inventory.expiredProducts.isNotEmpty)
                AlertBanner(
                  key: ValueKey('expired'),
                  message:
                      '${inventory.expiredProducts.length} item(s) EXPIRED! Remove them.',
                  icon: Icons.info_outline,
                  themeColor: Colors.red.shade700,
                  onDismissed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => ExpiryScreen()));
                  },
                ),

              if (inventory.nearExpiredProducts.isNotEmpty)
                AlertBanner(
                  key: ValueKey('near_expiry'),
                  message:
                      '${inventory.nearExpiredProducts.length} items expiring within 7 days.',
                  icon: Icons.access_time,
                  themeColor: Colors.orange.shade800,
                  onDismissed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => ExpiryScreen()));
                  },
                ),

              // revenue card
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Revenue',
                        style: kBodySmallTextStyle.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'GH₵ ${analytics.todayRevenue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          InfoBadge(
                            icon: Icons.shopping_cart_outlined,
                            title: '${analytics.todaySales.length} Sales Today',
                          ),
                          const SizedBox(width: 10),
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

              SizedBox(height: 20),
              Text('Overview', style: kBodySmallTextStyle),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.deepPurple,
                      iconBackgroundColor: Colors.deepPurple.withValues(
                        alpha: 0.1,
                      ),
                      value: '${inventory.allProducts.length}',
                      label: 'Total Items',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.access_time,
                      iconColor: Colors.orange,
                      iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
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
                      iconColor: Colors.red,
                      iconBackgroundColor: Colors.red.withValues(alpha: 0.1),
                      value: '${inventory.expiredProducts.length}',
                      label: 'Expired',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: Colors.teal,
                      iconBackgroundColor: Colors.teal.withValues(alpha: 0.1),
                      value: '${analytics.todayItemsSold}',
                      label: 'Items Sold',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
