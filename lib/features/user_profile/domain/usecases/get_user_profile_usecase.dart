import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> execute(String uid) async {
    return await repository.getUserProfile(uid);
  }
}
