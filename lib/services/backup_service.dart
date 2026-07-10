import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../features/favorites/domain/entities/favorite_entry.dart';
import '../features/profile/domain/entities/user_preferences.dart';
import '../features/tracker/domain/entities/application_progress.dart';

/// The portable parts of a user's data: favorites, application tracker
/// progress and preferences. Scraped Master listings and uploaded document
/// files are deliberately excluded — listings are re-fetchable from the
/// source sites, and documents stay as local files rather than being
/// base64-inflated into a JSON blob.
class BackupPayload {
  const BackupPayload({
    required this.favorites,
    required this.progress,
    required this.preferences,
  });

  final List<FavoriteEntry> favorites;
  final List<ApplicationProgress> progress;
  final UserPreferences preferences;
}

class BackupService {
  Future<File> exportToFile(BackupPayload payload) async {
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/master_maroc_backup_$stamp.json');

    final json = {
      'app': 'Master Maroc Reminder',
      'exportedAt': DateTime.now().toIso8601String(),
      'favorites': payload.favorites.map((f) => f.toJson()).toList(),
      'progress': payload.progress.map((p) => p.toJson()).toList(),
      'preferences': payload.preferences.toJson(),
    };

    await file.writeAsString(jsonEncode(json));
    return file;
  }

  Future<void> exportAndShare(BackupPayload payload) async {
    final file = await exportToFile(payload);
    await Share.shareXFiles([XFile(file.path)], subject: 'Master Maroc Reminder backup');
  }

  Future<BackupPayload?> pickAndImport() async {
    final result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.single.path == null) return null;

    final file = File(result.files.single.path!);
    final decoded = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    return BackupPayload(
      favorites: (decoded['favorites'] as List)
          .map((e) => FavoriteEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: (decoded['progress'] as List)
          .map((e) => ApplicationProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferences: UserPreferences.fromJson(decoded['preferences'] as Map<String, dynamic>),
    );
  }
}
