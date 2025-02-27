// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/success/success.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDatasourceImplementation _datasource;

  AuthRepositoryImpl()
      : _datasource =
            AuthFirebaseDatasourceImplementation(FirebaseAuth.instance);

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
    } catch (e) {
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
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
