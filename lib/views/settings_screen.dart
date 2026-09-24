import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/auth/auth_state.dart';
import 'package:inventflow/view_model/settings_stuff/settings_prefs.dart';
import 'package:inventflow/view_model/settings_stuff/theme.dart';
import 'package:inventflow/widgets/containers/profile_header.dart';

import 'package:inventflow/widgets/buttons/logout_button.dart';
import 'package:inventflow/widgets/containers/settings_group.dart';
import 'package:inventflow/widgets/containers/theme_option_tile.dart';
import 'package:inventflow/widgets/content/settings_list_tile.dart';
import 'package:inventflow/widgets/content/settings_toggle_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final lowStockAlertsEnabled = ref.watch(lowStockAlertsEnabledProvider);
    final expiryRemindersEnabled = ref.watch(expiryRemindersEnabledProvider);

    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: kLargeTextStyle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              name: user?.displayName ?? 'Unknown user',
              email: user?.email ?? 'No email',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _sectionLabel(context, 'Appearance'),
            SettingsGroup(
              children: [
                ThemeOptionTile(
                  icon: Icons.light_mode_outlined,
                  label: 'Light',
                  isSelected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .select(ThemeMode.light),
                ),
                ThemeOptionTile(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark',
                  isSelected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .select(ThemeMode.dark),
                ),
                ThemeOptionTile(
                  icon: Icons.smartphone_outlined,
                  label: 'System default',
                  isSelected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .select(ThemeMode.system),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _sectionLabel(context, 'Preferences'),
            SettingsGroup(
              children: [
                SettingsToggleTile(
                  icon: Icons.notifications_outlined,
                  label: 'Low stock alerts',
                  value: lowStockAlertsEnabled,
                  onChanged: (value) {
                    ref
                        .read(lowStockAlertsEnabledProvider.notifier)
                        .toggle(value);
                  },
                ),
                SettingsToggleTile(
                  icon: Icons.access_time,
                  label: 'Expiry reminders',
                  value: expiryRemindersEnabled,
                  onChanged: (value) {
                    ref
                        .read(expiryRemindersEnabledProvider.notifier)
                        .toggle(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            _sectionLabel(context, 'Data'),
            SettingsGroup(
              children: [
                SettingsListTile(
                  icon: Icons.download_outlined,
                  label: 'Export inventory (CSV)',
                  onTap: () {},
                ),
                SettingsListTile(
                  icon: Icons.lock_outline,
                  label: 'Change password',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            _sectionLabel(context, 'About'),
            SettingsGroup(
              children: [
                SettingsListTile(
                  icon: Icons.help_outline,
                  label: 'Help and support',
                  onTap: () {},
                ),
                SettingsListTile(
                  icon: Icons.info_outline,
                  label: 'Version',
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            LogoutButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
