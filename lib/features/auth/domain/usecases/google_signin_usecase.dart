import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/core/success/success.dart';
import 'package:locoali_demo/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<Either<Failure, AuthSuccess>> execute() async {
    return await repository.signInWithGoogle();
  }
}
