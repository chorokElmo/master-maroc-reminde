import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl(this._prefs);

  static const _key = 'user_preferences';

  final SharedPreferences _prefs;

  @override
  UserPreferences get() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const UserPreferences();
    try {
      return UserPreferences.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserPreferences();
    }
  }

  @override
  Future<void> save(UserPreferences preferences) {
    return _prefs.setString(_key, jsonEncode(preferences.toJson()));
  }
}
