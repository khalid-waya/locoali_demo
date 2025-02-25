// lib/features/auth/domain/usecases/signup_with_email.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/success/success.dart';
import '../repositories/auth_repository.dart';

class SignupWithEmailUseCase {
  final AuthRepository repository;

  SignupWithEmailUseCase(this.repository);

  Future<Either<Failure, AuthSuccess>> execute({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.signupWithEmail(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
