import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../profile/presentation/providers/preferences_providers.dart';
import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';

/// Live view of the local cache — updates instantly as favorites/refresh
/// write through it, independent of network state.
final mastersStreamProvider = StreamProvider<List<Master>>((ref) {
  return ref.watch(masterRepositoryProvider).watchAll();
});

final mastersProvider = Provider<List<Master>>((ref) {
  return ref.watch(mastersStreamProvider).valueOrNull ?? ref.watch(masterRepositoryProvider).getCached();
});

enum RefreshStatus { idle, loading, error }

class MastersRefreshController extends StateNotifier<RefreshStatus> {
  MastersRefreshController(this._ref) : super(RefreshStatus.idle);

  final Ref _ref;

  Future<void> refresh() async {
    state = RefreshStatus.loading;
    try {
      await _ref.read(masterRepositoryProvider).refresh();
      state = RefreshStatus.idle;
    } catch (_) {
      state = RefreshStatus.error;
    }
  }
}

final mastersRefreshProvider =
    StateNotifierProvider<MastersRefreshController, RefreshStatus>((ref) {
  return MastersRefreshController(ref);
});

final masterByIdProvider = Provider.family<Master?, String>((ref, id) {
  final all = ref.watch(mastersProvider);
  for (final m in all) {
    if (m.id == id) return m;
  }
  return null;
});

final closingSoonProvider = Provider<List<Master>>((ref) {
  final list = ref
      .watch(mastersProvider)
      .where((m) => m.status == MasterListingStatus.closingSoon)
      .toList()
    ..sort((a, b) => a.applicationDeadline!.compareTo(b.applicationDeadline!));
  return list;
});

final newlyAddedProvider = Provider<List<Master>>((ref) {
  final list = List<Master>.from(ref.watch(mastersProvider))
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list.take(10).toList();
});

final openProvider = Provider<List<Master>>((ref) {
  return ref.watch(mastersProvider).where((m) => m.status == MasterListingStatus.open).toList();
});

/// Favorited master ids, computed directly from [favoritesRepositoryProvider]
/// rather than importing `favorites_providers.dart` — that file already
/// imports this one (for [mastersProvider]), and Dart doesn't allow that
/// import cycle.
final _favoriteMasterIdsProvider = StreamProvider<Set<String>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.watchAll().map((entries) => entries.map((e) => e.masterId).toSet());
});

/// Ranks listings by how many of the student's saved preferences (cities,
/// universities, domains) they match — a simple, explainable stand-in for
/// full collaborative-filtering "AI recommendations": it directly reflects
/// what the student told the app they care about, plus what they've
/// favorited so far.
final recommendedProvider = Provider<List<Master>>((ref) {
  final prefs = ref.watch(preferencesProvider);
  final favorites = ref.watch(_favoriteMasterIdsProvider).valueOrNull ?? const {};
  final all = ref.watch(mastersProvider).where((m) => m.status != MasterListingStatus.closed);

  int score(Master m) {
    var s = 0;
    if (m.city != null && prefs.preferredCities.contains(m.city)) s += 2;
    if (m.university != null && prefs.preferredUniversities.contains(m.university)) s += 2;
    if (m.specialization != null && prefs.preferredDomains.contains(m.specialization)) s += 3;
    if (favorites.isNotEmpty) {
      final favoriteMasters = ref.watch(mastersProvider).where((fm) => favorites.contains(fm.id));
      if (favoriteMasters.any((fm) => fm.specialization == m.specialization && fm.specialization != null)) {
        s += 1;
      }
    }
    return s;
  }

  final ranked = all.map((m) => (m, score(m))).where((e) => e.$2 > 0).toList()
    ..sort((a, b) => b.$2.compareTo(a.$2));
  return ranked.map((e) => e.$1).take(10).toList();
});

final upcomingDeadlinesProvider = Provider<List<Master>>((ref) {
  final favoriteIds = ref.watch(_favoriteMasterIdsProvider).valueOrNull ?? const {};
  final list = ref
      .watch(mastersProvider)
      .where((m) => favoriteIds.contains(m.id) && m.applicationDeadline != null && !AppDateUtils.isPast(m.applicationDeadline!))
      .toList()
    ..sort((a, b) => a.applicationDeadline!.compareTo(b.applicationDeadline!));
  return list;
});

class MasterStatistics {
  const MasterStatistics({required this.total, required this.open, required this.closingSoon, required this.closed});
  final int total;
  final int open;
  final int closingSoon;
  final int closed;
}

