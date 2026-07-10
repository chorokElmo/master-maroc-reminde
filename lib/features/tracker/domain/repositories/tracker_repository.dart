import '../entities/application_progress.dart';
import '../entities/application_status.dart';

abstract class TrackerRepository {
  List<ApplicationProgress> getAll();

  ApplicationProgress? getFor(String masterId);

  Future<void> setStatus(String masterId, ApplicationStatus status, {String? notes});

  Future<void> remove(String masterId);
}
