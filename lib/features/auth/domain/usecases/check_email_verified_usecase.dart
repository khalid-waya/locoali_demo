import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/auth/domain/repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository repository;

  CheckEmailVerifiedUseCase(this.repository);

  Future<Either<Failure, bool>> execute() async {
    return await repository.checkEmailVerified();
  }
}