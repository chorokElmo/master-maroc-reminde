import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/core_providers.dart';

const _kOnboardingDone = 'onboarding_complete';
const _kThemeMode = 'theme_mode';
const _kLocale = 'locale_code';
const _kNotificationsEnabled = 'notifications_enabled';
const _kDynamicColor = 'dynamic_color_enabled';

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._prefs) : super(_prefs.getBool(_kOnboardingDone) ?? false);
  final SharedPreferences _prefs;

  Future<void> complete() async {
    state = true;
    await _prefs.setBool(_kOnboardingDone, true);
  }
}

final onboardingCompleteProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier(ref.watch(sharedPreferencesProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_fromString(_prefs.getString(_kThemeMode)));
  final SharedPreferences _prefs;

  static ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_kThemeMode, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(sharedPreferencesProvider));
});

class DynamicColorPreferenceNotifier extends StateNotifier<bool> {
  DynamicColorPreferenceNotifier(this._prefs) : super(_prefs.getBool(_kDynamicColor) ?? true);
  final SharedPreferences _prefs;

  Future<void> set(bool value) async {
    state = value;
    await _prefs.setBool(_kDynamicColor, value);
  }
}

final dynamicColorEnabledProvider =
    StateNotifierProvider<DynamicColorPreferenceNotifier, bool>((ref) {
  return DynamicColorPreferenceNotifier(ref.watch(sharedPreferencesProvider));
});

const supportedLocales = [Locale('en'), Locale('fr'), Locale('ar')];

const localeNames = {'en': 'English', 'fr': 'Français', 'ar': 'العربية'};

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._prefs) : super(Locale(_prefs.getString(_kLocale) ?? 'fr'));
  final SharedPreferences _prefs;

  Future<void> set(Locale locale) async {
    state = locale;
    await _prefs.setString(_kLocale, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});

class NotificationsEnabledNotifier extends StateNotifier<bool> {
  NotificationsEnabledNotifier(this._prefs) : super(_prefs.getBool(_kNotificationsEnabled) ?? true);
  final SharedPreferences _prefs;

  Future<void> set(bool value) async {
    state = value;
    await _prefs.setBool(_kNotificationsEnabled, value);
  }
}

final notificationsEnabledProvider =
    StateNotifierProvider<NotificationsEnabledNotifier, bool>((ref) {
  return NotificationsEnabledNotifier(ref.watch(sharedPreferencesProvider));
});
