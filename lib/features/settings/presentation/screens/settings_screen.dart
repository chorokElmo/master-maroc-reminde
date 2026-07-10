import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../services/backup_service.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../profile/presentation/providers/preferences_providers.dart';
import '../../../tracker/presentation/providers/tracker_providers.dart';
import '../providers/settings_providers.dart';

Future<void> _runWithLoading(
  BuildContext context, {
  required String loadingMessage,
  required Future<void> Function() action,
  String? successMessage,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Padding(padding: const EdgeInsets.all(24), child: LoadingState(message: loadingMessage)),
    ),
  );

  try {
    await action();
    if (context.mounted) Navigator.of(context).pop();
    if (successMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
    }
  } catch (e) {
    if (context.mounted) Navigator.of(context).pop();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final dynamicColor = ref.watch(dynamicColorEnabledProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: context.horizontalPadding()),
        children: [
          _SectionCard(
            title: 'Appearance',
            children: [
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_rounded), label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_rounded), label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_rounded), label: Text('Dark')),
                ],
                selected: {themeMode},
                onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dynamic color'),
                subtitle: const Text('Match your device\'s wallpaper theme (Android 12+)'),
                value: dynamicColor,
                onChanged: (v) => ref.read(dynamicColorEnabledProvider.notifier).set(v),
              ),
            ],
          ),
          _SectionCard(
            title: 'Notifications',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable notifications'),
                subtitle: const Text('Get reminded before your saved deadlines'),
                value: notificationsEnabled,
                onChanged: (v) async {
                  ref.read(notificationsEnabledProvider.notifier).set(v);
                  if (v) await ref.read(notificationServiceProvider).requestPermissions();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Send a test notification'),
                onTap: () => ref.read(notificationServiceProvider).showImmediate(
                      id: 999999,
                      title: 'Master Maroc Reminder',
                      body: 'Notifications are working correctly.',
                    ),
              ),
            ],
          ),
          _SectionCard(
            title: 'Language',
            children: [
              DropdownButtonFormField<Locale>(
                value: locale,
                items: supportedLocales
                    .map((l) => DropdownMenuItem(value: l, child: Text(localeNames[l.languageCode]!)))
                    .toList(),
                onChanged: (l) {
                  if (l != null) ref.read(localeProvider.notifier).set(l);
                },
              ),
            ],
          ),
          _SectionCard(
            title: 'Data',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Backup my data'),
                subtitle: const Text('Favorites, application progress & preferences'),
                onTap: () => _runWithLoading(
                  context,
                  loadingMessage: 'Preparing backup…',
                  action: () async {
                    final payload = BackupPayload(
                      favorites: ref.read(favoritesProvider),
                      progress: ref.read(trackerControllerProvider),
                      preferences: ref.read(preferencesProvider),
                    );
                    await ref.read(backupServiceProvider).exportAndShare(payload);
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cloud_download_outlined),
                title: const Text('Restore from backup'),
                onTap: () async {
                  final payload = await ref.read(backupServiceProvider).pickAndImport();
                  if (payload == null || !context.mounted) return;
                  await _runWithLoading(
                    context,
                    loadingMessage: 'Restoring…',
                    action: () async {
                      for (final favorite in payload.favorites) {
                        await ref.read(favoritesRepositoryProvider).add(favorite);
                      }
                      for (final progress in payload.progress) {
                        await ref
                            .read(trackerRepositoryProvider)
                            .setStatus(progress.masterId, progress.status, notes: progress.notes);
                      }
                      await ref.read(preferencesControllerProvider.notifier).update(payload.preferences);
                    },
                    successMessage: 'Restored ${payload.favorites.length} saved programs',
                  );
                },
              ),
            ],
          ),
          _SectionCard(
            title: 'Privacy',
            children: [
              Text(
                'Master Maroc Reminder stores your favorites, documents and preferences locally on '
                'your device. Program listings are fetched from public university announcement sites; '
                'nothing you save is uploaded anywhere unless you explicitly sign in.',
                style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('View full privacy policy'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(AppRoutes.privacyPolicy),
              ),
            ],
          ),
          _SectionCard(
            title: 'About',
            children: [
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.data?.version ?? '1.0.0';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('Master Maroc Reminder'),
                    subtitle: Text('Version $version'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textStyles.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
