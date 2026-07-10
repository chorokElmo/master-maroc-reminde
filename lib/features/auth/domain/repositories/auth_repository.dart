import '../entities/app_user.dart';

abstract class AuthRepository {
  /// False when Firebase hasn't been configured for this build (no
  /// `firebase_options.dart` from `flutterfire configure` yet). The
  /// Profile screen uses this to explain why sign-in is unavailable
  /// instead of crashing or silently failing.
  bool get isConfigured;

  AppUser? get currentUser;

  Stream<AppUser?> authStateChanges();

  Future<AppUser> signInWithEmail(String email, String password);

  Future<AppUser> signUpWithEmail(String email, String password, {String? displayName});

  Future<void> signOut();
}
