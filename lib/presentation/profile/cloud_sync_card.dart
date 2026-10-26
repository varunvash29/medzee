import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../services/sync/cloud_sync_controller.dart';
import '../../services/sync/cloud_sync_engine.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

/// Cloud sync controls: switch on, show the device-link code, join a vault.
class CloudSyncCard extends ConsumerWidget {
  const CloudSyncCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CloudSyncController sync = ref.watch(cloudSyncControllerProvider);
    final ThemeData theme = Theme.of(context);

    if (!sync.isAvailable) {
      return const AppCard(
        child: Text(
          'Cloud sync is not available on this build (no Firebase '
          'configuration for this platform).',
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          SwitchListTile(
            secondary: const Icon(Icons.cloud_sync_outlined),
            title: const Text('Sync to the cloud'),
            subtitle: Text(_statusText(sync)),
            value: sync.isEnabled,
            onChanged: (bool on) async {
              if (on) {
                await sync.enableNewVault();
              } else {
                await sync.disable();
              }
            },
          ),
          if (sync.isEnabled && sync.vaultId != null) ...<Widget>[
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: const Text('Link another device'),
              subtitle: const Text('Show the code to enter on the web or a '
                  'second phone'),
              onTap: () => _showCode(context, sync.vaultId!),
            ),
          ],
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.link_rounded),
            title: const Text('Join with a code'),
            subtitle: const Text(
              'Replace this person\'s data on this device with their synced '
              'data',
            ),
            onTap: () => showJoinVaultDialog(context, ref),
          ),
          if (sync.lastError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Text(
                sync.lastError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _statusText(CloudSyncController sync) {
    if (!sync.isEnabled) {
      return 'Off. Your data stays on this device only.';
    }
    return switch (sync.phase) {
      SyncPhase.off => 'Starting…',
      SyncPhase.connecting => 'Connecting…',
      SyncPhase.live => 'On. Changes sync automatically.',
      SyncPhase.error => 'Trouble syncing. Will retry when online.',
    };
  }

  void _showCode(BuildContext context, String code) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your sync code', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Anyone with this code can read and change this person\'s '
              'medicine data. Enter it on their other device under Profile → '
              'Join with a code. Everyone using Medzee has their own code. '
              'Do not share it.',
            ),
            const SizedBox(height: AppSpacing.lg),
            SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy code'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks for a sync code and joins that vault. Returns true when joined.
Future<bool> showJoinVaultDialog(BuildContext context, WidgetRef ref) async {
  final TextEditingController controller = TextEditingController();
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: const Text('Join with a code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'This person\'s medicines and history on this device will be '
            'replaced by the synced copy.',
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Sync code'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Join'),
        ),
      ],
    ),
  );
  final String code = controller.text;
  controller.dispose();
  if (confirmed != true) return false;
  return ref.read(cloudSyncControllerProvider).joinVault(code);
}
