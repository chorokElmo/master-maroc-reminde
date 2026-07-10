import '../entities/user_preferences.dart';

abstract class PreferencesRepository {
  UserPreferences get();

  Future<void> save(UserPreferences preferences);
}
