import 'dart:io';

import 'package:hive/hive.dart';

import '../../domain/entities/document_type.dart';
import '../../domain/entities/stored_document.dart';
import '../../domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._box, this._storageDir);

  final Box<dynamic> _box;
  final Directory _storageDir;

  @override
  List<StoredDocument> getAll() {
    return _box.values
        .whereType<Map>()
        .map((raw) => StoredDocument.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  @override
  StoredDocument? getByType(DocumentType type) {
    final raw = _box.get(type.name);
    if (raw is! Map) return null;
    return StoredDocument.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<StoredDocument> upload({
    required DocumentType type,
    required String sourcePath,
    required String fileName,
  }) async {
    if (!_storageDir.existsSync()) {
      _storageDir.createSync(recursive: true);
    }

    final extension = fileName.contains('.') ? fileName.split('.').last : 'dat';
    final destPath = '${_storageDir.path}/${type.name}.$extension';

    final previous = getByType(type);
    if (previous != null && previous.filePath != destPath) {
      final previousFile = File(previous.filePath);
      if (previousFile.existsSync()) await previousFile.delete();
    }

    await File(sourcePath).copy(destPath);

    final document = StoredDocument(
      type: type,
      filePath: destPath,
      fileName: fileName,
      uploadedAt: DateTime.now(),
    );
    await _box.put(type.name, document.toJson());
    return document;
  }

  @override
  Future<void> remove(DocumentType type) async {
    final existing = getByType(type);
    if (existing != null) {
      final file = File(existing.filePath);
      if (file.existsSync()) await file.delete();
    }
    await _box.delete(type.name);
  }

  @override
  List<DocumentType> missingFor(List<String> requiredDocumentLabels) {
    if (requiredDocumentLabels.isEmpty) return const [];
    final uploadedTypes = _box.keys.toSet();
    return [
      for (final type in DocumentType.values)
        if (requiredDocumentLabels.contains(type.label) &&
            !uploadedTypes.contains(type.name))
          type,
    ];
  }
}
