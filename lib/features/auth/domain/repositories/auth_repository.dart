import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/core/success/success.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthSuccess>> signupWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, AuthSuccess>> loginWithEmail({
    required String email,
    required String password,
  });
}