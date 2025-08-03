import 'package:firebase_auth/firebase_auth.dart';
import '../models/yoga_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  YogaUser? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return YogaUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        createdAt: user.metadata.creationTime,
        isEmailVerified: user.emailVerified,
      );
    }
    return null;
  }

  // Stream of auth changes
  Stream<YogaUser?> get authStateChanges {
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return YogaUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          phoneNumber: user.phoneNumber,
          createdAt: user.metadata.creationTime,
          isEmailVerified: user.emailVerified,
        );
      }
      return null;
    });
  }

  // Sign in with email and password
  Future<YogaUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return YogaUser(
          uid: result.user!.uid,
          email: result.user!.email ?? '',
          displayName: result.user!.displayName,
          phoneNumber: result.user!.phoneNumber,
          createdAt: result.user!.metadata.creationTime,
          isEmailVerified: result.user!.emailVerified,
        );
      } else {
        throw Exception('Sign in failed');
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Register with email and password
  Future<YogaUser> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return YogaUser(
          uid: result.user!.uid,
          email: result.user!.email ?? '',
          displayName: result.user!.displayName,
          phoneNumber: result.user!.phoneNumber,
          createdAt: result.user!.metadata.creationTime,
          isEmailVerified: result.user!.emailVerified,
        );
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
}
