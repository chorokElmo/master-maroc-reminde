import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/core_providers.dart';
import 'features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/masters/data/parsing/academic_reference_data.dart';
import 'firebase_options.dart';
import 'services/fcm_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final mastersBox = await Hive.openBox<dynamic>('masters_box');
  final favoritesBox = await Hive.openBox<dynamic>('favorites_box');
  final documentsBox = await Hive.openBox<dynamic>('documents_box');
  final trackerBox = await Hive.openBox<dynamic>('tracker_box');

  final sharedPreferences = await SharedPreferences.getInstance();

  await AcademicReferenceData.instance.load();

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  final appDocumentsDir = await getApplicationDocumentsDirectory();
  final documentStorageDir = Directory('${appDocumentsDir.path}/student_documents');

  final firebaseConfigured = DefaultFirebaseOptions.isConfigured;
  if (firebaseConfigured) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final AuthRepository authRepository = FirebaseAuthRepositoryImpl(isConfigured: firebaseConfigured);
  final fcmService = FcmService(notificationService, isConfigured: firebaseConfigured);
  await fcmService.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        mastersBoxProvider.overrideWithValue(mastersBox),
        favoritesBoxProvider.overrideWithValue(favoritesBox),
        documentsBoxProvider.overrideWithValue(documentsBox),
        trackerBoxProvider.overrideWithValue(trackerBox),
        documentStorageDirProvider.overrideWithValue(documentStorageDir),
        notificationServiceProvider.overrideWithValue(notificationService),
        fcmServiceProvider.overrideWithValue(fcmService),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: const MasterMarocReminderApp(),
    ),
  );
}
