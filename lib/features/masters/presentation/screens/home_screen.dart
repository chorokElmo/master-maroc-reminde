import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/master.dart';
import '../providers/master_providers.dart';
import '../widgets/master_card.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(mastersProvider).isEmpty) {
        ref.read(mastersRefreshProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(masterStatisticsProvider);
    final closingSoon = ref.watch(closingSoonProvider);
    final newlyAdded = ref.watch(newlyAddedProvider);
    final recommended = ref.watch(recommendedProvider);
    final favorites = ref.watch(sortedFavoritesProvider);
    final upcomingDeadlines = ref.watch(upcomingDeadlinesProvider);
    final refreshStatus = ref.watch(mastersRefreshProvider);
    final favoriteIds = ref.watch(favoriteMasterIdsProvider);
    final controller = ref.read(favoritesControllerProvider);

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 18 ? 'Good afternoon' : 'Good evening');

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(mastersRefreshProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: context.colors.surface,
              title: Text(greeting, style: context.textStyles.titleMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => context.push(AppRoutes.search),
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded),
                  onPressed: () => context.push(AppRoutes.profile),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 8, context.horizontalPadding(), 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _StatsSummary(stats: stats),
                  const SizedBox(height: 20),
                  _QuickActions(),
                  const SizedBox(height: 24),
                  if (refreshStatus == RefreshStatus.error && stats.total == 0)
                    EmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Could not load programs',
                      message: 'Check your connection and pull down to try again.',
                    )
                  else if (stats.total == 0)
                    const _LoadingSection()
                  else ...[
                    if (closingSoon.isNotEmpty) ...[
                      SectionHeader(title: '🔥 Closing Soon', subtitle: '${closingSoon.length} programs'),
                      _HorizontalMasterList(masters: closingSoon, favoriteIds: favoriteIds, onToggle: controller.toggle),
                      const SizedBox(height: 24),
                    ],
                    if (newlyAdded.isNotEmpty) ...[
                      SectionHeader(title: '🆕 Newly Added'),
                      _HorizontalMasterList(masters: newlyAdded, favoriteIds: favoriteIds, onToggle: controller.toggle),
                      const SizedBox(height: 24),
                    ],
                    if (recommended.isNotEmpty) ...[
                      SectionHeader(title: '⭐ Recommended for you'),
                      _HorizontalMasterList(masters: recommended, favoriteIds: favoriteIds, onToggle: controller.toggle),
                      const SizedBox(height: 24),
                    ],
                    if (favorites.isNotEmpty) ...[
                      SectionHeader(
                        title: '❤️ Favorites',
                        trailing: TextButton(
                          onPressed: () => context.push(AppRoutes.saved),
                          child: const Text('See all'),
                        ),
                      ),
                      _HorizontalMasterList(masters: favorites.take(6).toList(), favoriteIds: favoriteIds, onToggle: controller.toggle),
                      const SizedBox(height: 24),
                    ],
                    if (upcomingDeadlines.isNotEmpty) ...[
                      const SectionHeader(title: '📅 Upcoming Deadlines'),
                      ...List.generate(upcomingDeadlines.length, (i) {
                        return FadeSlideIn(
                          index: i,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MasterCard(
                              master: upcomingDeadlines[i],
                              isGrid: false,
                              isFavorite: true,
                              onToggleFavorite: () => controller.toggle(upcomingDeadlines[i].id),
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({required this.stats});
  final MasterStatistics stats;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          _StatTile(label: 'Total', value: stats.total, icon: Icons.school_rounded),
          _StatTile(label: 'Open', value: stats.open, icon: Icons.lock_open_rounded),
          _StatTile(label: 'Closing Soon', value: stats.closingSoon, icon: Icons.timer_rounded),
          _StatTile(label: 'Closed', value: stats.closed, icon: Icons.lock_rounded),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon});
  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: context.colors.onSurface),
          const SizedBox(height: 6),
          Text('$value', style: context.textStyles.headlineSmall?.copyWith(color: context.colors.onSurface)),
          Text(label, style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.explore_rounded, 'Explore', AppRoutes.explore),
      (Icons.calendar_month_rounded, 'Calendar', AppRoutes.calendar),
      (Icons.folder_copy_rounded, 'Documents', AppRoutes.documents),
      (Icons.checklist_rounded, 'Tracker', AppRoutes.tracker),
    ];

    return SizedBox(
      height: 88,
      child: Row(
        children: actions.map((a) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Material(
                color: context.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.push(a.$3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(a.$1, color: context.colors.primary),
                        const SizedBox(height: 6),
                        Text(a.$2, style: context.textStyles.labelSmall, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HorizontalMasterList extends StatelessWidget {
  const _HorizontalMasterList({required this.masters, required this.favoriteIds, required this.onToggle});
  final List<Master> masters;
  final Set<String> favoriteIds;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: masters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final master = masters[i];
          return FadeSlideIn(
            index: i,
            child: SizedBox(
              width: 190,
              child: MasterCard(
                master: master,
                index: i,
                isFavorite: favoriteIds.contains(master.id),
                onToggleFavorite: () => onToggle(master.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Fetching the latest Master programs…', style: context.textStyles.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
