import '../entities/favorite_entry.dart';

abstract class FavoritesRepository {
  List<FavoriteEntry> getAll();

  FavoriteEntry? getEntry(String masterId);

  bool isFavorite(String masterId);

  Future<void> add(FavoriteEntry entry);

  Future<void> remove(String masterId);

  Stream<List<FavoriteEntry>> watchAll();
}
