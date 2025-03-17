import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateUserRoleUseCase {
  final UserProfileRepository repository;

  UpdateUserRoleUseCase(this.repository);

  Future<Either<Failure, UserProfile>> execute({
    required String uid,
    required UserRole role,
  }) async {
    return await repository.updateUserRole(
      uid: uid,
      role: role,
    );
  }
}
