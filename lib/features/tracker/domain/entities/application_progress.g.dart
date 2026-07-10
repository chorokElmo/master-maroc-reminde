// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationProgressImpl _$$ApplicationProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationProgressImpl(
      masterId: json['masterId'] as String,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ApplicationProgressImplToJson(
        _$ApplicationProgressImpl instance) =>
    <String, dynamic>{
      'masterId': instance.masterId,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.interested: 'interested',
  ApplicationStatus.preparingDocuments: 'preparingDocuments',
  ApplicationStatus.submitted: 'submitted',
  ApplicationStatus.waitingForResults: 'waitingForResults',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.archived: 'archived',
};
