import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../masters/presentation/widgets/master_card.dart';
import '../providers/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(sortedFavoritesProvider);
    final favoriteIds = ref.watch(favoriteMasterIdsProvider);
    final sort = ref.watch(favoritesSortProvider);
    final controller = ref.read(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        actions: [
          PopupMenuButton<FavoritesSort>(
            icon: const Icon(Icons.sort_rounded),
            initialValue: sort,
            onSelected: (value) => ref.read(favoritesSortProvider.notifier).state = value,
            itemBuilder: (context) => const [
              PopupMenuItem(value: FavoritesSort.deadline, child: Text('Sort by deadline')),
              PopupMenuItem(value: FavoritesSort.university, child: Text('Sort by university')),
              PopupMenuItem(value: FavoritesSort.city, child: Text('Sort by city')),
              PopupMenuItem(value: FavoritesSort.recentlyAdded, child: Text('Recently added')),
            ],
          ),
        ],
      ),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.bookmark_border_rounded,
              title: 'No saved programs yet',
              message: 'Tap the heart on any Master to save it here and get deadline reminders.',
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 12, context.horizontalPadding(), 40),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final master = favorites[i];
                return FadeSlideIn(
                  index: i,
                  child: MasterCard(
                    master: master,
                    isGrid: false,
                    isFavorite: favoriteIds.contains(master.id),
                    onToggleFavorite: () => controller.toggle(master.id),
                  ),
                );
              },
            ),
    );
  }
}
