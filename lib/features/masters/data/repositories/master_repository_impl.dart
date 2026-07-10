import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';
import '../../domain/repositories/master_repository.dart';
import '../datasources/composite_master_remote_data_source.dart';
import '../datasources/master_local_data_source.dart';
import '../datasources/master_remote_data_source.dart';

class MasterRepositoryImpl implements MasterRepository {
  MasterRepositoryImpl({
    required CompositeMasterRemoteDataSource remote,
    required MasterLocalDataSource local,
    required List<MasterDetailEnricher> enrichers,
  })  : _remote = remote,
        _local = local,
        _enrichers = {for (final e in enrichers) e.source: e};

  final CompositeMasterRemoteDataSource _remote;
  final MasterLocalDataSource _local;
  final Map<MasterSource, MasterDetailEnricher> _enrichers;

  @override
  List<Master> getCached() => _local.getAll();

  @override
  Master? getById(String id) => _local.getById(id);

  @override
  Future<List<Master>> refresh() async {
    final scraped = await _remote.fetchAll();

    if (scraped.isEmpty && _local.getAll().isEmpty) {
      throw StateError('No Master listings available from any source and the cache is empty.');
    }

    final merged = [
      for (final fresh in scraped) _mergeWithCache(fresh),
    ];

    if (merged.isNotEmpty) {
      await _local.upsertAll(merged);
    }

    return _local.getAll();
  }

  /// A fresh scrape only carries what the listing page exposes. If we've
  /// already enriched this record from its detail page (deadline, PDF,
  /// required documents), keep those rather than letting a plain refresh
  /// wipe them out.
  Master _mergeWithCache(Master fresh) {
    final cached = _local.getById(fresh.id);
    if (cached == null) return fresh;

    return fresh.copyWith(
      applicationDeadline: cached.applicationDeadline ?? fresh.applicationDeadline,
      applicationStart: cached.applicationStart ?? fresh.applicationStart,
      pdfLink: cached.pdfLink ?? fresh.pdfLink,
      requiredDocuments:
          cached.requiredDocuments.isNotEmpty ? cached.requiredDocuments : fresh.requiredDocuments,
      needsReview: fresh.needsReview && cached.applicationDeadline == null,
      createdAt: cached.createdAt,
    );
  }

  @override
  Stream<List<Master>> watchAll() async* {
    yield getCached();
    yield* _local.watchRaw().map((_) => getCached());
  }

  @override
  Future<Master> enrich(String id) async {
    final master = _local.getById(id);
    if (master == null) {
      throw StateError('Cannot enrich unknown Master id: $id');
    }

    final enricher = _enrichers[master.source];
    if (enricher == null) return master;

    final enriched = await enricher.enrich(master);
    await _local.upsert(enriched);
    return enriched;
  }
}
