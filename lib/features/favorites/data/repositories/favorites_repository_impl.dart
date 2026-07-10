import 'package:hive/hive.dart';

import '../../domain/entities/favorite_entry.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._box);

  final Box<dynamic> _box;

  @override
  List<FavoriteEntry> getAll() {
    return _box.values
        .whereType<Map>()
        .map((raw) => FavoriteEntry.fromJson(Map<String, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  @override
  FavoriteEntry? getEntry(String masterId) {
    final raw = _box.get(masterId);
    if (raw is! Map) return null;
    return FavoriteEntry.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  bool isFavorite(String masterId) => _box.containsKey(masterId);

  @override
  Future<void> add(FavoriteEntry entry) => _box.put(entry.masterId, entry.toJson());

  @override
  Future<void> remove(String masterId) => _box.delete(masterId);

  @override
  Stream<List<FavoriteEntry>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }
}
