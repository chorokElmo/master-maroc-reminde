import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/document_type.dart';
import '../providers/document_providers.dart';

class DocumentManagerScreen extends ConsumerWidget {
  const DocumentManagerScreen({super.key});

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref, DocumentType type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.single.path == null) return;

    await ref.read(documentsControllerProvider.notifier).upload(
          type: type,
          sourcePath: result.files.single.path!,
          fileName: result.files.single.name,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${type.label} uploaded')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(documentsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 16, context.horizontalPadding(), 40),
        itemCount: DocumentType.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final type = DocumentType.values[i];
          final document = ref.watch(documentByTypeProvider(type));

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (document != null ? Colors.green : context.colors.primary).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    document != null ? Icons.check_circle_rounded : Icons.upload_file_rounded,
                    color: document != null ? Colors.green : context.colors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type.label, style: context.textStyles.titleSmall),
                      Text(
                        document != null
                            ? '${document.fileName} · ${AppDateUtils.formatDate(document.uploadedAt)}'
                            : 'Not uploaded',
                        style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (document != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => ref.read(documentsControllerProvider.notifier).remove(type),
                  )
                else
                  TextButton(
                    onPressed: () => _pickAndUpload(context, ref, type),
                    child: const Text('Upload'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
