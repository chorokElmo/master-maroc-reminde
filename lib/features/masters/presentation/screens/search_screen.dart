import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../providers/master_providers.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/master_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final filters = ref.watch(masterFiltersProvider);
    final favoriteIds = ref.watch(favoriteMasterIdsProvider);
    final controller = ref.read(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by university, city, specialization…',
            border: InputBorder.none,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
        ),
        actions: [
          IconButton(
            icon: Badge(isLabelVisible: !filters.isEmpty, child: const Icon(Icons.tune_rounded)),
            onPressed: () => showMasterFilterSheet(context),
          ),
        ],
      ),
      body: results.isEmpty
          ? const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No matches',
              message: 'Try a different keyword or adjust your filters.',
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 12, context.horizontalPadding(), 40),
              itemCount: results.length,
              itemBuilder: (context, i) {
                final master = results[i];
                return FadeSlideIn(
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MasterCard(
                      master: master,
                      isGrid: false,
                      isFavorite: favoriteIds.contains(master.id),
                      onToggleFavorite: () => controller.toggle(master.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
