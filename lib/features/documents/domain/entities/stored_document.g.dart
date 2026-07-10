// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoredDocumentImpl _$$StoredDocumentImplFromJson(Map<String, dynamic> json) =>
    _$StoredDocumentImpl(
      type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$$StoredDocumentImplToJson(
        _$StoredDocumentImpl instance) =>
    <String, dynamic>{
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'filePath': instance.filePath,
      'fileName': instance.fileName,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.diploma: 'diploma',
  DocumentType.transcript: 'transcript',
  DocumentType.cv: 'cv',
  DocumentType.motivationLetter: 'motivationLetter',
  DocumentType.nationalId: 'nationalId',
  DocumentType.passportPhoto: 'passportPhoto',
  DocumentType.englishCertificate: 'englishCertificate',
  DocumentType.frenchCertificate: 'frenchCertificate',
};
