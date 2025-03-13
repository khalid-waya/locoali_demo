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
  }

  String? _getClientId() {
    if (kIsWeb) return AuthConstants.webClientId;
    if (Platform.isIOS) return AuthConstants.iosClientId;
    if (Platform.isAndroid) return null; // Android uses google-services.json
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return await _handleWebSignIn();
      } else if (Platform.isIOS) {
        return await _handleIOSSignIn();
      } else if (Platform.isAndroid) {
        return await _handleAndroidSignIn();
      }
      return null;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  Future<UserCredential?> _handleWebSignIn() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    authProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    authProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    return await _auth.signInWithPopup(authProvider);
  }

  Future<UserCredential?> _handleIOSSignIn() async {
    try {
      // Ensure previous sign-in is cleared
      await _googleSignIn.signOut();

      // Start sign in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('iOS Google Sign In Error: $e');
      return null;
    }
  }
  

  Future<UserCredential?> _handleAndroidSignIn() async {
    await _googleSignIn.signOut(); // Ensure clean state

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }
}
