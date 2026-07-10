// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterImpl _$$MasterImplFromJson(Map<String, dynamic> json) => _$MasterImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      university: json['university'] as String?,
      faculty: json['faculty'] as String?,
      city: json['city'] as String?,
      specialization: json['specialization'] as String?,
      description: json['description'] as String,
      applicationStart: json['applicationStart'] == null
          ? null
          : DateTime.parse(json['applicationStart'] as String),
      applicationDeadline: json['applicationDeadline'] == null
          ? null
          : DateTime.parse(json['applicationDeadline'] as String),
      requiredDegree: json['requiredDegree'] as String?,
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      registrationLink: json['registrationLink'] as String?,
      pdfLink: json['pdfLink'] as String?,
      image: json['image'] as String?,
      source: $enumDecode(_$MasterSourceEnumMap, json['source']),
      needsReview: json['needsReview'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MasterImplToJson(_$MasterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'university': instance.university,
      'faculty': instance.faculty,
      'city': instance.city,
      'specialization': instance.specialization,
      'description': instance.description,
      'applicationStart': instance.applicationStart?.toIso8601String(),
      'applicationDeadline': instance.applicationDeadline?.toIso8601String(),
      'requiredDegree': instance.requiredDegree,
      'requiredDocuments': instance.requiredDocuments,
      'registrationLink': instance.registrationLink,
      'pdfLink': instance.pdfLink,
      'image': instance.image,
      'source': _$MasterSourceEnumMap[instance.source]!,
      'needsReview': instance.needsReview,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MasterSourceEnumMap = {
  MasterSource.orientationChabab: 'orientationChabab',
  MasterSource.almasterMaroc: 'almasterMaroc',
};
