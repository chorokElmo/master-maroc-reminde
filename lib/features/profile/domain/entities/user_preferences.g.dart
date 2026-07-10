// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      preferredCities: (json['preferredCities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      preferredUniversities: (json['preferredUniversities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      preferredDomains: (json['preferredDomains'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'preferredCities': instance.preferredCities,
      'preferredUniversities': instance.preferredUniversities,
      'preferredDomains': instance.preferredDomains,
    };