final masterStatisticsProvider = Provider<MasterStatistics>((ref) {
  final all = ref.watch(mastersProvider);
  return MasterStatistics(
    total: all.length,
    open: all.where((m) => m.status == MasterListingStatus.open).length,
    closingSoon: all.where((m) => m.status == MasterListingStatus.closingSoon).length,
    closed: all.where((m) => m.status == MasterListingStatus.closed).length,
  );
});

/// ---- Search & filters ----

class MasterFilters {
  const MasterFilters({
    this.city,
    this.university,
    this.specialization,
    this.status,
    this.deadlineWithinDays,
  });

  final String? city;
  final String? university;
  final String? specialization;
  final MasterListingStatus? status;
  final int? deadlineWithinDays;

  bool get isEmpty =>
      city == null && university == null && specialization == null && status == null && deadlineWithinDays == null;

  MasterFilters copyWith({
    String? city,
    bool clearCity = false,
    String? university,
    bool clearUniversity = false,
    String? specialization,
    bool clearSpecialization = false,
    MasterListingStatus? status,
    bool clearStatus = false,
    int? deadlineWithinDays,
    bool clearDeadline = false,
  }) {
    return MasterFilters(
      city: clearCity ? null : (city ?? this.city),
      university: clearUniversity ? null : (university ?? this.university),
      specialization: clearSpecialization ? null : (specialization ?? this.specialization),
      status: clearStatus ? null : (status ?? this.status),
      deadlineWithinDays: clearDeadline ? null : (deadlineWithinDays ?? this.deadlineWithinDays),
    );
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');
final masterFiltersProvider = StateProvider<MasterFilters>((ref) => const MasterFilters());

List<Master> _applyFilters(List<Master> input, MasterFilters filters) {
  var results = input;
  if (filters.city != null) {
    results = results.where((m) => m.city == filters.city).toList();
  }
  if (filters.university != null) {
    results = results.where((m) => m.university == filters.university).toList();
  }
  if (filters.specialization != null) {
    results = results.where((m) => m.specialization == filters.specialization).toList();
  }
  if (filters.status != null) {
    results = results.where((m) => m.status == filters.status).toList();
  }
  if (filters.deadlineWithinDays != null) {
    results = results.where((m) {
      final deadline = m.applicationDeadline;
      if (deadline == null) return false;
      final days = AppDateUtils.daysUntil(deadline);
      return days >= 0 && days <= filters.deadlineWithinDays!;
    }).toList();
  }
  return results;
}

final searchResultsProvider = Provider<List<Master>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final filters = ref.watch(masterFiltersProvider);
  var results = ref.watch(mastersProvider);

  if (query.isNotEmpty) {
    results = results.where((m) {
      return m.title.toLowerCase().contains(query) ||
          (m.university?.toLowerCase().contains(query) ?? false) ||
          (m.faculty?.toLowerCase().contains(query) ?? false) ||
          (m.city?.toLowerCase().contains(query) ?? false) ||
          m.description.toLowerCase().contains(query);
    }).toList();
  }

  return _applyFilters(results, filters);
});

/// Explore applies the same [masterFiltersProvider] filters as Search but
/// without the free-text query, so filter choices persist across both
/// screens while each keeps its own notion of "results".
final exploreResultsProvider = Provider<List<Master>>((ref) {
  return _applyFilters(ref.watch(mastersProvider), ref.watch(masterFiltersProvider));
});

/// ---- Recently viewed ----

class RecentlyViewedController extends StateNotifier<List<String>> {
  RecentlyViewedController(this._ref) : super(_load(_ref)) {
    _persist();
  }

  final Ref _ref;
  static const _key = 'recently_viewed_master_ids';
  static const _maxEntries = 20;

  static List<String> _load(Ref ref) {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return const [];
    }
  }

  void markViewed(String masterId) {
    final updated = [masterId, ...state.where((id) => id != masterId)];
    state = updated.take(_maxEntries).toList();
    _persist();
  }

  void _persist() {
    _ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(state));
  }
}

final recentlyViewedIdsProvider =
    StateNotifierProvider<RecentlyViewedController, List<String>>((ref) {
  return RecentlyViewedController(ref);
});

final recentlyViewedProvider = Provider<List<Master>>((ref) {
  final ids = ref.watch(recentlyViewedIdsProvider);
  final all = ref.watch(mastersProvider);
  return [
    for (final id in ids)
      if (all.where((m) => m.id == id).isNotEmpty) all.firstWhere((m) => m.id == id),
  ];
});
