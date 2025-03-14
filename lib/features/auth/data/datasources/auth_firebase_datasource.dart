import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoali_demo/core/error/firebase_auth_error_handler.dart';

class AuthFirebaseDatasourceImplementation {
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseDatasourceImplementation(this._firebaseAuth);

  Future<String> signupWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      if (userCredential.user?.uid != null) {
        return userCredential.user!.uid;
      } else {
        throw Exception('Failed to create account');
      }
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.uid != null) {
        return userCredential.user!.uid;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw Exception('No user found or email already verified');
      }
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user is currently signed in',
        );
      }

      await user.delete();
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw FirebaseAuthErrorHandler.handleException(e as Exception);
    }
  }
}
