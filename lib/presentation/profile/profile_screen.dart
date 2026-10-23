import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/user_profile.dart';
import '../../state/profile_providers.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

/// Settings and account: appearance, notifications, privacy, data and about.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final UserProfile profile = ref.watch(activeProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.huge,
          ),
          children: <Widget>[
            Text('You', style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            _ProfileCard(profile: profile),
            const SectionHeader(title: 'Appearance'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.brightness_6_outlined),
                    title: const Text('Theme'),
                    subtitle: Text(profile.themeMode.label),
                    onTap: () => _pickThemeMode(context, ref, profile),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.text_fields_outlined),
                    title: const Text('Text size'),
                    subtitle: Text('${(profile.textScale * 100).round()}%'),
                    onTap: () => _pickTextScale(context, ref, profile),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Reminders'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Reminders'),
                    subtitle: const Text('Master switch for every dose alert'),
                    value: profile.notificationsEnabled,
                    onChanged: (bool value) => ref
                        .read(profileControllerProvider)
                        .update((UserProfile p) =>
                            p.copyWith(notificationsEnabled: value)),
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const Icon(Icons.timer_outlined),
                    title: const Text('Early nudge'),
                    subtitle: Text(profile.preReminderMinutes == null
                        ? 'Off'
                        : '${profile.preReminderMinutes} minutes before'),
                    value: profile.preReminderMinutes != null,
                    onChanged: (bool value) => ref
                        .read(profileControllerProvider)
                        .update((UserProfile p) => p.copyWith(
                              preReminderMinutes: value ? 10 : null,
                              clearPreReminderMinutes: !value,
                            )),
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const Icon(Icons.nightlight_outlined),
                    title: const Text('Quiet hours'),
                    subtitle: Text(
                      '${_minutesLabel(profile.quietHoursStartMinutes)} – '
                      '${_minutesLabel(profile.quietHoursEndMinutes)}',
                    ),
                    value: profile.quietHoursEnabled,
                    onChanged: (bool value) => ref
                        .read(profileControllerProvider)
                        .update((UserProfile p) =>
                            p.copyWith(quietHoursEnabled: value)),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.visibility_outlined),
                    title: const Text('Notification privacy'),
                    subtitle: Text(profile.notificationPrivacy == NotificationPrivacy.detailed
                        ? 'Shows medicine name and dose'
                        : 'Shows "Time for your medicine" only'),
                    onTap: () => _pickPrivacy(context, ref, profile),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'Privacy & data'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    secondary: const Icon(Icons.lock_outline_rounded),
                    title: const Text('App lock'),
                    subtitle: const Text(
                      'Require device authentication when opening Medzee',
                    ),
                    value: profile.appLockEnabled,
                    onChanged: (bool value) => ref
                        .read(profileControllerProvider)
                        .update((UserProfile p) =>
                            p.copyWith(appLockEnabled: value)),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.download_outlined),
                    title: const Text('Export my data'),
                    subtitle: const Text(
                      'Save a readable copy of everything Medzee stores',
                    ),
                    onTap: () => _showExportSheet(context),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_outlined),
                    title: Text(
                      'Delete all data',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    subtitle: const Text(
                      'Removes medicines, history and settings from this device',
                    ),
                    onTap: () => _confirmWipe(context, ref),
                  ),
                ],
              ),
            ),
            const SectionHeader(title: 'About'),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _AboutRow(
                    label: 'Version',
                    value: '1.0.0 (local build)',
                  ),
                  _AboutRow(
                    label: 'Storage',
                    value: 'On-device SQLite. Nothing is uploaded.',
                  ),
                  _AboutRow(
                    label: 'Medicine data',
                    value:
                        'openFDA (openFDA is a public US FDA dataset). Attributed '
                        'and dated wherever it is shown.',
                  ),
                  _AboutRow(
                    label: 'Medical advice',
                    value:
                        'Medzee does not prescribe, diagnose or recommend '
                        'substitutes. Source your decisions from a qualified '
                        'professional.',
                  ),
                ],
              ),
            ),
            if (kDebugMode) ...<Widget>[
              const SectionHeader(title: 'Developer'),
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.vpn_key_outlined),
                  title: const Text('Copy FCM token'),
                  subtitle: Text(
                    ref.watch(firebaseGatewayProvider).isAvailable
                        ? 'Debug only — paste into the Firebase console to '
                            'send a test message'
                        : 'Firebase is not configured on this build',
                  ),
                  enabled: ref.watch(firebaseGatewayProvider).isAvailable,
                  onTap: () => _copyFcmToken(context, ref),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            const InfoBanner(
              icon: Icons.emoji_objects_outlined,
              message:
                  'If a reminder did not fire, check that notifications and '
                  'exact alarms are allowed for Medzee in system settings. '
                  'Medzee reconciles its reminders every time it opens.',
            ),
          ],
        ),
      ),
    );
  }

  String _minutesLabel(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickThemeMode(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    final AppThemeMode? picked = await showDialog<AppThemeMode>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Theme'),
        children: <Widget>[
          for (final AppThemeMode mode in AppThemeMode.values)
            RadioListTile<AppThemeMode>(
              title: Text(mode.label),
              value: mode,
              groupValue: profile.themeMode,
              onChanged: (AppThemeMode? value) =>
                  Navigator.of(context).pop(value),
            ),
        ],
      ),
    );
    if (picked == null) return;
    await ref
        .read(profileControllerProvider)
        .update((UserProfile p) => p.copyWith(themeMode: picked));
  }

  Future<void> _pickTextScale(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    final double? picked = await showDialog<double>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Text size'),
        children: <Widget>[
          for (final double scale in const <double>[0.9, 1.0, 1.15, 1.3, 1.5])
            RadioListTile<double>(
              title: Text('${(scale * 100).round()}%'),
              value: scale,
              groupValue: profile.textScale,
              onChanged: (double? value) => Navigator.of(context).pop(value),
            ),
        ],
      ),
    );
    if (picked == null) return;
    await ref
        .read(profileControllerProvider)
        .update((UserProfile p) => p.copyWith(textScale: picked));
  }

  Future<void> _pickPrivacy(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    final NotificationPrivacy? picked =
        await showDialog<NotificationPrivacy>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Notification privacy'),
        children: <Widget>[
          for (final NotificationPrivacy privacy
              in NotificationPrivacy.values)
            RadioListTile<NotificationPrivacy>(
              title: Text(privacy == NotificationPrivacy.detailed
                  ? 'Detailed — medicine name and dose'
                  : 'Private — "Time for your medicine"'),
              value: privacy,
              groupValue: profile.notificationPrivacy,
              onChanged: (NotificationPrivacy? value) =>
                  Navigator.of(context).pop(value),
            ),
        ],
      ),
    );
    if (picked == null) return;
    await ref
        .read(profileControllerProvider)
        .update((UserProfile p) => p.copyWith(notificationPrivacy: picked));
  }

  void _showExportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => const Padding(
        padding: EdgeInsets.all(AppSpacing.gutter),
        child: InfoBanner(
          icon: Icons.info_outline_rounded,
          message:
              'Export arrives with the backup module. Until then your data '
              'is already readable: Medzee stores it in a standard SQLite '
              'file you can open with any database tool.',
        ),
      ),
    );
  }

  Future<void> _copyFcmToken(BuildContext context, WidgetRef ref) async {
    final String? token =
        await ref.read(pushServiceProvider).debugRegistrationToken();
    if (!context.mounted) return;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No FCM token — check the Firebase configuration.'),
        ),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: token));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FCM token copied to clipboard.')),
    );
  }

  Future<void> _confirmWipe(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete all data?'),
        content: const Text(
          'Every medicine, dose record, stock movement and setting is removed '
          'from this device. This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final dynamic db = ref.read(appDatabaseProvider);
    await db.delete(db.userProfiles).go();
    await db.delete(db.medications).go();
    await db.delete(db.doseLogs).go();
    await db.delete(db.scheduledDoses).go();
    await db.delete(db.schedulePhases).go();
    await db.delete(db.inventories).go();
    await db.delete(db.inventoryTransactions).go();
    await db.delete(db.notificationSchedules).go();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data deleted.')),
      );
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final String name = profile.displayName?.trim() ?? '';

    return AppCard(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              name.isEmpty ? '🙂' : name.characters.first.toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name.isEmpty ? 'Local user' : name,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  profile.demoMode ? 'Demo data loaded' : 'Stored on this device',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (profile.onboardingCompleted)
            StatusChip(
              label: 'Set up',
              color: status.taken,
              containerColor: status.takenContainer,
              icon: Icons.check_rounded,
            ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
