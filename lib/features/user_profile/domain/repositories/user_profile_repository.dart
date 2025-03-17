import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';

/// Repository interface for user profile operations
abstract class UserProfileRepository {
  /// Creates a new user profile
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String uid,
    required String displayName,
    required String email,
    required UserRole role,
  });

  /// Updates an existing user profile
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required UserProfile profile,
  });

  /// Gets a user profile by user ID
  Future<Either<Failure, UserProfile>> getUserProfile(String uid);

  /// Checks if a user profile exists
  Future<Either<Failure, bool>> checkUserProfileExists(String uid);

  /// Updates the user's role
  Future<Either<Failure, UserProfile>> updateUserRole({
    required String uid,
    required UserRole role,
  });

  /// Retrieves the current user's profile
  Future<Either<Failure, UserProfile>> getCurrentUserProfile();
}
