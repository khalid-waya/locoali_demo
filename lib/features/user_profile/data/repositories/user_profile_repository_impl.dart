import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:locoali_demo/core/error/failures.dart';
import 'package:locoali_demo/features/user_profile/data/models/user_profile_model.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String uid,
    required String displayName,
    required String email,
    required UserRole role,
  }) async {
    try {
      final userProfileModel = UserProfileModel(
        uid: uid,
        displayName: displayName,
        email: email,
        role: role.toString().split('.').last,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userProfileModel.toFirestore());

      return Right(userProfileModel.toEntity());
    } catch (e) {
      return Left(Failure('Failed to create user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required UserProfile profile,
  }) async {
    try {
      final userProfileModel = UserProfileModel.fromEntity(profile);

      await _firestore
          .collection('users')
          .doc(profile.uid)
          .update(userProfileModel.toFirestore());

      return Right(profile);
    } catch (e) {
      return Left(Failure('Failed to update user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        return Left(Failure('User profile not found'));
      }

      final userProfileModel = UserProfileModel.fromFirestore(
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>);

      return Right(userProfileModel.toEntity());
    } catch (e) {
      return Left(Failure('Failed to get user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserProfileExists(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      return Right(docSnapshot.exists);
    } catch (e) {
      return Left(Failure('Failed to check user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserRole({
    required String uid,
    required UserRole role,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': role.toString().split('.').last,
        'lastActive': FieldValue.serverTimestamp(),
      });

      // Get the updated profile
      final result = await getUserProfile(uid);
      return result;
    } catch (e) {
      return Left(Failure('Failed to update user role: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Left(Failure('No user is currently signed in.'));
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Left(Failure('User profile does not exist.'));
      }

      final userProfileModel = UserProfileModel.fromFirestore(doc);
      return Right(userProfileModel.toEntity());
    } catch (e) {
      return Left(
          Failure('Failed to retrieve current user profile: ${e.toString()}'));
    }
  }
}
