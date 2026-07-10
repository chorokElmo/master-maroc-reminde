import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/user_preferences.dart';

class PreferencesController extends StateNotifier<UserPreferences> {
  PreferencesController(this._ref) : super(_ref.read(preferencesRepositoryProvider).get());

  final Ref _ref;

  Future<void> update(UserPreferences preferences) async {
    state = preferences;
    await _ref.read(preferencesRepositoryProvider).save(preferences);
  }

  Future<void> toggleCity(String city) => _toggleIn(
        state.preferredCities,
        city,
        (list) => state = state.copyWith(preferredCities: list),
      );

  Future<void> toggleUniversity(String university) => _toggleIn(
        state.preferredUniversities,
        university,
        (list) => state = state.copyWith(preferredUniversities: list),
      );

  Future<void> toggleDomain(String domainId) => _toggleIn(
        state.preferredDomains,
        domainId,
        (list) => state = state.copyWith(preferredDomains: list),
      );

  Future<void> _toggleIn(List<String> list, String value, void Function(List<String>) apply) async {
    final updated = List<String>.from(list);
    if (updated.contains(value)) {
      updated.remove(value);
    } else {
      updated.add(value);
    }
    apply(updated);
    await _ref.read(preferencesRepositoryProvider).save(state);
  }
}

final preferencesControllerProvider =
    StateNotifierProvider<PreferencesController, UserPreferences>((ref) {
  return PreferencesController(ref);
});

final preferencesProvider = Provider<UserPreferences>((ref) {
  return ref.watch(preferencesControllerProvider);
});
