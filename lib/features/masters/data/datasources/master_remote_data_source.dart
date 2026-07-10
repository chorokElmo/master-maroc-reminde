import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';

/// One scraped (or, in the future, API-backed) source of Master listings.
/// Adding a new source is just implementing this interface and registering
/// it with [CompositeMasterRemoteDataSource] — nothing else in the app
/// needs to change.
abstract class MasterRemoteDataSource {
  MasterSource get source;

  Future<List<Master>> fetchListings();
}

/// Best-effort enrichment of a single [Master] from its own detail page
/// (registration link, PDF, required documents, a firmer deadline). Kept
/// separate from [MasterRemoteDataSource.fetchListings] because it's a
/// second network round-trip per program — callers fetch listings first
/// (cheap, one request per source) and enrich lazily, typically when the
/// user opens a Master's detail screen.
abstract class MasterDetailEnricher {
  MasterSource get source;

  Future<Master> enrich(Master master);
}
