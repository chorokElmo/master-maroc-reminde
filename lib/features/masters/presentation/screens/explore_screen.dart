import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../providers/master_providers.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/master_card.dart';

final _isGridViewProvider = StateProvider<bool>((ref) => true);

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(exploreResultsProvider);
    final isGrid = ref.watch(_isGridViewProvider);
    final filters = ref.watch(masterFiltersProvider);
    final favoriteIds = ref.watch(favoriteMasterIdsProvider);
    final controller = ref.read(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => ref.read(_isGridViewProvider.notifier).state = !isGrid,
          ),
          IconButton(
            icon: Badge(isLabelVisible: !filters.isEmpty, child: const Icon(Icons.tune_rounded)),
            onPressed: () => showMasterFilterSheet(context),
          ),
        ],
      ),
      body: results.isEmpty
          ? const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No programs match',
              message: 'Try adjusting or clearing your filters.',
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding(), vertical: 12),
              child: isGrid
                  ? GridView.builder(
                      itemCount: results.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.gridColumns(),
                        childAspectRatio: 0.66,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, i) {
                        final master = results[i];
                        return FadeSlideIn(
                          index: i,
                          child: MasterCard(
                            master: master,
                            index: i,
                            isFavorite: favoriteIds.contains(master.id),
                            onToggleFavorite: () => controller.toggle(master.id),
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final master = results[i];
                        return FadeSlideIn(
                          index: i,
                          child: MasterCard(
                            master: master,
                            isGrid: false,
                            index: i,
                            isFavorite: favoriteIds.contains(master.id),
                            onToggleFavorite: () => controller.toggle(master.id),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
