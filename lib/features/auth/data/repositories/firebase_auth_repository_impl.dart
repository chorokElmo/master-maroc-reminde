import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  FirebaseAuthRepositoryImpl({required bool isConfigured}) : _isConfigured = isConfigured;

  final bool _isConfigured;

  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  @override
  bool get isConfigured => _isConfigured;

  @override
  AppUser? get currentUser {
    if (!_isConfigured) return null;
    return _toAppUser(_auth.currentUser);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    if (!_isConfigured) return Stream.value(null);
    return _auth.authStateChanges().map(_toAppUser);
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    _assertConfigured();
    final credential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _toAppUser(credential.user)!;
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password, {String? displayName}) async {
    _assertConfigured();
    final credential =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (displayName != null) {
      await credential.user?.updateDisplayName(displayName);
    }
    return _toAppUser(credential.user)!;
  }

  @override
  Future<void> signOut() async {
    if (!_isConfigured) return;
    await _auth.signOut();
  }

  void _assertConfigured() {
    if (!_isConfigured) {
      throw StateError(
        'Firebase is not configured for this build. Run `flutterfire configure` '
        'to enable sign-in.',
      );
    }
  }

  AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
