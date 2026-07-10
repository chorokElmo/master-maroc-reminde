import 'package:hive/hive.dart';

import '../../domain/entities/application_progress.dart';
import '../../domain/entities/application_status.dart';
import '../../domain/repositories/tracker_repository.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  TrackerRepositoryImpl(this._box);

  final Box<dynamic> _box;

  @override
  List<ApplicationProgress> getAll() {
    return _box.values
        .whereType<Map>()
        .map((raw) => ApplicationProgress.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  @override
  ApplicationProgress? getFor(String masterId) {
    final raw = _box.get(masterId);
    if (raw is! Map) return null;
    return ApplicationProgress.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> setStatus(String masterId, ApplicationStatus status, {String? notes}) async {
    final progress = ApplicationProgress(
      masterId: masterId,
      status: status,
      notes: notes ?? getFor(masterId)?.notes,
      updatedAt: DateTime.now(),
    );
    await _box.put(masterId, progress.toJson());
  }

  @override
  Future<void> remove(String masterId) => _box.delete(masterId);
}
