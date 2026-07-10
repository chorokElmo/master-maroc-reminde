import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/documents/data/repositories/document_repository_impl.dart';
import '../../features/documents/domain/repositories/document_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/masters/data/datasources/almaster_maroc_data_source.dart';
import '../../features/masters/data/datasources/composite_master_remote_data_source.dart';
import '../../features/masters/data/datasources/master_local_data_source.dart';
import '../../features/masters/data/datasources/master_remote_data_source.dart';
import '../../features/masters/data/datasources/orientation_chabab_data_source.dart';
import '../../features/masters/data/parsing/academic_reference_data.dart';
import '../../features/masters/data/parsing/master_field_extractor.dart';
import '../../features/masters/data/repositories/master_repository_impl.dart';
import '../../features/masters/domain/repositories/master_repository.dart';
import '../../features/profile/data/repositories/preferences_repository_impl.dart';
import '../../features/profile/domain/repositories/preferences_repository.dart';
import '../../features/tracker/data/repositories/tracker_repository_impl.dart';
import '../../features/tracker/domain/repositories/tracker_repository.dart';
import '../../services/backup_service.dart';
import '../../services/export_service.dart';
import '../../services/fcm_service.dart';
import '../../services/notification_service.dart';

/// Riverpod is this app's dependency-injection graph: every repository and
/// service below is composed from its dependencies right here, so
/// swapping an implementation (a new scraper, a mock repository in tests)
/// never touches feature code.

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

final mastersBoxProvider = Provider<Box<dynamic>>(
  (ref) => throw UnimplementedError('mastersBoxProvider not overridden'),
);

final favoritesBoxProvider = Provider<Box<dynamic>>(
  (ref) => throw UnimplementedError('favoritesBoxProvider not overridden'),
);

final documentsBoxProvider = Provider<Box<dynamic>>(
  (ref) => throw UnimplementedError('documentsBoxProvider not overridden'),
);

final trackerBoxProvider = Provider<Box<dynamic>>(
  (ref) => throw UnimplementedError('trackerBoxProvider not overridden'),
);

final documentStorageDirProvider = Provider<Directory>(
  (ref) => throw UnimplementedError('documentStorageDirProvider not overridden'),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('notificationServiceProvider not overridden'),
);

final fcmServiceProvider = Provider<FcmService>(
  (ref) => throw UnimplementedError('fcmServiceProvider not overridden'),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError('authRepositoryProvider not overridden'),
);

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) MasterMarocReminder/1.0 (+offline app)',
    },
  ));
});

final academicReferenceDataProvider = Provider<AcademicReferenceData>((ref) {
  return AcademicReferenceData.instance;
});

final masterFieldExtractorProvider = Provider<MasterFieldExtractor>((ref) {
  return MasterFieldExtractor(ref.watch(academicReferenceDataProvider));
});

final orientationChababDataSourceProvider = Provider<OrientationChababDataSource>((ref) {
  return OrientationChababDataSource(ref.watch(dioProvider), ref.watch(masterFieldExtractorProvider));
});

final almasterMarocDataSourceProvider = Provider<AlmasterMarocDataSource>((ref) {
  return AlmasterMarocDataSource(ref.watch(dioProvider), ref.watch(masterFieldExtractorProvider));
});

final compositeRemoteDataSourceProvider = Provider<CompositeMasterRemoteDataSource>((ref) {
  return CompositeMasterRemoteDataSource([
    ref.watch(orientationChababDataSourceProvider),
    ref.watch(almasterMarocDataSourceProvider),
  ]);
});

final masterLocalDataSourceProvider = Provider<MasterLocalDataSource>((ref) {
  return MasterLocalDataSource(ref.watch(mastersBoxProvider));
});

final masterRepositoryProvider = Provider<MasterRepository>((ref) {
  return MasterRepositoryImpl(
    remote: ref.watch(compositeRemoteDataSourceProvider),
    local: ref.watch(masterLocalDataSourceProvider),
    enrichers: [
      ref.watch(orientationChababDataSourceProvider) as MasterDetailEnricher,
    ],
  );
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesBoxProvider));
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl(ref.watch(documentsBoxProvider), ref.watch(documentStorageDirProvider));
});

final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepositoryImpl(ref.watch(trackerBoxProvider));
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepositoryImpl(ref.watch(sharedPreferencesProvider));
});

final exportServiceProvider = Provider<ExportService>((ref) => ExportService());

final backupServiceProvider = Provider<BackupService>((ref) => BackupService());
