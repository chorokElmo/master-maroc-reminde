import '../entities/master.dart';

/// Offline-first access to Master's program listings. Implementations
/// combine remote sources (scrapers, or a future admin-fed API) with a
/// local cache so the app is always usable without a connection.
abstract class MasterRepository {
  /// Cached listings, available instantly and offline.
  List<Master> getCached();

  Master? getById(String id);

  /// Triggers a refresh from every configured remote source, merges the
  /// results into the local cache, and returns the up-to-date list.
  /// Throws if every remote source fails AND the cache is empty; otherwise
  /// falls back silently to the cache so a single flaky source never blanks
  /// the screen.
  Future<List<Master>> refresh();

  Stream<List<Master>> watchAll();

  /// Lazily fetches a Master's own detail page to fill in whatever the
  /// listing scrape couldn't (firm deadline, registration link, required
  /// documents). Safe to call repeatedly — a no-op for sources without an
  /// enricher and cheap once a record is already enriched.
  Future<Master> enrich(String id);
}
