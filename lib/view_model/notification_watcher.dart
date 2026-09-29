import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/services/notification_service.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/view_model/settings_stuff/settings_prefs.dart';

abstract class NotificationIds {
  static const expirySoon = 1;
  static const lowStock = 2;
  // add more here as you introduce new alert types
}

final notificationWatcherProvider = Provider<void>((ref) {
  final products = ref.watch(inventoryProvider);
  final expiryRemindersEnabled = ref.watch(expiryRemindersEnabledProvider);
  final lowStockAlertsEnabled = ref.watch(lowStockAlertsEnabledProvider);
  final inventory = ref.watch(inventoryProvider.notifier);

  if (expiryRemindersEnabled && inventory.nearExpiredProducts.isNotEmpty) {
    NotificationService.show(
      id: NotificationIds.expirySoon,
      title: 'Items expiring soon',
      body:
          '${inventory.nearExpiredProducts.length} item(s) expiring within 7 days.',
    );
  }

  if (lowStockAlertsEnabled && inventory.lowStockProducts.isNotEmpty) {
    NotificationService.show(
      id: NotificationIds.lowStock,
      title: 'Low stock',
      body: '${inventory.lowStockProducts.length} item(s) running low.',
    );
  }
});
