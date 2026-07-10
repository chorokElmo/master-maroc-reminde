import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/application_progress.dart';
import '../../domain/entities/application_status.dart';

class TrackerController extends StateNotifier<List<ApplicationProgress>> {
  TrackerController(this._ref) : super(_ref.read(trackerRepositoryProvider).getAll());

  final Ref _ref;

  Future<void> setStatus(String masterId, ApplicationStatus status, {String? notes}) async {
    await _ref.read(trackerRepositoryProvider).setStatus(masterId, status, notes: notes);
    state = _ref.read(trackerRepositoryProvider).getAll();
  }

  Future<void> remove(String masterId) async {
    await _ref.read(trackerRepositoryProvider).remove(masterId);
    state = _ref.read(trackerRepositoryProvider).getAll();
  }
}

final trackerControllerProvider =
    StateNotifierProvider<TrackerController, List<ApplicationProgress>>((ref) {
  return TrackerController(ref);
});

final trackerForMasterProvider = Provider.family<ApplicationProgress?, String>((ref, masterId) {
  final all = ref.watch(trackerControllerProvider);
  for (final p in all) {
    if (p.masterId == masterId) return p;
  }
  return null;
});

final trackerGroupedByStatusProvider = Provider<Map<ApplicationStatus, List<ApplicationProgress>>>((ref) {
  final all = ref.watch(trackerControllerProvider);
  final grouped = <ApplicationStatus, List<ApplicationProgress>>{
    for (final status in ApplicationStatus.values) status: [],
  };
  for (final p in all) {
    grouped[p.status]!.add(p);
  }
  return grouped;
});
