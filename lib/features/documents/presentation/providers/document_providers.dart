import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/stored_document.dart';

class DocumentsController extends StateNotifier<List<StoredDocument>> {
  DocumentsController(this._ref) : super(_ref.read(documentRepositoryProvider).getAll());

  final Ref _ref;

  Future<void> upload({
    required DocumentType type,
    required String sourcePath,
    required String fileName,
  }) async {
    await _ref.read(documentRepositoryProvider).upload(type: type, sourcePath: sourcePath, fileName: fileName);
    state = _ref.read(documentRepositoryProvider).getAll();
  }

  Future<void> remove(DocumentType type) async {
    await _ref.read(documentRepositoryProvider).remove(type);
    state = _ref.read(documentRepositoryProvider).getAll();
  }
}

final documentsControllerProvider =
    StateNotifierProvider<DocumentsController, List<StoredDocument>>((ref) {
  return DocumentsController(ref);
});

final documentByTypeProvider = Provider.family<StoredDocument?, DocumentType>((ref, type) {
  final all = ref.watch(documentsControllerProvider);
  for (final d in all) {
    if (d.type == type) return d;
  }
  return null;
});

/// Which of a Master's `requiredDocuments` (free-text labels) the student
/// hasn't uploaded yet, resolved against [DocumentType.label].
final missingDocumentsProvider = Provider.family<List<DocumentType>, List<String>>((ref, requiredLabels) {
  ref.watch(documentsControllerProvider);
  return ref.read(documentRepositoryProvider).missingFor(requiredLabels);
});
