import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/core/success/success.dart';

abstract class AuthRepository {
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

  Future<Either<Failure, bool>> checkEmailVerified();
  Future<Either<Failure, void>> sendVerificationEmail();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword({required String email});
  Future<Either<Failure, void>> deleteAccount();
}
