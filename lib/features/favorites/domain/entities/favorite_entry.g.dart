// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteEntryImpl _$$FavoriteEntryImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteEntryImpl(
      masterId: json['masterId'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      notificationIds: (json['notificationIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      customReminderDaysBefore:
          (json['customReminderDaysBefore'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
    );

Map<String, dynamic> _$$FavoriteEntryImplToJson(_$FavoriteEntryImpl instance) =>
    <String, dynamic>{
      'masterId': instance.masterId,
      'addedAt': instance.addedAt.toIso8601String(),
      'notificationIds': instance.notificationIds,
      'customReminderDaysBefore': instance.customReminderDaysBefore,
    };
