import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';

class CheckUserProfileExistsUseCase {
  final UserProfileRepository repository;

  CheckUserProfileExistsUseCase(this.repository);

  Future<Either<Failure, bool>> execute(String uid) async {
    return await repository.checkUserProfileExists(uid);
  }
}
