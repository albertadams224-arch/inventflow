import 'package:flutter/material.dart';
import 'package:inventflow/widgets/containers/alert_banner.dart';
import 'package:inventflow/widgets/containers/info_badge.dart';
import 'package:inventflow/widgets/containers/overview_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int expiredItemsCount = 1;
  int expiringSoonCount = 2;

  void expireDismissed() {
    setState(() {
      expiredItemsCount = expiredItemsCount - 1;
    });
  }

  void nearDismissed() {
    setState(() {
      expiringSoonCount = expiringSoonCount - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
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

              if (expiredItemsCount > 0)
                AlertBanner(
                  message: '$expiredItemsCount item has EXPIRED! Remove it.',
                  icon: Icons.info_outline,
                  themeColor: Colors.red.shade700,
                  onDismissed: expireDismissed,
                  key: UniqueKey(),
                ),

              if (expiringSoonCount > 0)
                AlertBanner(
                  message: '$expiringSoonCount items expiring within 7 days.',
                  icon: Icons.access_time,
                  themeColor: Colors.orange.shade800,
                  onDismissed: nearDismissed,
                  key: UniqueKey(),
                ),
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
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
                          'GH₵ 57.00',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
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
                              title: '2 Sales Today',
                            ),
                            const SizedBox(width: 10),
                            InfoBadge(
                              icon: Icons.trending_up,
                              title: 'GH₵ 28 Profit',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Overview',
                style: kBodySmallTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              SizedBox(height: 10),
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.deepPurple,
                      iconBackgroundColor: Colors.deepPurple.withValues(
                        alpha: 0.1,
                      ),
                      value: '87',
                      label: 'Total Items',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.credit_card,
                      iconColor: Colors.teal,
                      iconBackgroundColor: Colors.teal.withValues(alpha: 0.1),
                      value: 'GH₵ 782',
                      label: 'Stock Value',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.access_time,
                      iconColor: Colors.orange,
                      iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                      value: '2',
                      label: 'Near Expiry',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.cancel_outlined,
                      iconColor: Colors.red,
                      iconBackgroundColor: Colors.red.withValues(alpha: 0.1),
                      value: '1',
                      label: 'Expired',
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
