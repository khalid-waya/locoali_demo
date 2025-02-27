import 'package:firebase_auth/firebase_auth.dart';

/// Implementation of [AuthFirebaseDatasource] using Firebase Authentication
class AuthFirebaseDatasourceImplementation {
  /// Firebase Authentication instance
  final FirebaseAuth _firebaseAuth;

  /// Creates an instance of [AuthFirebaseDatasourceImplementation]
  /// @param firebaseAuth The Firebase Authentication instance to use
  AuthFirebaseDatasourceImplementation(this._firebaseAuth);

  Future<String> signupWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Validate password confirmation
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // Create new user account with email and password
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the user's display name after account creation
      await userCredential.user?.updateDisplayName(name);

      // Verify user creation and return UID
      if (userCredential.user?.uid != null) {
        return userCredential.user!.uid;
      } else {
        throw Exception('Failed to create user');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific authentication errors
      throw Exception(e.message ?? 'An error occurred during signup');
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
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'An error occurred during login');
    }
  }
}
