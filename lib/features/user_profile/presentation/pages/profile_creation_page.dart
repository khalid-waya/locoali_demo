import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';
import 'package:locoali_demo/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:locoali_demo/features/dashboard/presentation/pages/customer_dashboard_page.dart';
import 'package:locoali_demo/features/dashboard/presentation/pages/business_dashboard_page.dart';

class ProfileCreationPage extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileCreationPage({
    required this.userProfile,
    super.key,
  });

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;
  late final TextEditingController _postalCodeController;

  bool _isLoading = false;
  late final UpdateUserProfileUseCase _updateUserProfileUseCase;

  @override
  void initState() {
    super.initState();
    _updateUserProfileUseCase =
        UpdateUserProfileUseCase(UserProfileRepositoryImpl());

    // Initialize controllers with existing data if available
    _nameController =
        TextEditingController(text: widget.userProfile.displayName);
    _phoneController =
        TextEditingController(text: widget.userProfile.phoneNumber ?? '');
    _addressController =
        TextEditingController(text: widget.userProfile.location?.address ?? '');
    _cityController =
        TextEditingController(text: widget.userProfile.location?.city ?? '');
    _stateController =
        TextEditingController(text: widget.userProfile.location?.state ?? '');
    _countryController =
        TextEditingController(text: widget.userProfile.location?.country ?? '');
    // _postalCodeController = TextEditingController(
    //     text: widget.userProfile.location?.postalCode ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleProfileUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create updated location
      final updatedLocation = UserLocation(
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        // postalCode: _postalCodeController.text,
        // We'll add latitude and longitude later when we implement map selection
      );

      // Create updated profile
      final updatedProfile = widget.userProfile.copyWith(
        displayName: _nameController.text,
        phoneNumber: _phoneController.text,
        location: updatedLocation,
        lastActive: DateTime.now(),
      );

      final result =
          await _updateUserProfileUseCase.execute(profile: updatedProfile);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      result.fold(
        (failure) {
          CustomSnackbar.showError(context, message: failure.message);
        },
        (profile) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Profile updated successfully!',
          );

          // Navigate to the appropriate dashboard based on user role
          _navigateToDashboard(profile.role);
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      CustomSnackbar.showError(
        context,
        message: 'Error updating profile: ${e.toString()}',
      );
    }
  }

  void _navigateToDashboard(UserRole role) {
    Widget dashboardPage;

    if (role == UserRole.businessOwner) {
      dashboardPage = const BusinessDashboardPage();
    } else {
      dashboardPage = const CustomerDashboardPage();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => dashboardPage),
      (route) => false, // Remove all previous routes
    );
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
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: contentWidth,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: AppTypography.headlineSmall,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Name field
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Phone field
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Text(
                          'Address Information',
                          style: AppTypography.headlineSmall,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Address field
                        _buildTextField(
                          controller: _addressController,
                          label: 'Street Address',
                          icon: Icons.home,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // City and State fields in a row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _cityController,
                                label: 'City',
                                icon: Icons.location_city,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: _buildTextField(
                                controller: _stateController,
                                label: 'State/Province',
                                icon: Icons.map,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Country and Postal Code fields in a row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _countryController,
                                label: 'Country',
                                icon: Icons.public,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: _buildTextField(
                                controller: _postalCodeController,
                                label: 'Postal Code',
                                icon: Icons.markunread_mailbox,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Save Button
                        ElevatedButton(
                          onPressed: _handleProfileUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.primary,
                            foregroundColor: Colors.white,
                            minimumSize: Size(contentWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save and Continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
