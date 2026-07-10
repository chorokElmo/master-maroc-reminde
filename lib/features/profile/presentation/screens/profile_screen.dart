import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/preferences_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authRepositoryProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final prefs = ref.watch(preferencesControllerProvider);
    final prefsController = ref.read(preferencesControllerProvider.notifier);
    final reference = ref.watch(academicReferenceDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding(), vertical: 12),
        children: [
          _ProfileHeader(user: user, isConfigured: auth.isConfigured),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Preferred Cities',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reference.cities.map((city) {
                  return FilterChip(
                    label: Text(city),
                    selected: prefs.preferredCities.contains(city),
                    onSelected: (_) => prefsController.toggleCity(city),
                  );
                }).toList(),
              ),
            ],
          ),
          _SectionCard(
            title: 'Preferred Universities',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reference.universityNames.map((u) {
                  return FilterChip(
                    label: Text(u, overflow: TextOverflow.ellipsis),
                    selected: prefs.preferredUniversities.contains(u),
                    onSelected: (_) => prefsController.toggleUniversity(u),
                  );
                }).toList(),
              ),
            ],
          ),
          _SectionCard(
            title: 'Preferred Domains',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reference.specializations.map((spec) {
                  return FilterChip(
                    label: Text(spec.label),
                    selected: prefs.preferredDomains.contains(spec.id),
                    onSelected: (_) => prefsController.toggleDomain(spec.id),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({required this.user, required this.isConfigured});

  final AppUser? user;
  final bool isConfigured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = user;
    final signedIn = currentUser != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: context.colors.primary.softer,
            child: Icon(Icons.person_rounded, color: context.colors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signedIn ? (currentUser.displayName ?? currentUser.email ?? 'Student') : 'Guest',
                  style: context.textStyles.titleMedium,
                ),
                Text(
                  signedIn ? (currentUser.email ?? '') : 'Browsing without an account',
                  style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (signedIn)
            TextButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: const Text('Sign out'),
            )
          else
            FilledButton.tonal(
              onPressed: () => context.push(AppRoutes.auth),
              child: const Text('Sign in'),
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
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
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
