import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';

class CreateUserProfileUseCase {
  final UserProfileRepository repository;

  CreateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> execute({
    required String uid,
    required String displayName,
    required String email,
    required UserRole role,
  }) async {
    return await repository.createUserProfile(
      uid: uid,
      displayName: displayName,
      email: email,
      role: role,
    );
  }
}
