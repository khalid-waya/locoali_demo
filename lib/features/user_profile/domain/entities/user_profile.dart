import 'package:equatable/equatable.dart';

/// UserRole defines the possible roles a user can have in the application
enum UserRole {
  customer,
  businessOwner,
}

/// UserLocation represents the user's geographic location information
class UserLocation extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  // final String? postalCode;

  const UserLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.state,
    this.country,
    //this.postalCode,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        city,
        state,
        country,
        // postalCode,
      ];

  /// Creates a copy of this UserLocation with the given fields replaced with new values
  UserLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? country,
    // String? postalCode,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      // postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Creates an empty UserLocation
  static UserLocation empty() {
    return const UserLocation();
  }
}

/// UserProfile represents a user's profile information in the application
class UserProfile extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserLocation? location;
  final DateTime createdAt;
  final DateTime lastActive;
  final Map<String, dynamic>? settings;

  const UserProfile({
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

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        role,
        phoneNumber,
        profileImageUrl,
        location,
        createdAt,
        lastActive,
        settings,
      ];

  /// Creates a copy of this UserProfile with the given fields replaced with new values
  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    UserRole? role,
    String? phoneNumber,
    String? profileImageUrl,
    UserLocation? location,
    DateTime? createdAt,
    DateTime? lastActive,
    Map<String, dynamic>? settings,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
    );
  }

  /// Creates an empty UserProfile with default values
  static UserProfile empty() {
    return UserProfile(
      uid: '',
      displayName: '',
      email: '',
      role: UserRole.customer, // Default role
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );
  }
}
