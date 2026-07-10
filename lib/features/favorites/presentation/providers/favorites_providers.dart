import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../masters/presentation/providers/master_providers.dart';
import '../../../tracker/domain/entities/application_status.dart';
import '../../domain/entities/favorite_entry.dart';

final favoritesStreamProvider = StreamProvider<List<FavoriteEntry>>((ref) {
  return ref.watch(favoritesRepositoryProvider).watchAll();
});

final favoritesProvider = Provider<List<FavoriteEntry>>((ref) {
  return ref.watch(favoritesStreamProvider).valueOrNull ?? ref.watch(favoritesRepositoryProvider).getAll();
});

final favoriteMasterIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(favoritesProvider).map((f) => f.masterId).toSet();
});

final isFavoriteProvider = Provider.family<bool, String>((ref, masterId) {
  return ref.watch(favoriteMasterIdsProvider).contains(masterId);
});

/// Favorited Masters with their [FavoriteEntry], sorted per the Favorites
/// screen's chosen sort order.
enum FavoritesSort { deadline, university, city, recentlyAdded }

final favoritesSortProvider = StateProvider<FavoritesSort>((ref) => FavoritesSort.deadline);

final sortedFavoritesProvider = Provider((ref) {
  final entries = ref.watch(favoritesProvider);
  final all = ref.watch(mastersProvider);
  final sort = ref.watch(favoritesSortProvider);

  final pairs = [
    for (final entry in entries)
      if (all.where((m) => m.id == entry.masterId).isNotEmpty)
        (all.firstWhere((m) => m.id == entry.masterId), entry),
  ];

  switch (sort) {
    case FavoritesSort.deadline:
      pairs.sort((a, b) {
        final ad = a.$1.applicationDeadline;
        final bd = b.$1.applicationDeadline;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
      break;
    case FavoritesSort.university:
      pairs.sort((a, b) => (a.$1.university ?? '').compareTo(b.$1.university ?? ''));
      break;
    case FavoritesSort.city:
      pairs.sort((a, b) => (a.$1.city ?? '').compareTo(b.$1.city ?? ''));
      break;
    case FavoritesSort.recentlyAdded:
      pairs.sort((a, b) => b.$2.addedAt.compareTo(a.$2.addedAt));
      break;
  }

  return pairs.map((p) => p.$1).toList();
});

/// Orchestrates favoriting: looks up the Master, schedules/cancels its
/// deadline reminder ladder via [NotificationService], and persists the
/// [FavoriteEntry] — this is the "business logic" the UI layer never
/// touches directly.
class FavoritesController {
  FavoritesController(this._ref);

  final Ref _ref;

  Future<void> toggle(String masterId) async {
    final repo = _ref.read(favoritesRepositoryProvider);
    final existing = repo.getEntry(masterId);

    if (existing != null) {
      await _ref.read(notificationServiceProvider).cancelMany(existing.notificationIds);
      await repo.remove(masterId);
      return;
    }

    final master = _ref.read(masterByIdProvider(masterId));
    var notificationIds = <int>[];
    if (master != null) {
      notificationIds = await _ref.read(notificationServiceProvider).scheduleForMaster(master);
    }

    await repo.add(FavoriteEntry(
      masterId: masterId,
      addedAt: DateTime.now(),
      notificationIds: notificationIds,
    ));

    // Saving a Master implicitly starts tracking it as "Interested" unless
    // the student has already set a status for it.
    final tracker = _ref.read(trackerRepositoryProvider);
    if (tracker.getFor(masterId) == null) {
      await tracker.setStatus(masterId, ApplicationStatus.interested);
    }
  }

  Future<void> updateReminderInterval(String masterId, List<int> daysBefore) async {
    final repo = _ref.read(favoritesRepositoryProvider);
    final existing = repo.getEntry(masterId);
    if (existing == null) return;

    final master = _ref.read(masterByIdProvider(masterId));
    if (master == null) return;

    final newIds = await _ref.read(notificationServiceProvider).scheduleForMaster(
          master,
          existingIds: existing.notificationIds,
          daysBefore: daysBefore,
        );

    await repo.add(existing.copyWith(notificationIds: newIds, customReminderDaysBefore: daysBefore));
  }
}

final favoritesControllerProvider = Provider((ref) => FavoritesController(ref));
