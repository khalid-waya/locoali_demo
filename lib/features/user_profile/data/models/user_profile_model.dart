import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';

/// UserLocationModel is the data layer representation of UserLocation
class UserLocationModel {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  // final String? postalCode;

  const UserLocationModel({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.state,
    this.country,
    // this.postalCode,
  });

  /// Creates a UserLocationModel from a UserLocation entity
  factory UserLocationModel.fromEntity(UserLocation location) {
    return UserLocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
      city: location.city,
      state: location.state,
      country: location.country,
      //postalCode: location.postalCode,
    );
  }

  /// Converts this model to a UserLocation entity
  UserLocation toEntity() {
    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
      state: state,
      country: country,
      // postalCode: postalCode,
    );
  }

  /// Creates a UserLocationModel from a Firestore document
  factory UserLocationModel.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return const UserLocationModel();

    return UserLocationModel(
      latitude: data['latitude'],
      longitude: data['longitude'],
      address: data['address'],
      city: data['city'],
      state: data['state'],
      country: data['country'],
      // postalCode: data['postalCode'],
    );
  }

  /// Converts this model to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      // if (postalCode != null) 'postalCode': postalCode,
    };
  }
}

/// UserProfileModel is the data layer representation of UserProfile
class UserProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserLocationModel? location;
  final DateTime createdAt;
  final DateTime lastActive;
  final Map<String, dynamic>? settings;

  const UserProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.lastActive,
    this.phoneNumber,
    this.profileImageUrl,
    this.location,
    this.settings,
  });

  /// Creates a UserProfileModel from a UserProfile entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      uid: profile.uid,
      displayName: profile.displayName,
      email: profile.email,
      role: profile.role.toString().split('.').last,
      phoneNumber: profile.phoneNumber,
      profileImageUrl: profile.profileImageUrl,
      location: profile.location != null
          ? UserLocationModel.fromEntity(profile.location!)
          : null,
      createdAt: profile.createdAt,
      lastActive: profile.lastActive,
      settings: profile.settings,
    );
  }

  /// Converts this model to a UserProfile entity
  UserProfile toEntity() {
    return UserProfile(
      uid: uid,
      displayName: displayName,
      email: email,
      role:
          role == 'businessOwner' ? UserRole.businessOwner : UserRole.customer,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      location: location?.toEntity(),
      createdAt: createdAt,
      lastActive: lastActive,
      settings: settings,
    );
  }

  /// Creates a UserProfileModel from a Firestore document
  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return UserProfileModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      location: data['location'] != null
          ? UserLocationModel.fromFirestore(
              data['location'] as Map<String, dynamic>)
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive:
          (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      settings: data['settings'] as Map<String, dynamic>?,
    );
  }

  /// Converts this model to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'role': role,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (location != null) 'location': location!.toFirestore(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      if (settings != null) 'settings': settings,
    };
  }
}
