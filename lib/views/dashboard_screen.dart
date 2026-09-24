import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/auth/auth_state.dart';
import 'package:inventflow/view_model/sales_analytics.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/view_model/settings_stuff/settings_prefs.dart';
import 'package:inventflow/views/expiry_screen.dart';
import 'package:inventflow/views/inventory_screen.dart';
import 'package:inventflow/widgets/containers/alert_chip.dart';
import 'package:inventflow/widgets/containers/info_badge.dart';
import 'package:inventflow/widgets/containers/overview_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inventoryProvider);
    ref.watch(salesAnalyticsProvider);

    final lowStockAlertsEnabled = ref.watch(lowStockAlertsEnabledProvider);
    final user = ref.watch(authStateProvider).value;
    final inventory = ref.watch(inventoryProvider.notifier);
    final analytics = ref.watch(salesAnalyticsProvider.notifier);
    final expiryRemindersEnabled = ref.watch(expiryRemindersEnabledProvider);

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
      appBar: AppBar(title: Text(user?.displayName ?? 'Unknown user')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: kLargeTextStyle),
            const SizedBox(height: 20),

            Builder(
              builder: (context) {
                final chips = <Widget>[
                  if (inventory.expiredProducts.isNotEmpty)
                    AlertChip(
                      icon: Icons.info_outline,
                      label: '${inventory.expiredProducts.length} expired',
                      themeColor: colorScheme.error,
                      onTap: goToExpiry,
                    ),
                  if (expiryRemindersEnabled &&
                      inventory.nearExpiredProducts.isNotEmpty)
                    AlertChip(
                      icon: Icons.access_time,
                      label:
                          '${inventory.nearExpiredProducts.length} expiring soon',
                      themeColor: colorScheme.tertiary,
                      onTap: goToExpiry,
                    ),
                  if (lowStockAlertsEnabled &&
                      inventory.lowStockProducts.isNotEmpty)
                    AlertChip(
                      icon: Icons.inventory_2_outlined,
                      label: '${inventory.lowStockProducts.length} low stock',
                      themeColor: colorScheme.secondary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => InventoryScreen(),
                          ),
                        );
                      },
                    ),
                ];

                if (chips.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: chips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => chips[index],
                    ),
                  ),
                );
              },
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
