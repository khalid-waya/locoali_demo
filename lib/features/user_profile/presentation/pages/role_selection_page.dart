import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';
import 'package:locoali_demo/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/usecases/create_user_profile_usecase.dart';
import 'package:locoali_demo/features/user_profile/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:locoali_demo/features/user_profile/presentation/pages/profile_creation_page.dart';
import 'package:locoali_demo/features/user_profile/domain/repositories/user_profile_repository.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole;
  bool _isLoading = false;
  late final CreateUserProfileUseCase _createUserProfileUseCase;
  late final GetCurrentUserProfileUseCase _getCurrentUserProfileUseCase;

  @override
  void initState() {
    super.initState();
    _createUserProfileUseCase =
        CreateUserProfileUseCase(UserProfileRepositoryImpl());
    _getCurrentUserProfileUseCase =
        GetCurrentUserProfileUseCase(UserProfileRepositoryImpl());
  }

  Future<void> _handleRoleSelection() async {
    if (_selectedRole == null) {
      CustomSnackbar.showError(
        context,
        message: 'Please select a role to continue',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _getCurrentUserProfileUseCase.execute();
      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() {
            _isLoading = false;
          });
          CustomSnackbar.showError(context, message: failure.message);
        },
        (userProfile) async {
          // Create a basic profile with the selected role
          final createResult = await _createUserProfileUseCase.execute(
            uid: userProfile.uid,
            displayName: userProfile.displayName,
            email: userProfile.email,
            role: _selectedRole!,
          );

          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });

          createResult.fold(
            (failure) {
              CustomSnackbar.showError(context, message: failure.message);
            },
            (profile) {
              // Navigate to profile creation page to complete profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileCreationPage(
                    userProfile: profile,
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      CustomSnackbar.showError(
        context,
        message: 'Error selecting role: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate content width - use iPhone 16 Pro Max width for large screens
    final contentWidth = screenWidth > DeviceBreakpoints.iPadAir
        ? DeviceBreakpoints.iphoneProMax * 0.9 // 90% of iPhone 16 Pro Max width
        : screenWidth * 0.9; // 90% of screen width for smaller screens

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How will you use Locoali?',
                      style: AppTypography.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Select the option that best describes you',
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Customer Role Card
                    _buildRoleCard(
                      title: 'Customer',
                      description: 'I want to discover and use local services',
                      icon: Icons.person,
                      role: UserRole.customer,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Business Owner Role Card
                    _buildRoleCard(
                      title: 'Business Owner',
                      description: 'I want to offer services to customers',
                      icon: Icons.business,
                      role: UserRole.businessOwner,
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Continue Button
                    ElevatedButton(
                      onPressed: _handleRoleSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(contentWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required UserRole role,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.accent1 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorPalette.primary : ColorPalette.borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? ColorPalette.primary : ColorPalette.accent1,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : ColorPalette.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: ColorPalette.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: ColorPalette.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Radio<UserRole>(
              value: role,
              groupValue: _selectedRole,
              onChanged: (UserRole? value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              activeColor: ColorPalette.primary,
            ),
          ],
        ),
      ),
    );
  }
}
