// lib/features/auth/data/datasources/google_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:locoali_demo/core/constants/auth_constants.dart';
import 'dart:io' show Platform;

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;

  GoogleAuthService() {
    _googleSignIn = GoogleSignIn(
      clientId: _getClientId(),
      scopes: ['email', 'profile'],
    );
    debugPrint(
        'GoogleAuthService initialized with clientId: ${_getClientId()}');
  }

  String? _getClientId() {
    if (kIsWeb) {
      debugPrint('Platform: Web, using webClientId');
      return AuthConstants.webClientId;
    }
    if (Platform.isIOS) {
      debugPrint('Platform: iOS, using iosClientId');
      return AuthConstants.iosClientId;
    }
    if (Platform.isAndroid) {
      debugPrint('Platform: Android, using google-services.json');
      return null; // Android uses google-services.json
    }
    debugPrint('Platform: Unknown');
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign-In process');
      if (kIsWeb) {
        debugPrint('Using web sign-in flow');
        return await _handleWebSignIn();
      } else if (Platform.isIOS) {
        debugPrint('Using iOS sign-in flow');
        return await _handleIOSSignIn();
      } else if (Platform.isAndroid) {
        debugPrint('Using Android sign-in flow');
        return await _handleAndroidSignIn();
      }
      debugPrint('No sign-in flow available for current platform');
      return null;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      if (e is FirebaseAuthException) {
        debugPrint('FirebaseAuthException code: ${e.code}');
        debugPrint('FirebaseAuthException message: ${e.message}');
      }
      return null;
    }
  }

  Future<UserCredential?> _handleWebSignIn() async {
    debugPrint('Starting web sign-in flow');
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    authProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    authProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    return await _auth.signInWithPopup(authProvider);
  }

  Future<UserCredential?> _handleIOSSignIn() async {
    try {
      debugPrint('Starting iOS sign-in flow');
      // Ensure previous sign-in is cleared
      await _googleSignIn.signOut();
      debugPrint('Previous sign-in cleared');

      // Start sign in flow
      debugPrint('Calling _googleSignIn.signIn()');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google sign-in was cancelled by user or failed');
        return null;
      }
      debugPrint('Google sign-in successful for user: ${googleUser.email}');

      // Get auth details
      debugPrint('Getting authentication details');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint(
          'Got authentication details. Has accessToken: ${googleAuth.accessToken != null}, Has idToken: ${googleAuth.idToken != null}');

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('Created Firebase credential');

      // Sign in with Firebase
      debugPrint('Signing in with Firebase');
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('iOS Google Sign In Error: $e');
      if (e is FirebaseAuthException) {
        debugPrint('FirebaseAuthException code: ${e.code}');
        debugPrint('FirebaseAuthException message: ${e.message}');
      }
      return null;
    }
  }

  Future<UserCredential?> _handleAndroidSignIn() async {
    debugPrint('Starting Android sign-in flow');
    await _googleSignIn.signOut(); // Ensure clean state
    debugPrint('Previous sign-in cleared');

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      debugPrint('Google sign-in was cancelled by user or failed');
      return null;
    }
    debugPrint('Google sign-in successful for user: ${googleUser.email}');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    debugPrint(
        'Got authentication details. Has accessToken: ${googleAuth.accessToken != null}, Has idToken: ${googleAuth.idToken != null}');

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    debugPrint('Created Firebase credential');

    debugPrint('Signing in with Firebase');
    return await _auth.signInWithCredential(credential);
  }
}
