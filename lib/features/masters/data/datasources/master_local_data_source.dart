import 'package:hive/hive.dart';

import '../../domain/entities/master.dart';

/// Offline cache for scraped listings. Hive is used purely as a schemaless
/// JSON-object store here (each entry is `master.toJson()`) rather than
/// through a generated `TypeAdapter` — that keeps the cache decoupled from
/// Freezed/json_serializable's generated classes, so regenerating models
/// never requires a Hive migration.
class MasterLocalDataSource {
  MasterLocalDataSource(this._box);

  final Box<dynamic> _box;

  List<Master> getAll() {
    return _box.values
        .whereType<Map>()
        .map((raw) => Master.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  Master? getById(String id) {
    final raw = _box.get(id);
    if (raw is! Map) return null;
    return Master.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> upsertAll(List<Master> masters) async {
    final entries = {for (final m in masters) m.id: m.toJson()};
    await _box.putAll(entries);
  }

  Future<void> upsert(Master master) => _box.put(master.id, master.toJson());

  Future<void> clear() => _box.clear();

  Stream<void> watchRaw() => _box.watch().map((_) {});
}
