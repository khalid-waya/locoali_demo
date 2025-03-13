// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:locoali_demo/features/auth/data/datasources/google_auth_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/success/success.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDatasourceImplementation _datasource;
  final GoogleAuthService _googleAuthService;

  

  AuthRepositoryImpl()
      : _datasource =
            AuthFirebaseDatasourceImplementation(FirebaseAuth.instance),
            _googleAuthService = GoogleAuthService();

  @override
  Future<Either<Failure, AuthSuccess>> signupWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final uid = await _datasource.signupWithEmail(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      return Right(AuthSuccess(
        uid: uid,
        message: 'Successfully created account',
      ));
    } on String catch (errorMessage) {
      // Handle string errors directly without adding "Exception: " prefix
      return Left(AuthFailure(errorMessage));
    } catch (e) {
      // For other exceptions, still convert to string but now this should be rare
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSuccess>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final uid = await _datasource.loginWithEmail(
        email: email,
        password: password,
      );

      return Right(AuthSuccess(
        uid: uid,
        message: 'Successfully logged in',
      ));
    } on String catch (errorMessage) {
      // Handle string errors directly without adding "Exception: " prefix
      return Left(AuthFailure(errorMessage));
    } catch (e) {
      // For other exceptions, still convert to string but now this should be rare
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      final isVerified = await _datasource.checkEmailVerified();
      return Right(isVerified);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationEmail() async {
    try {
      await _datasource.sendVerificationEmail();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _datasource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _datasource.resetPassword(email: email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

    @override
  Future<Either<Failure, AuthSuccess>> signInWithGoogle() async {
    try {
      final userCredential = await _googleAuthService.signInWithGoogle();
      if (userCredential != null) {
        return Right(AuthSuccess(
            uid: userCredential.user!.uid,
            message: 'Successfully signed in with Google'));
      }
      return Left(AuthFailure('Google sign in cancelled or failed'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  
}
