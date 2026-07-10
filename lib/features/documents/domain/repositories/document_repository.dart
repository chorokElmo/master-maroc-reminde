import '../entities/document_type.dart';
import '../entities/stored_document.dart';

abstract class DocumentRepository {
  List<StoredDocument> getAll();

  StoredDocument? getByType(DocumentType type);

  /// Copies [sourcePath] into the app's private document storage and
  /// records it against [type], replacing any previous upload of that type.
  Future<StoredDocument> upload({
    required DocumentType type,
    required String sourcePath,
    required String fileName,
  });

  Future<void> remove(DocumentType type);

  /// Every required-document type not yet uploaded, given a Master's
  /// `requiredDocuments` label list matched against [DocumentType.label].
  List<DocumentType> missingFor(List<String> requiredDocumentLabels);
}
