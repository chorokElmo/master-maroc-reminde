import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/app_user.dart';

/// Reactive auth state — screens should watch this instead of reading
/// [AuthRepository.currentUser] directly, since that's a one-time snapshot
/// that won't trigger a rebuild when sign-in/sign-out happens elsewhere.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
