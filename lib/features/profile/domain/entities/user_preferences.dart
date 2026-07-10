import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(<String>[]) List<String> preferredCities,
    @Default(<String>[]) List<String> preferredUniversities,
    /// Specialization ids, matching `assets/data/specializations.json`.
    @Default(<String>[]) List<String> preferredDomains,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
