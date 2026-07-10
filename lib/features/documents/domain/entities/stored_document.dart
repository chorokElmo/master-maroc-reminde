import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_type.dart';

part 'stored_document.freezed.dart';
part 'stored_document.g.dart';

/// A document the student has uploaded, stored once per [DocumentType] in
/// the app's private storage — re-uploading a type replaces the previous
/// file rather than creating duplicates, since a CV or diploma is shared
/// across every application, not scoped to a single Master.
@freezed
class StoredDocument with _$StoredDocument {
  const factory StoredDocument({
    required DocumentType type,
    required String filePath,
    required String fileName,
    required DateTime uploadedAt,
  }) = _StoredDocument;

  factory StoredDocument.fromJson(Map<String, dynamic> json) =>
      _$StoredDocumentFromJson(json);
}
