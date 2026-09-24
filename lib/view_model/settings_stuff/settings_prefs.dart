import 'package:flutter_riverpod/flutter_riverpod.dart';

final lowStockAlertsEnabledProvider =
    NotifierProvider<LowStockAlertsNotifier, bool>(LowStockAlertsNotifier.new);

class LowStockAlertsNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true; // enabled by default
  }

  void toggle(bool value) {
    state = value;
  }
}

final expiryRemindersEnabledProvider =
    NotifierProvider<ExpiryRemindersNotifier, bool>(
      ExpiryRemindersNotifier.new,
    );

class ExpiryRemindersNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle(bool value) {
    state = value;
  }
}
