import 'package:dartz/dartz.dart';
import 'package:locoali_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:locoali_demo/core/error/failures.dart';

class CheckEmailExistsUseCase {
  final AuthRepository repository;

  CheckEmailExistsUseCase(this.repository);

  /// Checks if the email exists and is verified
  /// Returns Either<Failure, bool> where:
  /// - Left(Failure) if there's an error
  /// - Right(true) if email exists and is verified
  /// - Right(false) if email exists but is not verified
  Future<Either<Failure, bool>> execute({required String email}) async {
    return await repository.checkEmailExists(email);
  }
}
