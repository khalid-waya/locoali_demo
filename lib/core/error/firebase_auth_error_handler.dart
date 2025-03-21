// lib/core/error/firebase_auth_error_handler.dart
import 'package:firebase_auth/firebase_auth.dart';

/// A utility class that translates Firebase Authentication error codes
/// into user-friendly error messages.
class FirebaseAuthErrorHandler {
  /// Maps a FirebaseAuthException to a user-friendly error message
  static String handleError(FirebaseAuthException exception) {
    String errorMessage = 'An error occurred. Please try again.';

    if (exception.code.isEmpty) {
      return errorMessage;
    }

    if (exception.code == 'invalid-email' ||
        exception.code.contains('invalid-email')) {
      errorMessage = 'Please enter a valid email address.';
    } else if (exception.code == 'user-not-found' ||
        exception.code.contains('user-not-found')) {
      errorMessage = 'No account found with this email. Please sign up first.';
    } else if (exception.code == 'invalid-credential' ||
        exception.code.contains('invalid-credential')) {
      errorMessage =
          'Invalid credentials. Please check your email and password.';
    } else if (exception.code == 'wrong-password' ||
        exception.code.contains('wrong-password')) {
      errorMessage =
          'Incorrect password. Please try again or reset your password.';
    } else if (exception.code == 'email-already-in-use' ||
        exception.code.contains('email-already-in-use')) {
      errorMessage = 'An account already exists with this email.';
    } else {
      errorMessage = exception.message ?? errorMessage;
    }

    return errorMessage;
  }

  /// Handles general exceptions that might occur during authentication
  static String handleException(Exception exception) {
    if (exception is FirebaseAuthException) {
      return handleError(exception);
    }
    return 'An error occurred. Please try again.';
  }
}
