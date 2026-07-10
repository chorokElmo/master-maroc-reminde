import 'package:flutter/foundation.dart';

import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';
import 'master_remote_data_source.dart';

/// Fans out to every registered [MasterRemoteDataSource] and merges the
/// results. A single source failing (site down, markup changed) never
/// takes down the whole refresh — it's logged and skipped, and whatever
/// sources did succeed are still returned. Adding a third source later is
/// a one-line change to the `sources` list passed in from the provider.
class CompositeMasterRemoteDataSource {
  CompositeMasterRemoteDataSource(this.sources);

  final List<MasterRemoteDataSource> sources;

  Future<List<Master>> fetchAll() async {
    final results = await Future.wait(
      sources.map((s) async {
        try {
          return await s.fetchListings();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('MasterRemoteDataSource(${s.source.label}) failed: $e');
          }
          return <Master>[];
        }
      }),
    );
    return results.expand((list) => list).toList();
  }
}
